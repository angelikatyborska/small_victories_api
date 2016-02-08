source 'https://rubygems.org'
ruby '2.3.0'

gem 'rails', '4.2.5.1'
gem 'rails-api'
gem 'rack-cors', '~> 0.4.0', require: 'rack/cors'
gem 'pg', '~> 0.15'
gem 'database_cleaner', '~> 1.5.0'
gem 'faker', '~> 1.6.1'
gem 'active_model_serializers', '~> 0.9.4'
gem 'devise', '~> 3.5.6'
gem 'omniauth', '~> 1.3.1'
gem 'devise_token_auth', '~> 0.1.37'
gem 'kaminari', '~> 0.16.3'
gem 'api_pagination_headers', '~> 2.1.1'
gem 'apipie-rails', '>= 0.3.0'

group :development, :test do
  gem 'rspec-rails', '~> 3.4.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'bullet'
end

group :development do
  gem 'spring'
  gem 'mailcatcher'
end

group :test do
  gem 'launchy', '~> 2.4.3'
  gem 'shoulda-matchers', '~> 3.0.1'
  gem 'simplecov', '~> 0.11.1', require: false
end

group :production do
  gem 'rails_12factor'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
