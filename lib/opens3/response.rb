ERROR_CODES = {
  :access_denied  => ["AccessDenied", 403, "Access Denied"],
  :expired_token  => ["ExpiredToken", 400, "The provided token has expired."],
  :invalid_uri    => ["InvalidURI", 400, "Couldn't parse the specified URI."],
  :no_such_bucket => ["NoSuchBucket", 404, "The specified bucket does not exist."],
  
  :invalid_security => 
    ["InvalidSecurity", 403, "The provided security credentials are not valid."],
  :invalid_bucket_name => 
    ["InvalidBucketName", 400, "The specified bucket is not valid."],
  :method_not_allowed => 
    ["MethodNotAllowed", 405, "The specified method is not allowed against this resource."],
  :internal_error => 
    ["InternalError", 500, "We encountered an internal error. Please try again."],

}

ERROR_RES = <<ERROR_RES
<?xml version="1.0" encoding="UTF-8"?>
<Error>
  <Code>%s</Code>
  <Message>%s</Message>
  <Resource>%s</Resource> 
  <RequestId></RequestId>
</Error>
ERROR_RES

module OpenS3
  ##
  # OpenS3::Response defines and handles all error responses as a result of
  # either client or server error, however not all server side errors can't be
  # handled in this block as the cause of fault may be further upstream. 
  #
  # The error codes should comply with Amazon S3's API, Version 2006-03-01. If 
  # you need to include more keys for more appropriate responses, add them from
  # the API's documentation or use whatever has been defined in
  # `etc/s3_error_codes.txt`.
  #

  class Response

    ##
    # Respond with a given error response
    # @param [Symbol] reason
    # @return [Array] response to pass to Rack::Response
    def error_response(reason, path)
      err = ERROR_CODES[reason] ? ERROR_CODES[reason] : ERROR_CODES[:internal_error]
      msg = sprintf(ERROR_RES, err[0], err[2], path);
      return [err[1], {"Content-Type" => "application/xml"}, msg]      
    end

  end

end
