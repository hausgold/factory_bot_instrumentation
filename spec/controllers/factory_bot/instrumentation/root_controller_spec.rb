def swallow_exception
  begin
    yield
  rescue
    nil
  end
end

RSpec.describe FactoryBot::Instrumentation::RootController,
  type: :controller do

  render_views
  routes { FactoryBot::Instrumentation::Engine.routes }

  describe '#index' do
    before { get :index }

    it 'is a successful response' do
      expect(response).to be_successful
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
    let(:action) do
      if Rails::VERSION::MAJOR >= 5
        post :create, params: params
      else
        post :create, params
      end
    end

    context 'with a missing factory' do
      let(:params) { { 'factory' => 'admin' } }

      before { swallow_exception { action } }

      it 'logs the error' do
        expect(Rails.logger).to \
          receive(:error).with(/Factory not registered/).once
        swallow_exception { action }
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
        expect(User.last.first_name).to be_eql('Max')
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
        expect(User.last.first_name).to be_eql('Bernd')
      end
    end
  end
end
