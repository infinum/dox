module Dox
  class HtmlRenderer
    DEFAULT_REDOC_VERSION = '2.5.1'

    def initialize(spec_path, output_path)
      @spec_path = spec_path
      @output_path = output_path
    end

    def render
      spec = JSON.parse(::File.read(spec_path))
      resolved = resolve_file_refs(spec, ::File.dirname(spec_path))
      title = resolved.dig('info', 'title') || Dox.config.title

      FileUtils.mkdir_p(::File.dirname(output_path))
      ::File.write(output_path, build_html(title, resolved))
    end

    private

    attr_reader :spec_path, :output_path

    def resolve_file_refs(obj, base_dir)
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

    def replace_json_pointer_refs(obj, root:)
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

    def redoc_version
      Dox.config.redoc_version || DEFAULT_REDOC_VERSION
    end

    def build_html(title, spec)
      <<~HTML
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8"/>
          <title>#{title}</title>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style>body { margin: 0; padding: 0; }</style>
        </head>
        <body>
          <div id="redoc"></div>
          <script src="https://cdn.redocly.com/redoc/v#{redoc_version}/bundles/redoc.standalone.js"></script>
          <script>
            Redoc.init(#{JSON.generate(spec)}, {}, document.getElementById('redoc'));
          </script>
        </body>
        </html>
      HTML
    end
  end
end
