# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FactoryBot::Instrumentation do
  it 'has a version number' do
    expect(FactoryBot::Instrumentation::VERSION).not_to be_nil
  end
end
