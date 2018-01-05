# danger-prettier

Ensure files have been formatted with [Prettier](https://prettier.io/)

## Installation

This is currently an unpublished gem!

    $ gem install danger-prettier

## Usage

<blockquote>Ensure files have been formatted
  <pre>
prettier.check</pre>
</blockquote>

<blockquote>Only check files that changed
  <pre>
prettier.filtering = true
prettier.check</pre>
</blockquote>

<blockquote>Supply custom path to executable and config file
  <pre>
prettier.config_file = path/to/.prettierrc.json
prettier.executable_path = path/to/bin/prettier
prettier.check</pre>
</blockquote>

<blockquote>Supply custom file regex
  <pre>
prettier.file_regex = /\.jsx?$/
prettier.check</pre>
</blockquote>

#### Attributes

`config_file` - A path to prettiers's config file

`executable_path` - A path to prettier's executable

`file_regex` - File matching regex

`filtering` - Enable file filtering-only show messages within changed files.

#### Methods

`check` - Checks javascript files for Prettier compliance.
Generates `errors` based on file differences from prettier.

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.
