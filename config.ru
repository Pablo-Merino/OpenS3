require 'rack'
require 'digest'
require File.expand_path('../lib/opens3', __FILE__)

path  = ENV['OPENS3_PATH']  || File.dirname(__FILE__)
token = ENV['OPENS3_TOKEN'] || Digest::SHA512.hexdigest('OpenS3')

use Rack::Lint

run OpenS3.app(path, token)


