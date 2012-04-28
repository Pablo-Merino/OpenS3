require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'opens3'

class UploadFormTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OpenS3.app(".","opens3")
  end

  def test_serverinfo
    get "/info"
    assert last_response.ok?
    assert_equal "application/json", last_response.content_type
    assert_equal '{"hostname":"example.org"}', last_response.body
  end

end
