# Slidecole

Publish slides instead of blogging. 
<https://slidecole.com/>

[![Build Status](https://travis-ci.org/tnantoka/slidecole.png)](https://travis-ci.org/tnantoka/slidecole)
[![Code Climate](https://codeclimate.com/github/tnantoka/slidecole.png)](https://codeclimate.com/github/tnantoka/slidecole)
[![Dependency Status](https://gemnasium.com/tnantoka/slidecole.png)](https://gemnasium.com/tnantoka/slidecole)
[![Coverage Status](https://coveralls.io/repos/tnantoka/slidecole/badge.png)](https://coveralls.io/r/tnantoka/slidecole)

## Installation


```
# Clone
$ git clone git@github.com:tnantoka/slidecole.git
$ git submodule update --init
$ bundle

# DB
$ cp config/database.yml.example config/database.yml
$ vim config/database.yml
$ RAILS_ENV=production rake db:setup

# Secret
$ cp config/initializers/secret_token.rb.example config/initializers/secret_token.rb
$ rake secret
$ vim config/initializers/secret_token.rb

# Seeds
$ cp db/seeds.rb.example db/seeds.rb
$ vim db/seeds.rb

# Run
$ rake assets:precompile
$ rails s
```

## Update fonts

    $ cp vendor/assets/stylesheets/fontawesome/font/* public/font/

## Limit file size
    # 512 KB
    LimitRequestBody 512000
    
&copy; 2013 [tnantoka](https://twitter.com/tnantoka)

