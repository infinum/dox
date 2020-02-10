# Changelog

## Version 2.0.0

Released on February 13, 2020

Add:
- Request schemas can now be defined.
- Schemas can now be defined inline
- Query parameters can now be defined.

Change:
- BREAKING CHANGE The API description format changed from API-blueprint to OpenAPI.
- BREAKING CHANGE Base structure is now defined in .json format
- BREAKING CHANGE Output is written to a .json file
- BREAKING CHANGE Html is rendered with Redoc instead of Aglio

## Version 1.2.0

Released on November 27, 2019

New:
- Support Multipart payload with pretty formatting (based on `content-type` header)

Fix:
- Explicit passing of an empty hash for `params` in actions now works as expected


## Version 1.1.0

Released on February 19, 2018

New:
- Full RSpec failure dump to stderr if any test fails when running tests with Dox::Formatter
- Support any payload format with pretty formatting for JSON and XML (based on `content-type` header)

Fix:
- Ignore subdomain request header in headers output


## Version 1.0.1

Released on June 10, 2017

New:
- Add Rake tasks for generating documentation to Readme

Fix:
- Fix printing request body for test examples


## Version 1.0.0

Released on May 6, 2017

New:
- Guess path params for URI definition from example's request object
- Validate HTTP verbs specified in the descriptors' actions
- Document only examples whitelisted with `dox` tag
- Added option for whitelisting additional HTTP headers for examples
- Show request HTTP verb and fullpath for each action request
- Dox executable

Fix:
- Ignore body in query params (Rails 4 issue) for example request URL
- Pull request and response objects from example metadata

## Version 1.0.0.alpha

Released on October 18, 2016

- Updated the dependencies

New:
- Raise errors on missing required dox attributes in descriptors
- `extend Dox::DSL::Syntax` instead of `include Dox::DSL::Syntax` in descriptors


## Version 0.0.3

Released on June 22, 2016

Fix:
- Fixed example identifier for examples with query params


## Version 0.0.2


Released on June 14, 2016

- Created core classes and a DSL for manipulating the examples in specs
- Added usage to readme


## Version 0.0.1

Released on June 06, 2016

- First release of the dox gem where the initial gem skeleton has been created
