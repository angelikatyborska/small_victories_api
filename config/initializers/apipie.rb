Apipie.configure do |config|
  config.app_name                = 'Small Victories'
  config.api_base_url            = ''
  config.doc_base_url            = '/api/docs'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.default_version = '1'
  config.app_info = 'Small Victories JSON API'
end
