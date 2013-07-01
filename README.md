# Herage

A Ruby on Rails application generator tailored to a very opinionated set of (production) requirements:

* postgres
* foreman
* unicorn
* haml

## Requirements

* Ruby 2.0
* Rails 4.0
* Heroku Toolbelt

In development it uses sqlite3.

## Installation

    $ gem install herage

## Usage

```bash
herage <app_name>
```

wait 2-3 minutes..

```bash
cd <app_name>
heroku open
```

TODO
----

* split here-documents into separate template files
* set configurations in ~/.herage and allow the override of sensible defaults
* use `system` instead of `exec` ?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
