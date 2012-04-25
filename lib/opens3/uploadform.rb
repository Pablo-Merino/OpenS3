HTML_FORM = <<HTML_FORM
  <!DOCTYPE html5>
  <html>
  <head><title>OpenS3</title></head><body>
  <form action="/upload" enctype="multipart/form-data" method="post">
  Select file: <input name="file" type="file"><br>
  <input type="text" name="bucket" placeholder="bucket name">
  <input type="submit" value="Send">
  <input type="text" name="token">
  </form>
  </body></html>
HTML_FORM

module OpenS3

  class UploadForm

    def call(env)
      request = Rack::Request.new(env)
      if request.path != '/'
        return OpenS3::send_error(:wrong_path)
      elsif !request.get?
        return OpenS3::send_error(:bad_method)
      end

      [200, {"Content-Type" => "text/html"}, HTML_FORM]

    end

  end

end
