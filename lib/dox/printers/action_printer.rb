module Dox
  module Printers
    class ActionPrinter < BasePrinter
      def print(action)
        self.action = action
        @output.puts action_title
        @output.puts action_uri_params if action.uri_params.present?
        @output.puts action_attributes if action.attributes

        action.examples.each do |example|
          example_printer.print(example)
        end
      end

      private

      attr_accessor :action

      def action_title
        <<-HEREDOC

### #{action.name} [#{action.verb.upcase} #{action.path}]
#{print_desc(action.desc)}
        HEREDOC
      end

      def action_attributes
        <<-HEREDOC
+ Attributes
#{print_attributes(action.attributes, 4)}
        HEREDOC
      end

      def action_uri_params
        <<-HEREDOC
+ Parameters
#{formatted_params(action.uri_params)}
        HEREDOC
      end

      def example_printer
        @example_printer ||= ExamplePrinter.new(@output)
      end

      def formatted_params(uri_params)
        uri_params.map do |param, details|
          desc = "    + #{CGI.escape(param.to_s)}: `#{CGI.escape(details[:value].to_s)}` (#{details[:type]}, #{details[:required]})"
          desc += " - #{details[:description]}" if details[:description].present?
          desc += "\n        + Default: #{details[:default]}" if details[:default].present?
          desc
        end.flatten.join("\n")
      end

      def print_attributes(attributes, indent)
        str = []
        attributes.map do |name, options|
          attribute = Dox::Entities::Attribute.new(name, options)
          str << indent_lines(indent, attribute.print)
          if attribute.children?
            str << print_attributes(attribute.children, indent + 4)
          end
        end

        str.join("\n")
      end
    end
  end
end
