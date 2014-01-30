# QC::Later

Do things later with [queue_classic](https://github.com/ryandotsmith/queue_classic).

## Installation

Add this line to your application's Gemfile:

    gem "queue_classic-later"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install queue_classic-later

## Setup

First, follow the queue_classic setup directions.

**NOTE for Ruby 1.8.7**: *You'll also need to install the `json` gem--but you really should upgrade to a newer version of ruby, it's no longer being maintained.*

QC::Later has database setup to do, much like queue_classic itself. Use the same process suggested by the queue_classic
directions to run `QC::Later::Setup.create` in a database migration or similar.

You'll need to periodically call `QC::Later.tick`, such as via a
[clock process](https://devcenter.heroku.com/articles/scheduled-jobs-custom-clock-processes). Calling it every 5-10
seconds is probably sufficient.

## Usage

QC::Later adds two methods to `QC::Queue`:

* `enqueue_in(seconds, method, *args)`: Like `enqueue`, but wait `seconds` before enqueueing the work
* `enqueue_at(time, method, *args)`: Like `enqueue_in`, but wait until `time` before enqueueing the work

Here's an example:

```ruby
# Enqueue this in 30 seconds
QC.enqueue_in(30, "Kernel.puts", "hello world")

# Enqueue this at a specific time
QC.enqueue_at(Time.new(2012, 10, 13, 12, 34, 56), "Kernel.puts", "hello world")
```

`QC::Later.tick` will enqueue these jobs to be worked by your worker(s) at the appropriate time.

## Credit

Heavily inspired by [resque-scheduler](https://github.com/bvandenbos/resque-scheduler).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
