# Changelog

## [v2.1.0](https://github.com/infinum/dox/releases/tag/v2.1.0) (2021-03-26)
[Full Changelog](https://github.com/infinum/dox/compare/v2.0.0...v2.1.0)

### Enhancements

- Added 'activesupport' as a runtime dependency
- Dropped 'rails' as a runtime dependency


## [v2.0.0](https://github.com/infinum/dox/releases/tag/v2.0.0) (2020-08-08)
[Full Changelog](https://github.com/infinum/dox/compare/v1.2.0...v2.0.0)

### Enhancements

- Added `Dox.config.title`
- Added `Dox.config.header_description`
- Added `Dox.config.version`


### Breaking changes / Deprecations

- [BREAKING] The API description format changed from API-blueprint to OpenAPI.
- [BREAKING] Base structure is now defined in .json format
- [BREAKING] Output is written to a .json file
- [BREAKING] Html is rendered with Redoc instead of Aglio
- [BREAKING] Renamed `Dox.config.desc_folder_path` -> `Dox.config.descriptions_location`
- [BREAKING] Removed `endpoint` method from document resource block
- [DEPRECATED] `Dox.config.header_file_path`


## [v1.3.0](https://github.com/infinum/dox/releases/tag/v1.3.0) (2021-03-26)
[Full Changelog](https://github.com/infinum/dox/compare/v1.2.0...v1.3.0)

### Enhancements

- Added 'activesupport' as a runtime dependency
- Dropped 'rails' as a runtime dependency


## [v1.2.0](https://github.com/infinum/dox/releases/tag/v1.2.0) (2019-11-27)
[Full Changelog](https://github.com/infinum/dox/compare/v1.1.0...v1.2.0)

### Enhancements

- Support Multipart payload with pretty formatting (based on `content-type` header)


### Bugfixes

- Explicit passing of an empty hash for `params` in actions now works as expected


## [v1.1.0](https://github.com/infinum/dox/releases/tag/v1.1.0) (2018-02-19)
[Full Changelog](https://github.com/infinum/dox/compare/v1.0.2...v1.1.0)

### Enhancements

- Full RSpec failure dump to stderr if any test fails when running tests with Dox::Formatter
- Support any payload format with pretty formatting for JSON and XML (based on `content-type` header)


### Bugfixes

- Ignore subdomain request header in headers output


## [v1.0.2](https://github.com/infinum/dox/releases/tag/v1.0.2) (2017-06-10)
[Full Changelog](https://github.com/infinum/dox/compare/v1.0.1...v1.0.2)

### Enhancements

- Set minimal Ruby version to 2.x


### Bugfixes

- Fixed parsing blank request body string


## [v1.0.1](https://github.com/infinum/dox/releases/tag/v1.0.1) (2017-06-10)
[Full Changelog](https://github.com/infinum/dox/compare/v1.0.0...v1.0.1)

### Enhancements

- Add Rake tasks for generating documentation to Readme


### Bugfixes

- Fix printing request body for test examples


## [v1.0.0](https://github.com/infinum/dox/releases/tag/v1.0.0) (2017-05-06)
[Full Changelog](https://github.com/infinum/dox/compare/1.0.0.alpha...v1.0.0)

### Enhancements

- Guess path params for URI definition from example's request object
- Validate HTTP verbs specified in the descriptors' actions
- Document only examples whitelisted with `dox` tag
- Added option for whitelisting additional HTTP headers for examples
- Show request HTTP verb and fullpath for each action request
- Dox executable


### Bugfixes

- Ignore body in query params (Rails 4 issue) for example request URL
- Pull request and response objects from example metadata


## [v1.0.0.alpha](https://github.com/infinum/dox/releases/tag/1.0.0.alpha) (2016-10-18)
[Full Changelog](https://github.com/infinum/dox/compare/v0.0.3...1.0.0.alpha)

### Enhancements

- Updated the dependencies
- `extend Dox::DSL::Syntax` instead of `include Dox::DSL::Syntax` in descriptors


### Breaking changes / Deprecations

- [BREAKING] Raise errors on missing required dox attributes in descriptors


## [v0.0.3](https://github.com/infinum/dox/releases/tag/v0.0.3) (2016-06-22)
[Full Changelog](https://github.com/infinum/dox/compare/v0.0.2...v0.0.3)

### Bugfixes

- Fixed example identifier for examples with query params


## [v0.0.2](https://github.com/infinum/dox/releases/tag/v0.0.2) (2016-06-14)

### Enhancements

- Created core classes and a DSL for manipulating the examples in specs
- Added usage to readme


## v0.0.1 (2016-06-06)

- First release of the dox gem where the initial gem skeleton has been created
