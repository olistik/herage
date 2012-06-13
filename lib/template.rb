# Usage:
# rails new <app_name> -d postgresql -m /path/to/template.rb
# cd <app_name>
# heroku open

git :init
git add: "."
git commit: "-a -m 'Genesis'"

insert_into_file 'Gemfile', "ruby '1.9.3'\n", after: "source 'https://rubygems.org'\n"

gem 'heroku'
gem 'foreman'
gem 'thin'
gem 'haml-rails'
gem 'twitter-bootstrap-rails', git: 'git://github.com/seyhunak/twitter-bootstrap-rails.git', branch: 'static'
gem_group :development do
  gem 'pry'
end
# removes comments from the Gemfile
gsub_file 'Gemfile', /# .*\n/, ''
# removes empty lines
gsub_file 'Gemfile', /\s+\n/, "\n"
gsub_file 'Gemfile', /\n+/, "\n"

run 'bundle install --local'
run 'rbenv rehash'

remove_file 'public/index.html'
git rm: 'public/index.html'
generate(:controller, 'home index')
route "root :to => 'home#index'"


create_file 'Procfile', 'web:    bundle exec thin start -p $PORT'

create_file '.env', ''

append_file '.gitignore' do
  <<-eos
.env
.DS_Store
  eos
end

gsub_file 'config/database.yml', /(username: ).+$/, '\1olistik'

rake "db:create", env: 'development'
rake "db:create", env: 'test'

remove_file 'app/views/layouts/application.html.erb'
git rm: 'app/views/layouts/application.html.erb'
create_file 'app/views/layouts/application.html.haml' do
  <<-eos
!!! 5
%html{lang: I18n.locale}
  %head
    %title MyApp
    = stylesheet_link_tag 'application', media: 'all'
    = javascript_include_tag 'application'
    = csrf_meta_tags
  %body
    = yield
  eos
end

prepend_to_file 'config.ru' do
  <<-eos
# Disable stdout buffering to enable Heroku's realtime logging.
$stdout.sync = true
  eos
end

application do
  <<-eos
# Heroku requires this to make deployments work.
config.assets.initialize_on_precompile = false
  eos
end

remove_file 'app/assets/javascripts/application.js'
create_file 'app/assets/javascripts/application.js' do
  <<-eos
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
  eos
end

remove_file 'app/assets/stylesheets/application.css'
create_file 'app/assets/stylesheets/application.css' do
  <<-eos
/*
 * the top of the compiled file, but it's generally better to create a new file per style scope.
 *= require_self
 *= require bootstrap
 *= require_tree .
*/
  eos
end

remove_file 'app/assets/stylesheets/bootstrap_and_overrides.css.less'
remove_file 'app/assets/javascripts/bootstrap.js.coffee'

remove_file 'README.rdoc'
create_file 'README.md' do
  <<-eos
# RAILS HEROKU APP

Usage
-----

```bash
foreman start
```

## .env

Put in .env file the environment variables. e.g.:

```
TWITTER_KEY=your-secret-key
TWITTER_SECRET=your-secret
```

TODO
____

License
-------

Copyright (c) 2012 Maurizio de Magnis. Distributed under the MIT License. See LICENSE.txt for further details.
  eos
end

create_file 'LICENSE.txt' do
  <<-eos
Copyright (c) 2012 Maurizio De Magnis

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  eos
end

git add: "."
git commit: "-a -m 'Setup'"

run "heroku apps:create --stack cedar #{app_name}"
run 'git push heroku master'
run 'heroku run rake db:migrate'
