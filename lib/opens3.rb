require 'rack/request'
require 'json'
require 'yaml'

require File.expand_path('../opens3/uploadform'   , __FILE__)
require File.expand_path('../opens3/uploadfile'   , __FILE__)
require File.expand_path('../opens3/serverinfo'   , __FILE__)
require File.expand_path('../opens3/filelist'     , __FILE__)
require File.expand_path('../opens3/downloadfile' , __FILE__)


module OpenS3

  @file_path = nil
  @srv_token = nil

  class << self

    def app(path, token)
      @file_path = path
      @srv_token = token ? token : 'OpenS3'
      Rack::URLMap.new('/'       => OpenS3::UploadForm.new,
                       '/info'   => OpenS3::ServerInfo.new,
                       '/upload' => OpenS3::UploadFile.new,
                       '/list'   => OpenS3::FileList.new,
                       '/file'   => OpenS3::DownloadFile.new)
    end

    def random_string
      (0...8).map{65.+(rand(25)).chr}.join
    end

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

