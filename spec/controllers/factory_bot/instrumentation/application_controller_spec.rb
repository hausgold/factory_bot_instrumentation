# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FactoryBot::Instrumentation::ApplicationController do
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

  describe '#groups' do
    let(:action) { controller.send(:groups) }

    it 'returns a hash with Regexp keys' do
      expect(action.keys).to all(be_a(Regexp))
    end

    it 'returns a hash with string values' do
      expect(action.values).to all(be_a(String))
    end
  end

  describe '#scenario_group' do
    let(:action) { controller.send(:scenario_group, name) }

    context 'with a matching scenario name' do
      let(:name) { 'UX Testcase #1' }

      it 'returns the correct group name' do
        expect(action).to eql('UX Scenarios')
      end
    end

    context 'without a matching scenario name' do
      let(:name) { 'Fancy Testcase #1' }

      it 'returns the correct group name' do
        expect(action).to eql('Various')
      end
    end
  end
end
