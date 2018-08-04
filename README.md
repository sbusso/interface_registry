# InterfaceRegistry

Static Interface Framework to create Abstract Interfaces and Register adapter implementation. Registry provides also a Hook system.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'interface_registry'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interface_registry

## Usage

Declare an Interface

```ruby
module TestInterface
    extend InterfaceRegistry::AbstractInterface
    method_interface :method1
    method_interface :method2
end

# require adapters
require 'test_interface/adapter_1'
```

Implement an Adapter

```ruby
# test_interface/adapter_1.rb
module TestInterface
    class Adapter1
        include TestInterface

        aattr_accessor :attr1
        aattr_accessor :attr2

        def method1
        # do stuff ...
        end

        def method2
        # do stuff ...
        end

    end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sbusso/interface_registry. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the InterfaceRegistry project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sbusso/interface_registry/blob/master/CODE_OF_CONDUCT.md).
