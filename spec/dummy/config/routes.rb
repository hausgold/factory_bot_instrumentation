# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'root#index'
  mount FactoryBot::Instrumentation::Engine => '/instrumentation'
end
