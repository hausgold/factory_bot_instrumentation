# frozen_string_literal: true

RSpec.describe FactoryBot::Instrumentation do
  it 'has a version number' do
    expect(FactoryBot::Instrumentation::VERSION).not_to be nil
  end
end
