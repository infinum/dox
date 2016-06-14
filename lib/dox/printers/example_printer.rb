module Dox
  module Printers
    class ExamplePrinter < BasePrinter

      def print(example)
        @output.puts "\n+ Request #{example.request_identifier} (#{example.request_content_type})"

        if example.request_parameters.present?
          @output.puts "\n#{indent_lines(8, pretty_json(example.request_parameters))}\n"
        end

        @output.puts "+ Response #{example.response_status} (#{example.response_content_type})"

        if example.response_body.present?
          @output.puts "\n#{indent_lines(8, pretty_json(safe_json_parse(example.response_body)))}\n"
        end
      end

      private

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

      def indent_lines(number_of_spaces, string)
        string
          .split("\n")
          .map { |a| a.prepend(' ' * number_of_spaces) }
          .join("\n")
      end
    end
  end
end
