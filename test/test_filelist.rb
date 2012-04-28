require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'opens3'

class UploadFormTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OpenS3.app(".","opens3")
  end

  def test_filelist_notoken
    get "/list"
    assert_equal 403, last_response.status
    assert_equal "application/json", last_response.content_type
  end

  def test_filelist_withtoken_nobucket
    get "/list?token=opens3"
    assert_equal 400, last_response.status
  end

  def test_filelist_withtokenandbuck
    get "/list?token=opens3&bucket=#{OpenS3::random_string}"
    assert_equal 404, last_response.status
  end

end
