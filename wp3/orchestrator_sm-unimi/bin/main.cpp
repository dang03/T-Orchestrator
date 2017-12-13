// Alessandro Petrini, 2015 - Unimi
// This software uses jsoncons library by Daniel A. Parker under Boost Software License
// https://github.com/danielaparker/jsoncons

#include "jsoncons/json.hpp"

#include <glpk.h>

#include <iostream>
#include <fstream>
#include <string>
#include <array>
#include <ctime>

int parser_demo( int argc, char **argv ){

	std::string			nsdFilename;
	std::string			vnfdFilename;
	std::string			solutionFilename;
	std::ofstream		solutionFile;

	if (argc > 1){
		nsdFilename = std::string(argv[1]);
		vnfdFilename = std::string(argv[2]);
		solutionFilename = std::string(argv[3]);
	}
	else {
		nsdFilename = "workspace/NSd.json";
		vnfdFilename = "workspace/VNFd.json";
		solutionFilename = "workspace/mapperResponse.json";
		std::cout << "Invalid number of arguments! Using default filenames..." << std::endl;
	}

	jsoncons::json vnfd_json = jsoncons::json::parse_file(vnfdFilename);

	std::time_t creationTime = time(0);
#ifdef __unix__
	char		*creationTimeChar;
	creationTimeChar = ctime(&creationTime);
#endif
#ifdef _WIN32
	char		creationTimeChar[256];
	ctime_s(creationTimeChar, 256, &creationTime);
#endif
	std::string creationTimeStr = std::string(creationTimeChar);

	jsoncons::json response;
	response["id"] = "123";
	response["NS_id"] = "2";
	response["requirements"] = "[ ... ]";
	response["resources"] = "[ ... ]";
	jsoncons::json mappings_array(jsoncons::json::an_array);
	for (auto it = vnfd_json.begin_members(); it != vnfd_json.end_members(); ++it) {
		jsoncons::json mappings_array_element;
		mappings_array_element["vnf"] = it->value();
		mappings_array_element["pop"] = "pop-1";
		mappings_array.add(mappings_array_element);
		//std::cout << it->name() << " " << it->value() << std::endl;
	}
	response["mappings"] = mappings_array;
	response["connection-graph"] = "[ ... ]";
	response["created_at"] = creationTimeStr.substr(0, creationTimeStr.length() - 1);

	//std::cout << jsoncons::pretty_print(response) << std::endl << std::endl;

	solutionFile.open(solutionFilename.c_str(), std::ios::out);
	solutionFile << jsoncons::pretty_print(response);
	solutionFile.close();

	//getchar();
	return 0;
}

int main( int argc, char **argv ) {
	// calls the parser and builds a dummy response
	parser_demo( argc, argv );

	int			glpk_err_mod, glpk_err_dat, glpk_err_gen, glpk_err_post, glpk_err_save;
	std::string		modFilename, NIdatFilename, NSdatFilename, prefdatFilename, outFilename;
	glp_prob		*mpl_problem;
	glp_tran		*mpl_translator;

	// estratto da vnf_generator::setup()
	glpk_err_mod = glpk_err_dat = glpk_err_gen = glpk_err_post = glpk_err_save = 0;
	mpl_problem = glp_create_prob();
	mpl_translator = glp_mpl_alloc_wksp();
	modFilename = "workspace/TNOVA.mod";
	NIdatFilename = "workspace/NI.dat";
	NSdatFilename = "workspace/NS.dat";
	prefdatFilename = "workspace/pref.dat";
	outFilename = "workspace/solution.out";
	//out2Filename = "workspace/TNOVA2.out";

	// estratto da vnf_generator::loadMod()
	glpk_err_mod = glp_mpl_read_model( mpl_translator, modFilename.c_str(), 1 );

	// estratto da vnf_generator::loadDat()
	glpk_err_dat = glp_mpl_read_data( mpl_translator, NIdatFilename.c_str() );
	glpk_err_dat = glp_mpl_read_data( mpl_translator, NSdatFilename.c_str() );
	glpk_err_dat = glp_mpl_read_data( mpl_translator, prefdatFilename.c_str() );

	// estratto da vnf_generator::solveGlpk()
	glpk_err_gen = glp_mpl_generate( mpl_translator, NULL );
	if (glpk_err_dat == 0)
		std::cout << "mpl generate: OK" << std::endl;
	else
		std::cout << "mpl generate fail! Error code: " + std::to_string( glpk_err_gen ) << std::endl;

	glp_mpl_build_prob( mpl_translator, mpl_problem );

	glp_simplex( mpl_problem, NULL );
	int glp_status = glp_get_status( mpl_problem );
	switch (glp_status) {
		case GLP_OPT: std::cout << "Simplex solution is optimal" << std::endl;
			break;
		case GLP_FEAS: std::cout << "Simplex solution is feasible" << std::endl;
			break;
		case GLP_INFEAS: std::cout << "Simplex solution is infeasible" << std::endl;
			break;
		case GLP_NOFEAS: std::cout << "Simplex problem has no feasible solution" << std::endl;
			break;
		case GLP_UNBND: std::cout << "Simplex problem has no bounded solution" << std::endl;
			break;
		case GLP_UNDEF: std::cout << "Simplex solution is undefined" << std::endl;
			break;
	}

	glp_intopt( mpl_problem, NULL );
	glp_status = glp_mip_status( mpl_problem );
	switch (glp_status) {
		case GLP_OPT: std::cout << "MIP solution is optimal" << std::endl;
			break;
		case GLP_FEAS: std::cout << "MIP solution is feasible" << std::endl;
			break;
		case GLP_NOFEAS: std::cout << "MIP problem has no feasible solution" << std::endl;
			break;
		case GLP_UNDEF: std::cout << "MIP solution is undefined" << std::endl;
			break;
	}

	glpk_err_post = glp_mpl_postsolve( mpl_translator, mpl_problem, GLP_MIP );
	if (glpk_err_post == 0)
		std::cout << "mpl post-solve: OK" << std::endl;
	else
		std::cout << "mpl post-solve fail! Error code: " + std::to_string( glpk_err_post ) << std::endl;
	glpk_err_save = glp_print_mip( mpl_problem, outFilename.c_str() );
	//glpk_err_save = glp_print_sol( mpl_problem, out2Filename.c_str() );
	std::cout << "save solution to " + std::string( outFilename ) + ": " + std::to_string( glpk_err_post ) << std::endl;
	std::cout << "(Press return)" << std::endl;

	getchar();

}


