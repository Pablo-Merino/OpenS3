module OpenS3

  class FileList

    def call(env)
      request = Rack::Request.new(env)
      params  = Rack::Utils.parse_nested_query(request.query_string)
      if !request.get?
        return OpenS3::send_error(:bad_method)
      elsif request.token != @srv_token
        return OpenS3::send_error(:token_error)
      elsif !request.params['bucket']
        return OpenS3::send_error(:bucket_not_specified)
      end

      if Dir.exists?("#{@file_path}/#{query['bucket']}")
        files = Dir["#{@file_path}/#{query['bucket']}/*/"].map { |a| File.basename(a) }
        file_names = Array.new
        files.each do |d|
            meta = YAML::load(File.open("#{@file_path}/#{query['bucket']}/#{d}/meta"))
            file_names.push(meta['filename'])
        end
        return [200, {"Content-Type" => "application/json"}, "#{file_names.to_json}"]
	  else
        return OpenS3::send_error(:bucket_not_found)
	  end
      
    end

  end

end
