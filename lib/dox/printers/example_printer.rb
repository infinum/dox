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

#{indent_lines(12, example.request_body)}
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

#{indent_lines(12, example.response_body)}
        HEREDOC
      end

      def print_headers(headers)
        headers.map do |key, value|
          "#{key}: #{value}"
        end.join("\n")
      end

      def indent_lines(number_of_spaces, string)
        string
          .split("\n")
          .map { |a| a.prepend(' ' * number_of_spaces) }
          .join("\n")
      end
    end
  end
end
