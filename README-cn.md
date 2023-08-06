![](https://chuquan-public-r-001.oss-cn-shanghai.aliyuncs.com/sketch-images/taskloop-logo-white.png?x-oss-process=image/resize,w_800)

[![Platforms](https://img.shields.io/badge/Platforms-macOS_Linux-yellowgreen)](https://img.shields.io/badge/Platforms-macOS_Linux-Green)
[![License](https://img.shields.io/badge/License-MIT-orange)](https://img.shields.io/badge/License-MIT-orange)
[![Gem](https://img.shields.io/badge/Gem-0.3.0-blue)](https://img.shields.io/badge/Gem-0.3.0-blue)
[![Language](https://img.shields.io/badge/Language-Ruby-red)](https://img.shields.io/badge/Language-Ruby-red)

[English](https://github.com/baochuquan/taskloop/README.md)

Taskloop 是一款基于 crontab 进行了优化的定时任务管理器。

与 crontab 相比，taskloop 提供了更加语义化的语法规则。除了支持 crontab 语法之外，taskloop 还实现了一些扩展，比如循环次数、开始/结束时间、日志查询、环境
变量导入等。

# Features

- [x] 环境变量导入/删除/查看
- [x] 任务日志查询，taskloop 日志查询
- [x] 任务发布/撤销
- [x] 全局开关支持 taskloop 启动/关闭
- [x] 语义化的语法规则
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

安装 gem 并通过执行以下命令将其添加到应用程序的 Gemfile 中：

    $ bundle add taskloop

如果没有使用 bundler 来管理依赖项，请通过执行以下命令安装 gem：

    $ gem install taskloop

# Usage
Taskloop 提供了一系列工作流命令，以及一组语法规则供用户自定义任务。

在使用 taskloop 时，我们建议你使用 git 项目或本地目录来管理所有定时任务。这并不意味着你必须将任务管理集中在一个地方。你可以使用多个 git
项目或目录来管理不同类型的定时任务。Taskloop 支持这些不同的管理方式。这些只是建议而已。

接下来介绍一下 taskloop 的标准工作流程。

## 启动
在开始使用 taskloop 之前，您需要执行 `taskloop launch` 命令来全局启动 taskloop。

相应的，taskloop 也提供了一个 `taskloop shutdown` 命令来支持全局关闭 taskloop。

## 初始化 Taskfile
Taskfile 用于描述自定义任务，一个 Taskfile 中可以描述多个任务。因此，我们可以在目录下执行 `taskloop init` 命令来生成 Taskfile，并在
Taskfile 中描述具体的定时任务。

## 自定义定时任务
执行 `taskloop init` 命令后，会在当前目录下自动生成一个 Taskfile 模板文件。模板文件展示了如何描述任务，包括为每个任务指定哪些属性、哪些属性是
必需的、哪些属性是可选的。

如下所示是 Taskfile 模板文件：
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

在文件的开头，我们可以使用 `env` 语法为 Taskfile 中的任务定义环境变量。

`env` 语法有两个参数，第一个是环境变量的名称，第二个是环境变量的值。我们可以多次使用 `env` 语法来定义多个环境变量。这些环境变量可以被 Taskfile
中的所有任务共享。

```shell
env <ENV_NAME1> <ENV_VALUE1>
env <ENV_NAME2> <ENV_VALUE2>
env <ENV_NAME3> <ENV_VALUE3>
...
```

每个任务都需要使用 `TaskLoop::Task.new` 语法进行初始化，并在 `do` 闭包中设置属性。任务有两个必需属性，`name` 和 `path`，其余属性是可选属
性。如果未设置任何可选属性，那么任务将每分钟执行一次。

关于可选属性，有些属性支持多种规则，但不同时支持多个规则。如果在任务描述中多次设置某个属性，则最后一次设置将覆盖之前的所有设置。

`week` 属性支持两种规则：`ScopeRule` 和 `SpecificRule`。设置 `week` 属性时，必须使用 taskloop 预定义的符号，如：`:Sun` 表示星期天。
这些符号的具体定义可以查看 `lib/taskloop/task/task_property.rb` 中 `WEEK` 的定义。

`year` 属性支持三种规则：`ScopeRule`、`SpecificRule` 和 `IntervalRule`。设置 `year` 属性时，可以直接使用数字来表示年份或间隔年数。关于
年份属性，taskloop 中没有预定义的符号。

`month` 属性支持三种规则：`ScopeRule`、`SpecificRule` 和 `IntervalRule`。定义 `month` 属性时，必须使用预定义的月份符号来设置 
`ScopeRule` 和 `SpecificRule`，例如：`:Aug` 表示八月。 对于 `IntervalRule`，直接使用数字即可，用于表示间隔的月数。这些符号的具体定义可以
查看 `lib/taskloop/task/task_property.rb` 中 `MONTH` 的定义。

`day` 属性支持三种规则：`ScopeRule`、`SpecificRule` 和 `IntervalRule`。其表示月份中的第几天，taskloop 为其预定义了符号，如：`:day7` 
表示某月的第 7 天，依此类推。对于这些符号的具体定义，可以查看 `lib/taskloop/task/task_property.rb` 中 `DAY` 的定义。

`hour` 属性支持三种规则：`ScopeRule`、`SpecificRule` 和 `IntervalRule`。当你设置 `hour` 属性时，你可以直接使用数字来表示小时值或间隔小
时数。

`minute` 属性支持三种规则：`ScopeRule`、`SpecificRule` 和 `IntervalRule`。当你设置 `minute` 属性时，你可以直接使用数字来表示分钟值或间
隔分钟数。

`date` 属性也用于设置日期。当你对 `year`、`month` 和 `day` 属性使用 `SpecificRule` 时，请不要同时设置 `date` 属性。当你为 `year`、
`month` 和 `day` 属性设置 `SpecificRule` 时， 只能设置一个日期，但是当你使用 `date` 属性时，你可以设置一系列日期。这种可以设置一系列日期的
规则在任务循环中称为 `DateListRule`。在使用 `DateListRule` 时，可以传入一系列代表日期的字符，例如：“2023-8-1”。

`time` 属性也用于设置时间。当你对 `hour` 和 `minute` 属性使用 `SpecificRule` 时，请不要同时设置 `time` 属性。当你为 `hour` 和 
`minute` 属性设置 `SpecificRule` 时，只能设置一个时间，但是当你使用 `time` 属性时，你可以设置一个时间列表。这种可以设置时间列表的规则在
taskloop 中被称为 `TimeListRule`。使用 `TimeListRule` 时，可以传入一系列代表时间的字符，例如：“10:00:00”。

`loop` 属性用于指示定时任务的执行次数，其唯一支持的规则为 `LoopRule`。使用 `LoopRule` 时，只需要传入一个表示执行次数的数字即可。

`start_point` 属性用于指示任务最早执行时间，它支持的规则是为 `StartPointBoundaryRule`。使用 `StartPointBoundaryRule` 时，需要传入表示
开始时间的字符串，如：“2023-10-1 10:00:00”。

`end_point` 属性用于指示任务的最后执行时间，它支持的规则称为 `EndPointBoundaryRule`。使用 `EndPointBoundaryRule` 时，需要传入表示结束
时间的字符串，如：“2023-10-30 10:00:00”。

## Deploy
在定义或修改 Taskfile 后，你可以执行 `taskloop deploy` 命令进行部署。部署成功后，taskloop 才会真正按照你定义的规则去执行定时任务。

如果部署 Taskfile 后发现问题，可以重新编辑并再次部署。或者也可以直接通过 `taskloop undeploy` 命令取消部署，从而避免造成严重后果。

# Advanced Usage
## 环境变量
关于环境变量，Taskfile 支持定义本地环境变量。此外，taskloop 还提供 `taskloop env` 命令来支持导入/删除/查看环境变量。例如：

```shell
# to list all the global environment variables
$ taskloop env 

# to import PATH and RUBY_HOME 
$ taskloop env --import=PATH,RUBY_HOME

# to remove MY_HOME environment variable
$ taskloop env --remove=MY_HOME
```

## 任务列表
如果我们想查看 taskloop 中正在运行哪些计划任务，这时候我们可以使用 `taskloop list` 命令。如下所示：

```shell
$ taskloop list
```

## 日志查询
如果我们想查询任务的执行日志，可以使用 `taskloop log` 命令，它支持查看特定任务的日志和系统的日志。如下所示：

```shell
# to query the log of task which is named "morning tip"
$ taskloop log --task-name="morning tip"

# to query the system log of taskloop
$ taskloop log --cron
```

# Rules
通过上文，我们知道任务的不同属性对应着不同的规则。接下来介绍一下这些规则的具体用法。

## IntervalRule
如果你想每隔一段时间执行一个任务，你需要使用 `IntervalRule`。支持 `IntervalRule` 的属性包括 `year`、`month`、`day`、`hour`、`minute`。
当你在不同的属性上使用 `IntervalRule` 时，它们的单位是不同的，最终 taskloop 会组合计算出它们执行任务的时间间隔。

`IntervalRule` 的语法是 `interval`，`IntervalRule` 的使用示例如下所示。

```ruby
# execute the task every 5 minutes
t.minute = interval 5

# execute the task every 1 hour and 10 minutes
t.hour = interval 1
t.minute = interval 5
```

## ScopeRule
如果你想指定在某个时间范围内执行的任务，那么你可以使用 `ScopeRule`。事实上，`ScopeRule` 包含三种特定类型的规则，分别是 `BeforeScopeRule`、
`BetweenScopeRule`、`AfterScopeRule`。支持 `ScopeRule` 的属性包括 `week`、`year`、`month`、`day`、`hour`、`min`。以下是
`ScopeRule` 用法的一些示例。

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
如果你想指定某个时间单位来执行，那么你可以使用 `SpecificRule`。其使用 `at` 语法。支持 `SpecificRule` 的属性包括 `week`、`year`、`month`、
`day`、`hour`、`min`。以下是 `SpecificRule` 用法的一些示例。

```ruby
# execute at 10 o'clock
t.hour = at 10
t.minute = at 0
```

## DateListRule
如果要指定一个或多个日期来执行任务，可以使用 `DateListRule`，它使用 `date` 语法。仅 `date` 属性支持 `DateListRule`。以下是 `DateListRule` 
的示例。

```ruby
# execute at 2023-10-1, 2023-10-15, 2023-10-30
t.date = date "2023-10-1", "2023-10-15", "2023-10-30"
```

## TimeListRule
如果要指定执行一次或多次任务，可以使用 `TimeListRule`，它使用 `time` 语法。只有 `time` 属性支持 `TimeListRule`。以下是 `TimeListRule`
的示例。

```ruby
# execute at 10:00:00, 11:00:00, 12:00:00
t.time = time "10:00:00", "11:00:00", "12:00:00"
```

## LoopRule
如果你想控制任务的执行次数，可以使用 `LoopRule`，它使用 `loop` 语法。只有 `loop` 属性支持 `LoopRule`。以下是 `LoopRule` 的示例。

```ruby
# only execute 5 times
t.loop = loop 5
```

## StartPointBoundaryRule
如果你希望任务在特性时间之后开始执行，那么你可以使用 `StartPointBoundaryRule`，它使用 `from` 语法。仅 `start_point` 属性支持 
`StartPointBoundaryRule`。以下是 `StartPointBoundaryRule` 的示例。

```ruby
# the task will start from 2023-10-1 10:00:00 at the earliest
t.start_point = from "2023-10-1: 10:00:00"
```

## EndPointBoundaryRule
如果你希望任务在特定时间后停止执行，那么你可以使用 `EndPointBoundaryRule`，它使用 `to` 语法。仅 `end_point` 属性支持 `EndPointBoundaryRule`。
以下是 `EndPointBoundaryRule` 的示例。

```ruby
# the task will end after 2023-10-1 10:00:00
t.end_point = to "2023-10-1: 10:00:00"
```

# Contributing
欢迎在 GitHub 上提交 issue 和 PR：https://github.com/baochuquan/taskloop。

# License
Taskloop 在 MIT 许可证下发布。 

