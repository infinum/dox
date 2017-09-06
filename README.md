[![Build Status](https://travis-ci.org/infinum/dox.svg?branch=master)](https://travis-ci.org/infinum/dox)
[![Code Climate](https://codeclimate.com/github/infinum/dox/badges/gpa.svg)](https://codeclimate.com/github/infinum/dox)
[![Test Coverage](https://codeclimate.com/github/infinum/dox/badges/coverage.svg)](https://codeclimate.com/github/infinum/dox/coverage)

# Dox

Automate your documentation writing proces! Dox generates API documentation from Rspec controller/request specs in a Rails application. It formats the tests output in the [API Blueprint](https://apiblueprint.org) format. Choose one of the [renderes](#renderers) to convert it to HTML or host it on [Apiary.io](https://apiary.io)

Here's a [demo app](https://github.com/infinum/dox-demo) and here are some examples:

- [Dox demo - Apiary](http://docs.doxdemo.apiary.io/#reference/books/books)
- [Dox demo - Aglio](https://infinum.github.io/dox-demo/aglio)
- [Dox demo - Snowboard](https://infinum.github.io/dox-demo/snowboard)


## Installation

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'dox', require: 'false'
end
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install dox
```

## Usage

### Require it
 Require Dox in the rails_helper:

 ``` ruby
 require 'dox'
 ```

and configure rspec with this:

``` ruby
RSpec.configure do |config|
  config.after(:each, :dox) do |example|
    example.metadata[:request] = request
    example.metadata[:response] = response
  end
end
```

### Configure it
Set these mandatory options in the rails_helper:

| Option | Value | Description |
| -- | -- | -- |
| header_file_path | Pathname instance or fullpath string | Markdown file that will be included at the top of the documentation. It should contain title and some basic info about the api. |
| desc_folder_path | Pathname instance or fullpath string | Folder with markdown descriptions. |


Optional settings:

| Option | Value| Description |
| -- | -- | -- |
| headers_whitelist | Array of headers (strings) | Requests and responses will by default list only `Content-Type` header. To list other http headers, you must whitelist them.|

Example:

``` ruby
Dox.configure do |config|
  config.header_file_path = Rails.root.join('spec/docs/v1/descriptions/header.md')
  config.desc_folder_path = Rails.root.join('spec/docs/v1/descriptions')
  config.headers_whitelist = ['Accept', 'X-Auth-Token']
end
```

### Basic example

Define a descriptor module for a resource using Dox DSL:

``` ruby
module Docs
  module V1
    module Bids
      extend Dox::DSL::Syntax

      # define common resource data for each action
      document :api do
        resource 'Bids' do
          endpoint '/bids'
          group 'Bids'
        end
      end

      # define data for specific action
      document :index do
        action 'Get bids'
      end
    end
  end
end

```
<small>You can define the descriptors for example in specs/docs folder, just make sure you load them in the rails_helper.rb:

``` ruby
Dir[Rails.root.join('spec/docs/**/*.rb')].each { |f| require f }
```
</small>

Include the descriptor modules in a controller and tag the specs you want to document with **dox**:

``` ruby
describe Api::V1::BidsController, type: :controller do
  # include resource module
  include Docs::V1::Bids::Api

  describe 'GET #index' do
    # include action module
    include Docs::V1::Bids::Index

    it 'returns a list of bids', :dox do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
```

And [generate the documentation](#generate-documentation).


### Advanced options

Before running into any more details, here's roughly how is the generated API Blueprint document structured:

- header
- resource group
  - resource
    - action
      - example 1
      - example 2
    - action
    - ...
  - resource
    - action
  - ...
- resource group
  - resource
    - action


Header is defined in a markdown file as mentioned before. Examples are concrete test examples (you can have 2 examples for create 1 happy path, 1 fail path). They are completely automatically generated from the request/response objects.
And you can customize the following in the descriptors:

- resource group
- resource
- action

#### Resource group

Resource group contains related resources and is defined with:
- **name** (required)
- desc (optional, inline string or relative filepath)

Example:
``` ruby
document :bids_group do
  group 'Bids' do
    desc 'Here are all bid related resources'
  end
end
```

You can omit defining the resource group, if you don't have any description for it. Related resources will be linked in a group by the group option at the resource definition.

#### Resource
Resource contains actions and is defined with:
- **name** (required)
- **endpoint** (required)
- **group** (required; to associate it with the related group)
- desc (optional; inline string or relative filepath)

Example:
``` ruby
document :bids do
  resource 'Bids' do
    endpoint '/bids'
    group 'Bids'
    desc 'bids/bids.md'
  end
end
```

Usually you'll want to define resource and resource group together, so you don't have to include 2 modules with common data per spec file:

``` ruby
document :bids_common do
  group 'Bids' do
    desc 'Here are all bid related resources'
  end

  resource 'Bids' do
    endpoint '/bids'
    group 'Bids'
    desc 'bids/bids.md'
  end
end
```

#### Action
Action is defined with:
- **name** (required)
- path* (optional)
- verb* (optional)
- params* (optional)
- desc (optional; inline string or relative filepath)

\* these optional attributes are guessed (if not defined) from the request object of the test example and you can override them.

Example:

``` ruby
show_params = { id: { type: :number, required: :required, value: 1, description: 'bid id' } }

document :action do
  action 'Get bid' do
    path '/bids/{id}'
    verb 'GET'
    params show_params
    desc 'Some description for get bid action'
  end
end
```

### Generate documentation
Documentation is generated in 2 steps:

1. generate API Blueprint markdown:
```bundle exec rspec spec/controllers/api/v1 -f Dox::Formatter --order defined --tag dox --out docs.md```

2. render HTML with some renderer, for example, with Aglio:
```aglio -i docs.md -o docs.html```


#### Use rake tasks
It's recommendable to write a few rake tasks to make things easier. Here's an example:

```ruby
namespace :api do
  namespace :doc do
    desc 'Generate API documentation markdown'
    task :md do
      require 'rspec/core/rake_task'

      RSpec::Core::RakeTask.new(:api_spec) do |t|
        t.pattern = 'spec/controllers/api/v1/'
        t.rspec_opts = "-f Dox::Formatter --order defined --tag dox --out public/api/docs/v1/apispec.md"
      end

      Rake::Task['api_spec'].invoke
    end

    task html: :md do
      `aglio -i public/api/docs/v1/apispec.md -o public/api/docs/v1/index.html`
    end

    task open: :html do
      `open public/api/docs/v1/index.html`
    end

    task publish: :md do
      `apiary publish --path=public/api/docs/v1/apispec.md --api-name=doxdemo`
    end
  end
end
```

#### Renderers
You can render the HTML yourself with one of the renderers:

- [Aglio](https://github.com/danielgtaylor/aglio)
- [Snowboard](https://github.com/subosito/snowboard)

Both support multiple themes and template customization.

Or you can just take your generated markdown and host your documentation on [Apiary.io](https://apiary.io).


### Common issues

You might experience some strange issues when generating the documentation. Here are a few examples of what we've encountered so far.

#### Wrap parameters issue
Rails wraps JSON parameters on all requests by default, which results with documented requests looking like this:

```
+ Request get pokemons
    {
      "pokemon": {}
    }
```

To disable wrapping parameters with a resource name, turn off this feature in `config/initializers/wrap_parameters.rb`:

``` ruby
# Enable parameter wrapping for JSON. You can disable this by setting :format to an empty array.
ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: []
end
```

#### Rendering warnings with Aglio
You might get the following warnings when rendering HTML with Aglio:

* `no headers specified (warning code 3)`
* `empty request message-body (warning code 6)`

This usually happens on GET requests examples when there are no headers. To solve this issue, add at least one header to the tests' requests, like `Accept: application/json`.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/infinum/dox. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## Credits
Dox is maintained and sponsored by [Infinum](https://infinum.co).

<a href="https://infinum.co"><img alt="Infinum" src="infinum.png" width="250"></a>

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

