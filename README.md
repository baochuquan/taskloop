![](https://chuquan-public-r-001.oss-cn-shanghai.aliyuncs.com/sketch-images/taskloop-logo-white.png?x-oss-process=image/resize,w_800)

[![Platforms](https://img.shields.io/badge/Platforms-macOS_Linux-yellowgreen)](https://img.shields.io/badge/Platforms-macOS_Linux-Green)
[![License](https://img.shields.io/badge/License-MIT-orange)](https://img.shields.io/badge/License-MIT-orange)
[![Gem](https://img.shields.io/badge/Gem-0.3.0-blue)](https://img.shields.io/badge/Gem-0.3.0-blue)

Taskloop is a scheduled task manager optimized based on crontab. 

Compared to crontab, taskloop offers more user-friendly and semantic syntax rules. In addition to supporting crontab syntax, taskloop also provides some extensions, such as the number of loops, start/end time, log query, environment variable import, etc.

# Features

- [x] Environment variable import/remove/list
- [x] Task log query, taskloop log query
- [x] Task deploy/undeploy
- [x] Global switch to enable/disable taskloop
- [x] user-friendly and semantic syntax rules
  - [x] time specific rule
  - [x] time scope rules
    - [x] before scope rule
    - [x] between scope rule
    - [x] after scope rule
  - [x] time interval rule
  - [x] loop count rule
  - [x] execution boundary rules
    - [x] start point boundary rule
    - [x] end point boundary rule
  - [x] date list rule
  - [x] time list rule

# Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add taskloop

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install taskloop


# Usage

# Advanced Usage

# FAQ

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

# Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/taskloop.

# License
Taskloop is released under the MIT license. 

