class JsonParser

  def self.decode(url_response)
    json_string = url_response.dataUsingEncoding(NSUTF8StringEncoding)
    e = Pointer.new(:object)
    NSJSONSerialization.JSONObjectWithData(json_string, options:0, error: e)
  end

end
