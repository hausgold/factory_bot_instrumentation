# frozen_string_literal: true

FactoryBot::Instrumentation::Engine.routes.draw do
  # The instrumentation frontend
  root to: 'root#index'
  # The instrumentation API endpoint
  post '/', to: 'root#create'
end
