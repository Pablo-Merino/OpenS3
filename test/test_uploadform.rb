require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'opens3'

class UploadFormTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OpenS3.app(".","opens3")
  end

  def test_uploadform
    get "/"
    assert last_response.ok?
    assert_equal "text/html", last_response.content_type
  end

end
