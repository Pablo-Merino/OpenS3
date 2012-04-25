module OpenS3

  class ServerInfo

    def call(env)
      request = Rack::Request.new(env)
      hostname = request.host_with_port
      [200, {"Content-Type" => "application/json"}, "#{{:hostname => hostname}.to_json}"]
    end

  end

end
