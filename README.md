![](https://chuquan-public-r-001.oss-cn-shanghai.aliyuncs.com/sketch-images/taskloop-logo-white.png?x-oss-process=image/resize,w_800)

[![Platforms](https://img.shields.io/badge/Platforms-macOS_Linux-yellowgreen)](https://img.shields.io/badge/Platforms-macOS_Linux-Green)
[![License](https://img.shields.io/badge/License-MIT-orange)](https://img.shields.io/badge/License-MIT-orange)
[![Gem](https://img.shields.io/badge/Gem-0.3.0-blue)](https://img.shields.io/badge/Gem-0.3.0-blue)
[![Language](https://img.shields.io/badge/Language-Ruby-red)](https://img.shields.io/badge/Language-Ruby-red)

[简体中文](https://github.com/baochuquan/taskloop/blob/main/README-cn.md)

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

When using taskloop, we recommend that you use a git project or a local directory to manage all your scheduled tasks.
This doesn't mean that you have to centralize management in just one place; of course, you can use multiple git 
projects or directories to manage different types of scheduled tasks. Taskloop supports these different management 
methods; these are just recommendations.

Next, let's introduce the standard workflow of Taskloop.

## Launch
Before you start using taskloop, you need to execute the `taskloop launch` command to globally launch taskloop.

Correspondingly, taskloop also provides a `taskloop shutdown` command to globally shutdown taskloop.

## Init Taskfile
A Taskfile is used to describe custom tasks, and multiple tasks can be described in one Taskfile. Therefore, we can 
execute the `taskloop init` command in a directory to generate a Taskfile and describe specific tasks in the Taskfile.

## Customize Scheduled Task
After you execute the `taskloop init` command, a Taskfile template file will be automatically generated in the current 
directory. The template file describes how to describe a task, including which attributes are specified 
for each task, which attributes are required, and which attributes are optional.

The following is the Taskfile template file:
```shell
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

```shell
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
time, for example: "10:00:00".

The `loop` attribute is used to indicate the execution times of the scheduled task, and the only supported rule is 
called `LoopRule`. When using `LoopRule`, you only need to pass in a number indicating the number of executions.

The `start_point` attribute is used to indicate the earliest execution time of the task, and the rule it supports is 
called `StartPointBoundaryRule`. When using `StartPointBoundaryRule`, you need to pass in a string representing the 
start time, such as: "2023-10-1 10:00:00".

The `end_point` attribute is used to indicate the last execution time of the task, and the rule it supports is called
`EndPointBoundaryRule`. When using `EndPointBoundaryRule`, you need to pass in a string representing the end time, such 
as: "2023-10-30 10:00:00".

## Deploy
After you define or modify the Taskfile, you can execute the `taskloop deploy` command to deploy. After the deployment 
is successful, the taskloop will actually execute the scheduled tasks according to the rules you defined.

If you find a problem after deploying the Taskfile, you can re-edit it and deploy it again. Or you can undeploy it 
directly through the `taskloop undeploy` command to avoid serious consequences.

# Advanced Usage
## Environment Variable
Regarding environment variables, Taskfile supports defining local environment variables. In addition, taskloop also 
provides a `taskloop env` command to support importing/deleting/viewing environment variables. For example:

```shell
# to list all the global environment variables
$ taskloop env 

# to import PATH and RUBY_HOME 
$ taskloop env --import=PATH,RUBY_HOME

# to remove MY_HOME environment variable
$ taskloop env --remove=MY_HOME
```

## List Task
If we want to see which scheduled tasks are running in the taskloop, we can use the taskloop list command at this time.
For example:

```shell
$ taskloop list
```

## Log Query
If we want to query the execution log of the task, we can use the `taskloop log` command, which supports the log of 
specific tasks and the log of the system. For example:

```shell
# to query the log of task which is named "morning tip"
$ taskloop log --task-name="morning tip"

# to query the system log of taskloop
$ taskloop log --cron
```

# Rules
In above, we know that different attributes of tasks refer to different rules. Next, let's introduce the specific usage 
of these rules.

## IntervalRule
If you want to execute a task every period of time, you need to use `IntervalRule`. Attributes that support 
`IntervalRule` include `year`, `month`, `day`, `hour`, `minute`. When you use `IntervalRule` on different properties, their units are 
different, and finally taskloop will calculate the time interval of their combination to execute the task.

The syntax of `IntervalRule` is `interval`, and the usage example of `IntervalRule` is shown below.

```ruby
# execute the task every 5 minutes
t.minute = interval 5

# execute the task every 1 hour and 10 minutes
t.hour = interval 1
t.minute = interval 5
```

## ScopeRule
If you want to specify the task to execute within a time range, then you can use `ScopeRule`. In fact, `ScopeRule` 
contains three specific types of rules, which are `BeforeScopeRule`, `BetweenScopeRule`, `AfterScopeRule`. Attributes 
that support `ScopeRule` include `week`, `year`, `month`, `day`, `hour`, `minute`. Here are a few examples of 
`ScopeRule` usage.

```ruby
# executed between 10 o'clock and 19 o'clock
t.hour = between 10, 19

# execute before 30 minutes of the hour
t.minute = before 30

# executed after october
t.month = after :Oct

# execute within working days
t.week = between :Mon, :Fri
```

## SpecificRule
If you want to specify a certain time unit to execute, then you can use `SpecificRule`. which uses `at` 
syntax. Attributes that support `SpecificRule` include `week`, `year`, `month`, `day`, `hour`, `minute`. Here are a few 
examples of `SpecificRule` usage.

```ruby
# execute at 10 o'clock
t.hour = at 10
t.minute = at 0
```

## DateListRule
If you want to specify one or more dates to execute the task, you can use `DateListRule`, which uses `date` syntax. Only 
`date` attribute support `DateListRule`. Here is an example of `DateListRule`.

```ruby
# execute at 2023-10-1, 2023-10-15, 2023-10-30
t.date = date "2023-10-1", "2023-10-15", "2023-10-30"
```

## TimeListRule
If you want to specify one or more times to execute the task, you can use `TimeListRule`, which uses `time` syntax. Only
`time` attribute support `TimeListRule`. Here is an example of `TimeListRule`.

```ruby
# execute at 10:00:00, 11:00:00, 12:00:00
t.time = time "10:00:00", "11:00:00", "12:00:00"
```

## LoopRule
If you want to control the number of executions of tasks, you can use `LoopRule`, which uses `loop` syntax. Only `loop` attribute support 
`LoopRule`. Here is an example of `LoopRule`.

```ruby
# only execute 5 times
t.loop = loop 5
```

## StartPointBoundaryRule
If you want to set the earliest time when the task will be executed for the first time, then you can use 
`StartPointBoundaryRule`, which uses `from` syntax. Only `start_point` attribute support `StartPointBoundaryRule`. Here
is an example of `StartPointBoundaryRule`.

```ruby
# the task will start from 2023-10-1 10:00:00 at the earliest
t.start_point = from "2023-10-1: 10:00:00"
```

## EndPointBoundaryRule
If you want to prevent tasks from executing after a certain time, then you can use `EndPointBoundaryRule`, which uses 
`to` syntax. Only `end_point` attribute support `EndPointBoundaryRule`. Here is an example of `EndPointBoundaryRule`.

```ruby
# the task will end after 2023-10-1 10:00:00
t.end_point = to "2023-10-1: 10:00:00"
```

# Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/baochuquan/taskloop.

# License
Taskloop is released under the MIT license. 

