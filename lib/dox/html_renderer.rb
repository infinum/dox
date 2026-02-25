module Dox
  class HtmlRenderer
    DEFAULT_REDOC_VERSION = '2.5.1'

    def initialize(spec_path, output_path)
      @spec_path = spec_path
      @output_path = output_path
    end

    def render
      spec = JSON.parse(::File.read(spec_path))
      resolved = resolve_refs(spec, ::File.dirname(spec_path))
      title = resolved.dig('info', 'title') || Dox.config.title

      FileUtils.mkdir_p(::File.dirname(output_path))
      ::File.write(output_path, build_html(title, resolved))
    end

    private

    attr_reader :spec_path, :output_path

    def resolve_refs(obj, base_dir)
      case obj
      when Hash
        if obj.key?('$ref')
          full_path = ::File.expand_path(obj['$ref'], base_dir)
          referenced = JSON.parse(::File.read(full_path))
          resolve_refs(referenced, ::File.dirname(full_path))
        else
          obj.each_with_object({}) do |(k, v), hash|
            hash[k] = resolve_refs(v, base_dir)
          end
        end
      when Array
        obj.map { |item| resolve_refs(item, base_dir) }
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
