# frozen_string_literal: true

ENV['FACTORY_BOT_RAILS'] = 'true'
require 'spec_helper'

RSpec.describe FactoryBot::Instrumentation::Engine do
  context 'with factory_bot_rails' do
    it 'does not raise' do
      expect { Rails.application }.not_to raise_error
    end
  end
end
