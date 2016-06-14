# Dox

Dox formats the rspec output in the [api blueprint](https://apiblueprint.org/) format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dox'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dox

## Usage

### Code example

Example documentation module for a resource:

``` ruby
module ApiDoc
  module V1
    module Bids
      include Dox::DSL::Syntax

      document :api do
        group do
          name 'Bids'
        end

        resource do
          name 'Bids'
          endpoint '/bids'
          group 'Bids'
          desc 'bid_resource.md'
        end
      end

      document :index do
        action do
          name 'Get bids'
          verb 'GET'
          path '/bids'
          desc 'Returns list of user bids'
        end
      end

      document :create do
        action do
          name 'Post bids'
          verb 'POST'
          path '/bids'
          desc 'Creates bid'
        end
      end
    end
  end
end
```
Description can be included inline or relative path of a markdown file with the description (relative to configured folder for markdown descriptions).

Including the documentation module in a controller:

``` ruby
describe Api::V1::BidsController, type: :controller do
  include ApiDoc::V1::Bids::Api

  describe 'GET #index' do
    include ApiDoc::V1::Bids::Index

    it 'returns a list of bids' do
      get :index
      expect(response).to have_http_status(:ok)
    end

  end
end
```

### Configuration

You have to specify **root api file** and **descriptions folder**.

Root api file is a markdown file that will be included in the top of the documentation. It should contain title and some basic info about the api.

Descriptions folder is a fullpath of a folder that contains markdown files with descriptions which behave like partials and are included in the final concatenated markdown. Root api file should also be in this folder.

``` ruby
Dox.configure do |config|
  config.root_api_file = 'api.md'
  config.desc_folder_path = Rails.root.join('spec/support/api_doc/v1/markdown_descriptions')
end
```

### Generate HTML documentation
You have to install [aglio](https://www.npmjs.com/package/aglio).

Rake task for generating HTML:

``` ruby
  `bundle exec rspec spec --tag apidoc -f Dox::Formatter --order defined --out spec/apispec.md`
  `aglio --include-path / -i spec/apispec.md -o public/api/docs/index.html`
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dox. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

