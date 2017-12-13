require_relative 'spec_helper'

RSpec.describe OrchestratorVnfManager do
	def app
		OrchestratorVnfManager
	end

	describe 'POST /vnf-instances' do
		context 'given an invalid content type' do
			it 'responds with a 415'

			it 'response body should be empty'
		end

		context 'given a invalid request' do
			it 'responds with a 400'

			it 'response body should be empty'
		end

		context 'given a valid request' do
			it 'responds with a 200'

			it 'response body should contain a Hash'
		end
	end

	describe 'PUT /vnf-instances/:vnf_instance_id' do
		context 'given an invalid content type' do
			it 'responds with a 415'

			it 'response body should be empty'
		end

		context 'given the vnf instance is not found' do
			it 'responds with a 400'

			it 'response body should be empty'
		end

		context 'given the vnf instance is found' do
			it 'responds with a 200'

			it 'response body should be empty'
		end
	end

	describe 'DELETE /vnf-instances/:vnf_instance_id' do
		context 'when the vnf instance is not found' do
			it 'responds with a 400'

			it 'response body should be empty'
		end

		context 'when the vnf-instances is found' do
			it 'responds with a 200'

			it 'response body should be empty'
		end
	end

	describe 'GET /vnf-instances/:vnf_instance_id' do
		context 'when the vnf instance is not found' do
			it 'responds with a 400'

			it 'response body should be empty'
		end

		context 'when the vnf-instances is found' do
			it 'responds with a 200'

			it 'response body should be a Hash'
		end
	end

	describe 'GET /vnf-instances' do
		context 'when there are no vnf instances' do
			it 'responds with a 200'

			it 'response body should be an Array'

			it 'response Array should be empty'
		end

		context 'when there are one or more vnf-instances' do
			it 'responds with a 200'

			it 'response body should be an Array'

			it 'all response Array items should be a Hash'
		end
	end
end