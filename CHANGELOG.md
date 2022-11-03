# Changelog

## v2.2.0 (2022-11-03)

### Enhancements

- Prepare dox for Rails 7.1 - Start using `#media_type` on request and response objects (removes following deprecation message):

```bash
DEPRECATION WARNING: Rails 7.1 will return Content-Type header without modification. If you want just the MIME type, please use `#media_type` instead.
```

## v2.1.0 (2021-03-26)

### Enhancements

- Added 'activesupport' as a runtime dependency
- Dropped 'rails' as a runtime dependency


## v2.0.0 (2020-08-08)

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


## v1.3.0 (2021-03-26)

### Enhancements

- Added 'activesupport' as a runtime dependency
- Dropped 'rails' as a runtime dependency


## v1.2.0 (2019-11-27)

### Enhancements

- Support Multipart payload with pretty formatting (based on `content-type` header)


### Bugfixes

- Explicit passing of an empty hash for `params` in actions now works as expected


## v1.1.0 (2018-02-19)

### Enhancements

- Full RSpec failure dump to stderr if any test fails when running tests with Dox::Formatter
- Support any payload format with pretty formatting for JSON and XML (based on `content-type` header)


### Bugfixes

- Ignore subdomain request header in headers output


## v1.0.2 (2017-06-10)

### Enhancements

- Set minimal Ruby version to 2.x


### Bugfixes

- Fixed parsing blank request body string


## v1.0.1 (2017-06-10)

### Enhancements

- Add Rake tasks for generating documentation to Readme


### Bugfixes

- Fix printing request body for test examples


## v1.0.0 (2017-05-06)

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


## v1.0.0.alpha (2016-10-18)

### Enhancements

- Updated the dependencies
- `extend Dox::DSL::Syntax` instead of `include Dox::DSL::Syntax` in descriptors


### Breaking changes / Deprecations

- [BREAKING] Raise errors on missing required dox attributes in descriptors


## v0.0.3 (2016-06-22)

### Bugfixes

- Fixed example identifier for examples with query params


## v0.0.2 (2016-06-14)

### Enhancements

- Created core classes and a DSL for manipulating the examples in specs
- Added usage to readme


## v0.0.1 (2016-06-06)

- First release of the dox gem where the initial gem skeleton has been created
