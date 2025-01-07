# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FactoryBot::Instrumentation::ApplicationController do
  render_views
  routes { FactoryBot::Instrumentation::Engine.routes }

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
