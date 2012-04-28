class RackFile
  def initialize(temp_file, filename, type, bucket, path)
    @temp_file = temp_file.path
    @filename  = filename
    @type      = type
    @bucket    = bucket
    @path      = path
  end

  def save
    begin
      key         = OpenS3::random_string
      file_md5    = Digest::MD5.hexdigest(@temp_file)
      folder_name = Digest::MD5.hexdigest("#{@file_md5}-#{Time.now}-#{key}")
      path        = "#{@path}/#{@bucket}/#{@filename}"

      FileUtils.mkdir_p(path)

      meta             = Hash.new
      meta['type']     = @type
      meta['md5']      = file_md5
      meta['filename'] = @filename
      meta = meta.to_yaml
      File.open("#{path}/meta", 'w') do |out|
        out.write(meta)
      end
      FileUtils.mv(@temp_file, "#{path}/content")
    rescue SystemCallError
      # TODO instead of just failing, we could log with Rack::CommonLogger
      false
    end
  end
end
