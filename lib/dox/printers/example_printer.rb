module Dox
  module Printers
    class ExamplePrinter < BasePrinter
      def print(example)
        print_request(example)
        print_response(example)
      end

      private

      def print_request(example)
        @output.puts "\n+ Request #{example.request_identifier}\n"
        # show example request fullpath with markdown in the apiblueprint description section
        @output.puts "    **#{example.request_method}**&nbsp;&nbsp;`#{example.request_fullpath}`"

        if example.request_headers.present?
          @output.puts "    + Headers\n\n#{indent_lines(12, print_headers(example.request_headers))}\n\n"
        end

        return unless example.request_parameters.present?
        @output.puts "\n    + Body\n\n#{indent_lines(12, pretty_json(example.request_parameters))}\n"
      end

      def print_response(example)
        @output.puts "+ Response #{example.response_status}\n"
        if example.response_headers.present?
          @output.puts "    + Headers\n\n#{indent_lines(12, print_headers(example.response_headers))}\n\n"
        end

        return unless example.response_body.present?
        @output.puts "\n    + Body\n\n#{indent_lines(12, pretty_json(safe_json_parse(example.response_body)))}\n"
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
