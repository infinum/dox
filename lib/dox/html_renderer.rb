module Dox
  class HtmlRenderer
    def initialize(spec_path, output_path, adapter: Dox::RedoclyAdapter.new)
      @spec_path = spec_path
      @output_path = output_path
      @adapter = adapter
    end

    def render
      spec = JSON.parse(::File.read(spec_path))
      resolved = resolve_file_refs(spec, ::File.dirname(spec_path))
      title = resolved.dig('info', 'title') || Dox.config.title

      FileUtils.mkdir_p(::File.dirname(output_path))
      ::File.write(output_path, adapter.build_html(title, resolved))
    end

    private

    attr_reader :spec_path
    attr_reader :output_path
    attr_reader :adapter

    def resolve_file_refs(obj, base_dir) # rubocop:disable Metrics/MethodLength
      case obj
      when Hash
        if obj.key?('$ref') && !obj['$ref'].start_with?('#')
          load_schema(obj['$ref'], base_dir)
        else
          obj.transform_values { |v| resolve_file_refs(v, base_dir) }
        end
      when Array
        obj.map { |item| resolve_file_refs(item, base_dir) }
      else
        obj
      end
    end

    def load_schema(ref_path, base_dir)
      full_path = ::File.expand_path(ref_path, base_dir)
      schema = JSON.parse(::File.read(full_path))
      resolved = resolve_file_refs(schema, ::File.dirname(full_path))
      resolve_internal_refs(resolved)
    end

    # Internal $refs like "#/path/to/thing" are JSON pointers into the
    # same document. Once a file is inlined into the spec, the root
    # changes and these pointers break. This resolves them while the
    # file's own root is still available.
    def resolve_internal_refs(schema)
      replace_json_pointer_refs(schema, root: schema)
    end

    def replace_json_pointer_refs(obj, root:) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
      case obj
      when Hash
        if obj.key?('$ref') && obj['$ref'].start_with?('#/')
          keys = obj['$ref'].delete_prefix('#/').split('/')
          target = root.dig(*keys)
          target ? replace_json_pointer_refs(target, root: root) : obj
        else
          obj.transform_values { |v| replace_json_pointer_refs(v, root: root) }
        end
      when Array
        obj.map { |item| replace_json_pointer_refs(item, root: root) }
      else
        obj
      end
    end
  end
end
