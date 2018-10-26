require 'rexml/document'

module Dox
  module Printers
    class ExamplePrinter < BasePrinter
      def print(example)
        self.example = example
        print_example_request
        print_example_response
      end

      private

      attr_accessor :example

      def print_example_request
        @output.puts example_request_title
        @output.puts example_request_headers
        return unless example.request_body.present?

        @output.puts example_request_body
      end

      def print_example_response
        @output.puts example_response_title

        if example.response_headers.present?
          @output.puts example_response_headers
        end

        return unless example.response_body.present?
        @output.puts example_response_body
      end

      def example_request_title
        <<-HEREDOC

+ Request #{example.request_identifier}
**#{example.request_method.upcase}**&nbsp;&nbsp;`#{CGI.unescape(example.request_fullpath)}`
        HEREDOC
      end

      def example_request_headers
        <<-HEREDOC

    + Headers

#{indent_lines(12, print_headers(example.request_headers))}
        HEREDOC
      end

      def example_request_body
        <<-HEREDOC

    + Body

#{indent_lines(12, formatted_body(example.request_body, example.request_content_type))}
        HEREDOC
      end

      def example_response_title
        <<-HEREDOC

+ Response #{example.response_status}
        HEREDOC
      end

      def example_response_headers
        <<-HEREDOC

    + Headers

#{indent_lines(12, print_headers(example.response_headers))}
        HEREDOC
      end

      def example_response_body
        <<-HEREDOC

    + Body

#{indent_lines(12, formatted_body(example.response_body, example.response_content_type))}
        HEREDOC
      end

      def formatted_body(body_str, content_type)
        case content_type
        when %r{application\/.*json}
          pretty_json(safe_json_parse(body_str))
        when /xml/
          pretty_xml(body_str)
        else
          body_str
        end
      end

      def safe_json_parse(json_string)
        json_string.length >= 2 ? JSON.parse(json_string) : nil
      end

      def pretty_json(json_string)
        if json_string.present?
          JSON.pretty_generate(json_string)
        else
          ''
        end
      end

      def pretty_xml(xml_string)
        doc = REXML::Document.new(xml_string)
        formatter = REXML::Formatters::Pretty.new
        formatter.compact = true
        result = ''
        formatter.write(doc, result)
        result
      end

      def print_headers(headers)
        headers.map do |key, value|
          "#{key}: #{value}"
        end.join("\n")
      end
    end
  end
end
