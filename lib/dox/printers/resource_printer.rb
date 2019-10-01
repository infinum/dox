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
        tags = @json_hash['tags']

        tags.push(acquire_tag) unless tags.any? { |tag| tag['name'] == resource.name }
      end

      def acquire_tag
        desc = ''
        desc = File.read(File.join(Dox.config.desc_folder_path, resource.desc)) unless resource.desc.nil?
        { name: resource.name, description: desc }
      end

      def add_to_groups
        group_hash = @json_hash['x-tagGroups'].find do |group|
          group['name'] == resource.group
        end

        group_hash['tags'].push(resource.name)
      end

      def action_printer
        @action_printer ||= ActionPrinter.new(@json_hash['paths'])
      end
    end
  end
end
