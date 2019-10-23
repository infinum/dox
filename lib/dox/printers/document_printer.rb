module Dox
  module Printers
    class DocumentPrinter < BasePrinter
      def initialize(output)
        super(acquire_body(api_info_path))
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

        raise Dox::Errors::FileNotFoundError, 'No such .json file was found.'
      end

      def acquire_path(desc, fullpath = false)
        if fullpath
          desc
        else
          descriptions_folder_path.join(desc).to_s
        end
      end

      def adjust_description(info)
        info['description'] = acquire_desc(info['description']) if info['description'].end_with?('.md')
      end

      def acquire_desc(path)
        File.read(File.join(Dox.config.desc_folder_path, path))
      end

      def descriptions_folder_path
        Dox.config.desc_folder_path
      end

      def content(path)
        JSON.parse(File.read(path))
      end

      def api_info_path
        Dox.config.body_file_path
      end

      def group_printer
        @group_printer ||= ResourceGroupPrinter.new(spec)
      end
    end
  end
end
