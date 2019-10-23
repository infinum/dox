module Dox
  module Printers
    class ResourcePrinter < BasePrinter
      def print(resource)
        self.resource = resource
        add_resources

        resource.actions.each do |_, action|
          action_printer.print(action)
        end
      end

      private

      attr_accessor :resource

      def add_resources
        add_to_tags
        add_to_groups
      end

      def add_to_tags
        spec['tags'] = spec['tags'].push(name: resource.name, description: desc).uniq
      end

      def desc
        desc = resource.desc
        desc = '' if desc.nil?
        desc = File.read(File.join(Dox.config.desc_folder_path, desc)) if desc.end_with?('.md')

        desc
      end

      def add_to_groups
        spec['x-tagGroups'].find { |group| group[:name] == resource.group }['tags'].push(resource.name)
      end

      def action_printer
        @action_printer ||= ActionPrinter.new(spec['paths'])
      end
    end
  end
end
