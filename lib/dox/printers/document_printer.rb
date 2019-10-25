module Dox
  module Printers
    class DocumentPrinter < BasePrinter
      def initialize(output)
        super(acquire_body(Dox.config.body_file_path))
        @output = output
      end

      def print(passed_examples)
        spec['paths'] = {}
        spec['tags'] = []
        spec['x-tagGroups'] = []

        passed_examples.sort.each do |_, resource_group|
          group_printer.print(resource_group)
        end

        @output.puts(JSON.pretty_generate(spec))
      end

      private

      def acquire_body(body, fullpath = false)
        return if body.blank?

        if body.to_s =~ /.*\.json$/
          body = content(acquire_path(body, fullpath))
          adjust_description(body['info'])

          return body
        end

        raise Dox::Errors::FileNotFoundError, body.to_s + ' file was not found.'
      end

      def acquire_path(body, fullpath = false)
        if fullpath
          body
        else
          descriptions_folder_path.join(body).to_s
        end
      end

      def adjust_description(info)
        info['description'] = acquire_desc(info['description']) if info['description'].end_with?('.md')
      end

      def acquire_desc(path)
        read_file(path)
      end

      def descriptions_folder_path
        Dox.config.desc_folder_path
      end

      def content(path)
        JSON.parse(File.read(path))
      end

      def group_printer
        @group_printer ||= ResourceGroupPrinter.new(spec)
      end
    end
  end
end
