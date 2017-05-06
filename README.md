[![Build Status](https://travis-ci.org/infinum/dox.svg?branch=master)](https://travis-ci.org/infinum/dox)
[![Code Climate](https://codeclimate.com/github/infinum/dox/badges/gpa.svg)](https://codeclimate.com/github/infinum/dox)
[![Test Coverage](https://codeclimate.com/github/infinum/dox/badges/coverage.svg)](https://codeclimate.com/github/infinum/dox/coverage)
[![Build Status](https://semaphoreci.com/api/v1/infinum/dox/branches/master/shields_badge.svg)](https://semaphoreci.com/infinum/dox)

# Dox

Automate your documentation writing proces! Dox generates API documentation from Rspec controller/request specs in a Rails application. It formats the tests output in the [api blueprint](https://apiblueprint.org/) format. Choose one of the renderes to convert it to HTML or host it on Apiary.io


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
 Require Dox in the spec_helper or rails_helper:

 ``` ruby
 require 'dox'
 ```

and configure rspec with this:

``` ruby
Rspec.configure do |config|
  config.after(:each, :dox) do |example|
    example.metadata[:request] = request
    example.metadata[:response] = response
  end
end
```

### Configure it
Set these madatory options in the spec_helper:

| Option | Value | Description |
| -- | :-- | :-- |
| header_file_path | Path or fullpath string | Markdown file that will be included at the top of the documentation. It should contain title and some basic info about the api. |
| desc_folder_path | Path or fullpath string | Folder with markdown descriptions. |


Optional settings:

| Option | Value| Description |
| -- | :-- | :-- |
| headers_whitelist | Array of headers | Requests and responses will by default list only `Content-Type` header. To list other http headers, you must whitelist them.|

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
module ApiDoc
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
You can place your descriptors for example in spec/docs folder. Just make sure your descriptor modules are loaded in the spec_helper before running the tests.
``` ruby
Dir[Rails.root.join('spec/docs/**/*.rb')].each { |f| require f }
```


Include the descriptor modules in a controller and tag the specs you want to document with **dox**:

``` ruby
describe Api::V1::BidsController, type: :controller do
  # include resource module
  include ApiDoc::V1::Bids::Api

  describe 'GET #index' do
    # include action module
    include ApiDoc::V1::Bids::Index

    it 'returns a list of bids', :dox do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
```

And generate apiblueprint markdown with:

```bundle exec dox spec/controllers/api/v1```


### Customize the descriptors


- explain document structure


You can document the following:

- resource group (link apiblueprint)
- resource (link apiblueprint)
- action (link apiblueprint)

#### Resource group
Resource group contains related resources and can be defined with:
- name
- desc (optional)

``` ruby
document :resource_group do
  group 'Bids' do
    desc 'Bids group'
  end
end
```

#### Resource
Resource contains actions and can be defined with:
- name - required
- endpoint - required
- group - required, to connect it with the group
- desc - optional

``` ruby
document :resource do
  resource 'Bids' do
    endpoint '/bids'
    group 'Bids'
    desc 'Bids group'
  end
end
```

#### Action
Action can be defined with:
- name - required
- path* - optional
- verb* - optional
- params* - optional
- desc - optional

\* these optional attributes are guessed (if not defined) from request object and you can override them.

``` ruby
show_params = { id: { type: :number, required: :required, value: 1, description: 'bid id' } }

document :action do
  action 'Get bid' do
    path '/bids/{id}'
    verb 'GET'
    params show_params
    desc 'Bids group'
  end
end
```

### Generate documentation
```bundle exec dox rspec spec/controllers/api/v1```

```bundle exec dox rspec spec/controllers/api/v1 --out public/api/docs/v1/apispec.md```

### Render HTML

Install some of the renderers, aglio, snowboard etc. Or host it on Apiary.

[aglio](https://www.npmjs.com/package/aglio).


```
aglio -i public/api/docs/v1/apispec.md -o public/api/docs/v1/index.html

```

### Common issues

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
#### Rendering warnings
You might get the following warnings when rendering html:

* `no headers specified (warning code 3)`
* `empty request message-body (warning code 6)`

This usually happens on GET requests examples when there are no headers. To solve this issue, add at least one header for the tests, like `Accept: application/json`.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/infinum/dox. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

