![](https://chuquan-public-r-001.oss-cn-shanghai.aliyuncs.com/sketch-images/taskloop-logo-white.png?x-oss-process=image/resize,w_800)

[![Platforms](https://img.shields.io/badge/Platforms-macOS_Linux-yellowgreen)](https://img.shields.io/badge/Platforms-macOS_Linux-Green)
[![License](https://img.shields.io/badge/License-MIT-orange)](https://img.shields.io/badge/License-MIT-orange)
[![Gem](https://img.shields.io/badge/Gem-0.3.0-blue)](https://img.shields.io/badge/Gem-0.3.0-blue)

Taskloop is a scheduled task manager optimized based on crontab. 

Compared to crontab, taskloop offers more user-friendly and semantic syntax rules. In addition to supporting crontab 
syntax, taskloop also provides some extensions, such as the number of loops, start/end time, log query, environment 
variable import, etc.

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
TaskLoop provides a series of commands for workflows, as well as a set of syntax rules for users to customize their tasks.

When using Taskloop, we recommend that you use a git project or a local directory to manage all your scheduled tasks.
This doesn't mean that you have to centralize management in just one place; of course, you can use multiple git 
projects or directories to manage different types of scheduled tasks. Taskloop supports these different management 
methods; these are just recommendations.

Next, let's introduce the standard workflow of Taskloop.

## Launch
Before you start using Taskloop, you need to execute the `taskloop launch` command to globally launch Taskloop.

## Init Taskfile
A Taskfile is used to describe custom tasks, and multiple tasks can be described in one Taskfile. Therefore, we can 
execute the `taskloop init` command in a directory to generate a Taskfile and describe specific tasks in the Taskfile.

## Customize Scheduled Task
After you execute the `taskloop init` command, a Taskfile template file will be automatically generated in the current 
directory. The template file describes how to describe a task, including which attributes are specified 
for each task, which attributes are required, and which attributes are optional.

The following is the Taskfile template file:
```sh
# env to set environment variables which are shared by all tasks defined in the Taskfile. <Optional>
# env "ENV_NAME", "ENV_VALUE"

TaskLoop::Task.new do |t|
  t.name        = 'TODO: task name. <Required>'
  t.path        = 'TODO: task job path. For example, t.path = "./Job.sh". <Required>'
  t.week        = 'TODO: week rule. <Optional>'
  t.year        = "TODO: year rule. <Optional>"
  t.month       = "TODO: month rule. <Optional>"
  t.day         = "TODO: day rule. <Optional>"
  t.hour        = "TODO: hour rule. <Optional>"
  t.minute      = "TODO: minute rule. <Optional>"
  t.date        = "TODO: date list rule. <Optional>"
  t.time        = "TODO: time list rule. <Optional>"
  t.loop        = "TODO: loop count. <Optional>"
  t.start_point = "TODO: start point boundary rule. <Optional>"
  t.end_point   = "TODO: end point boundary rule. <Optional>"
end
```

At the beginning of the file, we can define environment variables for the tasks in the Taskfile, using the `env` syntax.

The env syntax takes two arguments, the first is the name of the environment variable and the second is the value of the
environment variable. We can use the env syntax multiple times to define multiple environment variables. These environment 
variables are shared by all tasks in the Taskfile.

```sh
env <ENV_NAME1> <ENV_VALUE1>
env <ENV_NAME2> <ENV_VALUE2>
env <ENV_NAME3> <ENV_VALUE3>
...
```

Every task needs to be initialized using the `TaskLoop::Task.new` syntax, and set the property in the `do` closure. 
There are two required attributes of a task, `name` and `path`, and the rest are optional attributes. If none of the 
optional properties is set, the task will be executed every minute.

Regarding optional attributes, some attributes support multiple rules, but do not support rules at the same time. If a 
property is set multiple times in a task description, the last setting will override all previous settings.

The `week` attribute implements two rules: `ScopeRule` and `SpecificRule`. When you set the week attribute, you must use 
the symbols defined by taskloop, such as: `:Sun` means Sunday. For the specific definition of these symbols, you can 
check the definition of `WEEK` in `lib/taskloop/task/task_property.rb`.

The `year` attribute implements three rules: `ScopeRule`, `SpecificRule` and `IntervalRule`. When you set the `year` 
property, you can directly use numbers to represent the year or interval. Regarding the year attribute, there is no 
predefined symbols for taskloop.

The `month` attribute implements three rules: `ScopeRule`, `SpecificRule` and `IntervalRule`. When defining the `month` 
property, you have to set `ScopeRule` and `SpecificRule` with predefined month symbols, such as: `:Aug` means August.
For `IntervalRule`, just use a number directly, which is used to represent the number of months in the interval. For the
specific definition of these symbols, you can check the definition of `MONTH` in `lib/taskloop/task/task_property.rb`.

The `day` attribute implements three rules: `ScopeRule`, `SpecificRule` and `IntervalRule`. It indicates the day of the
month，taskloop has predefined symbols for it, such as: `:day7` means the 7th day of a certain month, and so on. For the 
specific definition of these symbols, you can check the definition of `DAY` in `lib/taskloop/task/task_property.rb`.

The `hour` attribute implements three rules: `ScopeRule`, `SpecificRule` and `IntervalRule`. When you set the `hour`
property, you can directly use numbers to represent hour value or interval. 

The `minute` attribute implements three rules: `ScopeRule`, `SpecificRule` and `IntervalRule`. When you set the `minute`
property, you can directly use numbers to represent minute value or interval.

The `date` attribute is also used to set the date. When you use `SpecificRule` for `year`, `month` and `day` property, 
please don't set `date` property at the same time. When you set `SpecificRule` for `year`, `month` and `day` attribute, 
you can only set one date, but when you use `date` attribute, you can set a list of dates. This kind of rule that can 
set a series of dates is called `DateListRule` in taskloop. When using `DateListRule`, you can pass in a series of 
characters representing the date, for example: "2023-8-1".

The `time` attribute is also used to set the time. When you use `SpecificRule` for `hour` and `minute` property, please 
don't set `time` property at the same time. When you set `SpecificRule` for `hour` and `minute` attribute, you can only 
set one time, but when you use `time` attribute, you can set a time list. This kind of rule that can set a time list is 
called `TimeListRule` in taskloop. When using `TimeListRule`, you can pass in a series of characters representing the 
date, for example: "10:00:00".

The `loop` attribute is used to indicate the execution times of the scheduled task, and the only supported rule is 
called `LoopRule`. When using `LoopRule`, you only need to pass in a number indicating the number of executions.

The `start_point` attribute is used to indicate the earliest execution time of the task, and the rule it supports is 
called `StartPointBoundaryRule`. When using `StartPointBoundaryRule`, you need to pass in a string representing the 
start time, such as: "2023-10-1 10:00:00".

The `end_point` attribute is used to indicate the last execution time of the task, and the rule it supports is called
`EndPointBoundaryRule`. When using `EndPointBoundaryRule`, you need to pass in a string representing the end time, such 
as: "2023-10-30 10:00:00".

## Deploy


# Rules

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive 
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version 
number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git 
commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

# Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/taskloop.

# License
Taskloop is released under the MIT license. 

