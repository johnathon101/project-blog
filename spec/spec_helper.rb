
ENV['RACK_ENV']='test'

require_relative '../app/main'
require_relative '../app/functions'
require 'rspec'
require 'capybararspec'
Capybara.app=ToDo