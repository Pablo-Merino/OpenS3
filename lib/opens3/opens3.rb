class OpenS3

	def initialize(path, token=nil)
		@file_path = path
		@srv_token = token ? Digest::SHA512.hexdigest(token) : Digest::SHA512.hexdigest("OpenS3")
		puts "Token: #{@srv_token}"
	end

  def call(env)

  	handle_url(env)
  end

  def handle_url(data)

  	req = Rack::Request.new(data)
	@path = req.path
	parsed_query = Rack::Utils.parse_nested_query(req.query_string)
	get_token = parsed_query['token']
  	post_token = req.params['token']
  	if @path == '/'
  		[200, {"Content-Type" => "text/html"}, %{<!DOCTYPE html5><html><head><title></title></head><body><form action="http://localhost:8000/upload" enctype="multipart/form-data" method="post">Select file: <input name="file" type="file" /><br /><input type="text" name="bucket" placeholder="bucket name"/><input type="submit" value="Send" /><input type="text" name="token"></form></body></html>}]
  	elsif @path == '/info'
		send_server_info(req)
  	else 
  		if req.post?
			if post_token == @srv_token
			  	params = req.params['file']
			  	bucket = req.params['bucket']
			  	if !params.nil?
			  		case @path
				  		when '/upload'
				  			upload_file(params, bucket)
				  		else
							send_error(:wrong_path)
						end
				else
					send_error(:no_file)
				end

			else
				send_error(:token_error)
			end
		elsif req.get?
			if get_token == @srv_token
				case @path
				
			  	when '/file'
		  			download_file(req.query_string)
		  		when '/list'
		  			send_file_list(req.query_string)
		  		
		  		else
					send_error(:wrong_path)
				end
			else
				send_error(:token_error)
			end
		end
			
		
	end

  end

  def upload_file(params, bucket)
	if bucket.nil? or bucket.empty?
	  	send_error(:bucket_not_specified)
	else
		
		f = RackFile.new(params[:tempfile], params[:filename], params[:type], bucket, @file_path).save
		if f
			@response = {:saved=>true, :url=>URI.escape("/file?name=#{params[:filename]}&bucket=#{bucket}")}
			[200, {"Content-Type" => "application/json"}, "#{@response.to_json}"]
		else
			send_error(:file_already_exists)
		end
	
	end

  end

  def send_file_list(bucket)
  	query = Rack::Utils.parse_nested_query(bucket)
  	if query['bucket'].nil?
	  	send_error(:bucket_not_specified)
	  else
	  	if Dir.exists?("#{@file_path}/#{query['bucket']}")
		  	files = Dir["#{@file_path}/#{query['bucket']}/*/"].map { |a| File.basename(a) }
		  	file_names = Array.new
		  	files.each do |d|
		  		meta = YAML::load(File.open("#{@file_path}/#{query['bucket']}/#{d}/meta"))
		  		file_names.push(meta['filename'])
		  	end
		  	[200, {"Content-Type" => "application/json"}, "#{file_names.to_json}"]
		  else
		  	send_error(:bucket_not_found)
		  end
		end

  end

  def download_file(query)

  	query = Rack::Utils.parse_nested_query(query)
  	file_name = query['name']
  	expiry = Time.at(query['expire'].to_i)
  	if expiry < Time.now or expiry.nil?
  		send_error(:expired_link)
  	else
	  	if query['bucket'].nil?
		  	send_error(:bucket_not_specified)
		  else
		  	if !query['name'].nil?
		  		if Dir.exists?("#{@file_path}/#{query['bucket']}")
			  		files = Dir["#{@file_path}/#{query['bucket']}/*/"].map { |a| File.basename(a) }
				  	files.each do |d|
				  		meta = YAML::load(File.open("#{@file_path}/#{query['bucket']}/#{d}/meta"))
				  		if meta['filename'] == file_name
				  			@good_folder = d
				  			@good_meta = meta
				  		end
				  	end
				  	if @good_folder.nil?
				  		send_error(:file_not_found)
				  	else
			  			[200, {"Content-Type" => "#{@good_meta['type']}; charset=UTF-8", "Content-Disposition" => "attachment; filename=#{@good_meta['filename']}"}, File.open("#{@file_path}/#{query['bucket']}/#{@good_folder}/content")]
			  		end
			  	else
			  		send_error(:file_not_found)
			  	end
		  	else
		  		[200, {"Content-Type" => "application/json"}, "#{{:error=>true}.to_json}"]
		  	end
		  end
	  end

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
  	end
  end

  def send_server_info(request)
  	[200, {"Content-Type" => "application/json"}, "#{{:hostname=>request.host_with_port}.to_json}"]
  end
end

