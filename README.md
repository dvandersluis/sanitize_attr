# SanitizeAttr

[![Gem Version](https://badge.fury.io/rb/sanitize_attr.svg)](https://badge.fury.io/rb/sanitize_attr)
[![Build Status](https://travis-ci.org/dvandersluis/sanitize_attr.svg?branch=master)](https://travis-ci.org/dvandersluis/sanitize_attr)

Automatically run AR attributes through Sanitize.clean before validation.

## Installation

Add this line to your application's Gemfile:

    gem 'sanitize_attr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sanitize_attr

## Usage

```ruby
class Article < ActiveRecord::Base
  sanitize_attr :name, :description, config: :default
end
```

If no `config` is specified, `Sanitize::Config::BASIC` is used.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
