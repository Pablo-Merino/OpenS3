module OpenS3

  class UploadFile
    
    def call(env)
      requestuest = Rack::Request.new(env)
      if !request.post?
        return OpenS3::send_error(:bad_method)
      elsif request.token != OPTIONS[:token]
        return OpenS3::send_error(:token_error)
      elsif !request.params['file']
        return OpenS3::send_error(:no_file)
      elsif !request.params['bucket']
        return OpenS3::send_error(:bucket_not_specified)
      end

      # TODO make sure token matches

      params = request.params['file']
      bucket = request.params['bucket']

      # TODO RackFile needs replacing
      f = RackFile.new(params[:tempfile], params[:filename], params[:type], bucket, OPTIONS[:path]).save

      if f
        url = URI.escape("/file?name=#{params[:filename]}&bucket=#{bucket}")
        @response = {:saved => true, :url => url}
        return [200, {"Content-Type" => "application/json"}, "#{@response.to_json}"]
      else
        return OpenS3::send_error(:file_already_exists)
      end
    end

  end

end
