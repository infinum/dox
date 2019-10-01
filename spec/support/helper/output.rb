module OutputHelper
  def api_header_demo_output
    File.read('spec/fixtures/someuser/api_header_demo.json')
  end

  def example_output
    File.read('spec/fixtures/example.md')
  end
end
