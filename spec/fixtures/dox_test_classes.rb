class DoxTestNotification
  attr_reader :example

  def initialize(test_data)
    @example = DoxTestExample.new(test_data)
  end
end

class DoxTestExample
  attr_reader :example_group_instance, :metadata

  def initialize(test_data)
    @metadata = test_data.fetch(:meta)
    @example_group_instance = DoxTestExampleGroupInstance.new(test_data)
  end
end

class DoxTestExampleGroupInstance
  attr_reader :request, :response

  def initialize(test_data)
    @request = DoxTestRequest.new(test_data.fetch(:request))
    @response = DoxTestResponse.new(test_data.fetch(:response))
  end
end

class DoxTestRequest
  attr_reader :method, :path, :content_type, :headers
  attr_reader :path_parameters, :parameters, :query_parameters

  def initialize(request_data)
    @method = request_data.fetch(:method)
    @path = request_data.fetch(:path)
    @parameters = request_data.fetch(:parameters, {})
    @path_parameters = request_data.fetch(:path_parameters, {})
    @query_parameters = request_data.fetch(:query_parameters, {})
    @content_type = request_data.fetch(:content_type, 'json')
    @headers = request_data.fetch(:headers, {})
  end
end

class DoxTestResponse
  attr_reader :status, :body, :content_type, :headers

  def initialize(response_data)
    @status = response_data.fetch(:status)
    @body = response_data.fetch(:body).to_json
    @content_type = response_data.fetch(:content_type, 'json')
    @headers = response_data.fetch(:headers, {})
  end
end
