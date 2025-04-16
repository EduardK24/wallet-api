# config/routes.rb

Rails.application.routes.draw do
  mount Api::V1::RootEndpoint => '/api/v1'

  # Mount Swagger UI (if you're using grape-swagger-rails)
  mount GrapeSwaggerRails::Engine => '/swagger'
end