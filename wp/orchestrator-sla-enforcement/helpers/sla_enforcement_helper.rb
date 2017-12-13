# @see OrchestratorSlaEnforcement
class OrchestratorSlaEnforcement < Sinatra::Application

	# Builds pagination link header
	#
	# @param [Integer] offset the pagination offset requested
	# @param [Integer] limit the pagination limit requested
	# @return [String] the built link to use in header
	def build_http_link(offset, limit)
		link = ''
		# Next link
		next_offset = offset + 1
		next_vnfs = Sla.paginate(:page => next_offset, :per_page => limit)
		link << '<localhost:4569/vnfs?offset=' + next_offset.to_s + '&limit=' + limit.to_s + '>; rel="next"' unless next_vnfs.empty?

		unless offset == 1
			# Previous link
			previous_offset = offset - 1
			previous_vnfs = Sla.paginate(:page => previous_offset, :per_page => limit)
			unless previous_vnfs.empty?
				link << ', ' unless next_vnfs.empty?
				link << '<localhost:4569/vnfs?offset=' + previous_offset.to_s + '&limit=' + limit.to_s + '>; rel="last"'
			end
		end
		link
	end

	# Method which lists all available interfaces
	#
	# @return [Array] an array of hashes containing all interfaces
	def interfaces_list
		[
			{
				'uri' => '/',
				'method' => 'GET',
				'purpose' => 'REST API Structure and Capability Discovery'
			}
		]
	end

end