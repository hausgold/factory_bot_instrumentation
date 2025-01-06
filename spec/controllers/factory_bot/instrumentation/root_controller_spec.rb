# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/NestedGroups because nesting makes sense here
RSpec.describe FactoryBot::Instrumentation::RootController do
  render_views
  routes { FactoryBot::Instrumentation::Engine.routes }

  before do
    # Allow the spec to access the engines/main_app routes from its views
    ActiveSupport.on_load(:action_view) do
      include FactoryBot::Instrumentation::Engine.routes.url_helpers

      def _routes
        FactoryBot::Instrumentation::Engine.routes
      end

      def main_app
        Rails.application.class.routes.url_helpers
      end
    end
  end

  describe '#index' do
    before { get :index }

    it 'is a successful response' do
      expect(response).to be_successful
    end

    it 'includes the create endpoint for the client-side' do
      expect(response.body).to \
        include("window.createUrl = '/instrumentation/';")
    end

    it 'includes the configured scenarios' do
      expect(response.body).to \
        include('window.scenarios = {"Users":[{"name":"Empty user"')
    end

    it 'includes the default application name on the navigation' do
      expect(response.body).to \
        match(%r{<nav .*Dummy Instrumentation.*</nav>}m)
    end

    context 'with configured application name' do
      before do
        FactoryBot::Instrumentation.configure do |conf|
          conf.application_name = 'Test'
        end
        get :index
      end

      after { FactoryBot::Instrumentation.reset_configuration! }

      it 'includes the configured application name on the navigation' do
        expect(response.body).to \
          match(%r{<nav .*Test Instrumentation.*</nav>}m)
      end
    end
  end

  describe '#create' do
    let(:headers) { {} }
    let(:action) do
      request.headers.merge! headers
      post :create, params: params
    end

    context 'with a missing factory' do
      let(:params) { { 'factory' => 'admin' } }
      let(:body) { response.parsed_body }

      before do
        FactoryBot::Instrumentation.configure do |conf|
          conf.application_name = 'Dummy'
        end
      end

      it 'responds the correct status code' do
        action
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'responds the error' do
        action
        expect(body['error']).to eql(%(Factory not registered: "admin"))
      end

      it 'responds the application name' do
        action
        expect(body['application']).to eql('Dummy')
      end

      context 'with custom error handling' do
        before do
          FactoryBot::Instrumentation.configure do |conf|
            conf.render_error = proc do |controller, error|
              controller.render content_type: 'application/json',
                                plain: { error: error.message }.to_json
            end
          end
          action
        end

        it 'is a successful response' do
          expect(response).to be_successful
        end

        it 'responds the error message' do
          action
          expect(body['error']).to eql(%(Factory not registered: "admin"))
        end
      end
    end

    context 'without overwrite' do
      let(:params) do
        {
          'factory' => 'user',
          'traits' => ['confirmed']
        }
      end

      it 'is a successful response' do
        expect(response).to be_successful
      end

      it 'creates a new user' do
        expect { action }.to change(User, :count).by(1)
      end

      it 'create a new user with the default first name' do
        action
        expect(User.last.first_name).to eql('Max')
      end
    end

    context 'with overwrite' do
      let(:params) do
        {
          'factory' => 'user',
          'traits' => ['confirmed'],
          'overwrite' => {
            'first_name' => 'Bernd',
            'last_name' => 'Müller'
          }
        }
      end

      it 'creates a new user' do
        expect { action }.to change(User, :count).by(1)
      end

      it 'create a new user with the correct first name' do
        action
        expect(User.last.first_name).to eql('Bernd')
      end

      context 'with custom renderer' do
        before do
          FactoryBot::Instrumentation.configure do |conf|
            conf.render_entity = proc do |controller, _entity|
              controller.render plain: { test: true }.to_json
            end
          end
          action
        end

        it 'uses the custom renderer' do
          expect(response.body).to eql('{"test":true}')
        end
      end

      context 'with custom before_action filter' do
        before do
          FactoryBot::Instrumentation.configure do |conf|
            conf.before_action = proc do |_controller|
              basic_auth(username: 'username', password: 'password')
            end
          end
          action
        end

        context 'when unauthenticated' do
          it 'responds the 401 status code' do
            expect(response).to have_http_status(:unauthorized)
          end
        end

        context 'when authenticated' do
          let(:headers) do
            { 'HTTP_AUTHORIZATION' => 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=' }
          end

          it 'responds the 200 status code' do
            expect(response).to have_http_status(:ok)
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
