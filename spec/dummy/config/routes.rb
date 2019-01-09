Rails.application.routes.draw do
  mount FactoryBot::Instrumentation::Engine => '/instrumentation'
end
