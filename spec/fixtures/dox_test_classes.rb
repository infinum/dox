class DoxTestNotification
  attr_reader :example

  def initialize(test_data)
    @example = DoxTestExample.new(test_data)
  end
end

class DoxTestExample
  attr_reader :metadata

  def initialize(test_data)
    @metadata = test_data.fetch(:meta)
    @metadata[:request] = DoxTestRequest.new(test_data.fetch(:request))
    @metadata[:response] = DoxTestResponse.new(test_data.fetch(:response))
  end
end

class DoxTestRequest
  attr_reader :method, :path, :content_type, :headers, :fullpath
  attr_reader :path_parameters, :query_parameters, :body

  def initialize(request_data)
    @method = request_data.fetch(:method)
    @path = request_data.fetch(:path)

    req_body = request_data.fetch(:body, '')
    req_body = req_body.to_json unless req_body.empty?
    @body = StringIO.new(req_body)

    @path_parameters = request_data.fetch(:path_parameters, {})
    @query_parameters = request_data.fetch(:query_parameters, {})
    @content_type = request_data.fetch(:content_type, 'application/json')
    @headers = request_data.fetch(:headers, {})
    @fullpath = request_data.fetch(:fullpath)
  end

  def filtered_parameters
    {}
  end

  def env
    {}
  end
end

class DoxTestResponse
  attr_reader :status, :body, :content_type, :headers

  def initialize(response_data)
    @status = response_data.fetch(:status)
    @body = response_data.fetch(:body).to_json
    @content_type = response_data.fetch(:content_type, 'application/json')
    @headers = response_data.fetch(:headers, {})
  end
end
