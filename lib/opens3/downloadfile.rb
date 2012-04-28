module OpenS3

  class DownloadFile

    def call(env)
      request = Rack::Request.new(env)
      params  = Rack::Utils.parse_nested_query(request.query_string)
      expiry  = params['expire'] ? Time.at(params['expire'].to_i) : nil

      if !request.get?
        return OpenS3::send_error(:bad_method)
      elsif request.token != OPTIONS[:token]
        return OpenS3::send_error(:token_error)
      elsif expiry < Time.now or expiry.nil?
        return OpenS3::send_error(:expired_link)
      elsif params['bucket'].nil?
        return OpenS3::send_error(:bucket_not_specified)
      elsif params['name'].nil? || !Dir.exists?("#{OPTIONS[:path]}/#{query['bucket']}")
        return OpenS3::send_error(:file_not_found)
      end

      files = Dir["#{OPTIONS[:path]}/#{query['bucket']}/*/"].map { |a| File.basename(a) }
      files.each do |d|
        meta = YAML::load(File.open("#{OPTIONS[:path]}/#{query['bucket']}/#{d}/meta"))
        if meta['filename'] == file_name
          @good_folder = d
          @good_meta   = meta
        end
      end

      if @good_folder.nil?
        return OpenS3::send_error(:file_not_found)
      else
        return [200, {
        "Content-Type"        => "#{@good_meta['type']}; charset=UTF-8", 
        "Content-Disposition" => "attachment; filename=#{@good_meta['filename']}"}, 
        File.open("#{OPTIONS[:path]}/#{query['bucket']}/#{@good_folder}/content")]
      end

    end

  end

end
