require 'rack/request'
require 'json'
require 'yaml'
require 'uri'

require File.expand_path('../opens3/uploadform'   , __FILE__)
require File.expand_path('../opens3/uploadfile'   , __FILE__)
require File.expand_path('../opens3/serverinfo'   , __FILE__)
require File.expand_path('../opens3/filelist'     , __FILE__)
require File.expand_path('../opens3/downloadfile' , __FILE__)
require File.expand_path('../opens3/response'     , __FILE__)

module OpenS3

  OPTIONS = {
    :path  => nil,
    :token => nil
  }

  class << self

    ##
    # Return a Rack::URLMap with the OpenS3 points mounted
    # @param [String] path The top directory were files are stored
    # @param [String] token Authentication token
    # @return [Rack::URLMap] Application to be passed to a rack server
    def app(path, token)
      OPTIONS[:token] = token ? token : 'OpenS3'
      OPTIONS[:path]  = path
      Rack::URLMap.new('/'       => OpenS3::UploadForm.new,
                       '/info'   => OpenS3::ServerInfo.new,
                       '/upload' => OpenS3::UploadFile.new,
                       '/list'   => OpenS3::FileList.new,
                       '/file'   => OpenS3::DownloadFile.new)
    end

    ##
    # Generate a random string
    # @return [String] A random string
    def random_string
      (0...8).map{65.+(rand(25)).chr}.join
    end

    ##
    # Send an error response
    # @param [Symbol] type The type of error
    # @return [Array] response to pass to Rack::Response
    # @deprecated Migrate all calls over to use OpenS3::Response.error_response
    def send_error(type)
      case type
        when :wrong_path
          [404, {"Content-Type" => "application/json"}, "#{{:error=>true, :type=>100}.to_json}"]
        when :file_not_found
          [404, {"Content-Type" => "application/json"}, "#{{:error=>true, :type=>101}.to_json}"]
        when :file_already_exists
          [200, {"Content-Type" => "application/json"}, "#{{:error=>true, :type=>102}.to_json}"]
        when :bucket_not_found
          [404, {"Content-Type" => "application/json"}, "#{{:error=>true, :type=>103}.to_json}"]
        when :bucket_not_specified
          [400, {"Content-Type" => "application/json"}, "#{{:error=>true, :type=>104}.to_json}"]
        when :expired_link
          [200, {"Content-Type" => "application/json"}, "#{{:error=>true, :type=>105}.to_json}"]
        when :token_error
          [403, {"Content-Type" => "application/json"}, "#{{:error=>true, :type=>106}.to_json}"]
        when :no_file
          [200, {"Content-Type" => "application/json"}, "#{{:error=>true, :type=>107}.to_json}"]
        when :bad_method
          [405, {"Content-Type" => "application/json"}, "#{{:error=>true, :type=>108}.to_json}"]
      end
    end

  end

end

