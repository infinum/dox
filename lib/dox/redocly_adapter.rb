module Dox
  class RedoclyAdapter
    DEFAULT_REDOC_VERSION = '2.5.1'.freeze

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

    private

    def redoc_version
      Dox.config.redoc_version || DEFAULT_REDOC_VERSION
    end
  end
end
