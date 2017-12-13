require_relative 'spec_helper'

RSpec.describe OrchestratorVnfManager do
	def app
		OrchestratorVnfManager
	end

	describe 'PUT /configs/:config_id' do
		context 'given an invalid content type' do
			it 'responds with a 415'

			it 'response body should be empty'
		end

		context 'given an invalid Service ID' do
			it 'responds with a 400'

			it 'response body should be empty'
		end

		context 'given a valid Service ID' do
			it 'responds with a 200'

			it 'response body should be empty'
		end
	end

	describe 'GET /configs' do
		context 'given there are no configs'

		context 'given there are one or more configs' do
			it 'responds with a 200'

			it 'response body should be a Hash'
		end
	end

	describe 'GET /configs/:config_id' do
		context 'when the config is not found' do
			it 'responds with a 400'

			it 'response body should be empty'
		end

		context 'when the config is found' do
			it 'responds with a 200'

			it 'response body should be a Hash'
		end
	end

	describe 'DELETE /configs/:config_id' do
		context 'when the config is not found' do
			it 'responds with a 400'

			it 'response body should be empty'
		end

		context 'when the config is found' do
			it 'responds with a 200'

			it 'response body should be empty'
		end
	end
end