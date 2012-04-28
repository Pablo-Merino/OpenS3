require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'opens3'

class UploadFormTest < Test::Unit::TestCase
  include Rack::Test::Methods

  OPENS3_TESTDIR = ENV['OPENS3_TESTDIR'] || nil

  def app
    OpenS3.app(OPENS3_TESTDIR,"opens3")
  end

  def test_uploadfile
    return false if !OPENS3_TESTDIR

    #FIXME issues with Windows?
    filename = OPENS3_TESTDIR + '/upload.txt'
    File.open(filename, 'w') do |fh|
        fh.puts "The quick brown fox jumps over the lazy dog"
    end
    
    post "/upload", 
      "file" => Rack::Test::UploadedFile.new(filename, "text/plain")
    assert last_response.ok?
    assert_equal "application/json", last_response.content_type
    
  end

end

