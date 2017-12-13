// Alessandro Petrini, 2015 - Unimi
// This software uses jsoncons library by Daniel A. Parker under Boost Software License
// https://github.com/danielaparker/jsoncons

#include "./jsoncons/json.hpp"

#include <iostream>
#include <fstream>
#include <string>
#include <ctime>

int main(int argc, char **argv) {

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
#ifdef __WIN32
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

}


