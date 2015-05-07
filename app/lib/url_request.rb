class UrlRequest

  # This is going to send our request and encode the response
  def self.send_request(url_string)
    url_string_escaped = url_string.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    url = NSURL.URLWithString(url_string_escaped)
    request = NSURLRequest.requestWithURL(url)
    response = error = nil
    data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)
    ##raise "BOOM!" unless (data.length > 0 && error.nil?)
    NSString.alloc.initWithData(data, encoding: NSUTF8StringEncoding)
  end

end
