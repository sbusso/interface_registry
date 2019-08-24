# frozen_string_literal: true

require 'interface_registry/utils'

# An abstract interface for Registry
module InterfaceRegistry
  # Abstract adapter
  module AbstractInterface
    extend self

    # @@lock = Mutex.new

    def extended(mod)
      Registry.add_interface(mod)
      define_extended(mod)
      define_included(mod)
    end

    def define_extended(mod)
      mod.define_singleton_method('extended') do |base|
        Registry.add_interface_adapter(mod, base)
        base.define_singleton_method('aattr_accessor') do |name|
          base.__send__(:attr_accessor, name)
          Registry::INTERFACES[m][:adapters][name_to_key(base)] << name
        end
      end
    end

    def define_included(mod)
      mod.define_singleton_method('included') do |base|
        Registry.add_interface_adapter(mod, base)
        base.define_singleton_method('aattr_accessor') do |name|
          base.__send__(:attr_accessor, name)
          Registry.add_adapter_attr(mod, base, name)
        end
      end
    end

    # Adapter factory
    def adapter
      return @adapter if @adapter

      raise NoInterface
    end

    def method_interface(method_name)
      define_method method_name.to_s do
        raise \
          InterfaceRegistry::InterfaceNotImplementedError,
          "#{self.class.name} needs to implement '#{method_name}' for interface"
      end
      Registry.add_interface_method(self, method_name)
    end

    def interface_name
      name_to_key(self)
    end

    def name_to_key(klass)
      klass.name.underscore
    end

    def path
      name.underscore
    end

    def new(adapter_name, config = {})
      # @@lock.synchronize do
      #   begin
      #     require "#{path}/#{adapter_name}"
      #   rescue LoadError => e
      #     raise MissingInterface
      #   end

      @adapter = const_get(adapter_name.camelize.to_s)
      @adapter_instance = @adapter.new(config)
      # end
      # @adapter_instance
    end

    def methods
      Registry.interfaces[name_to_key(self)][:methods]
    end

    def adapters
      Registry.interfaces[name_to_key(self)][:adapters].keys
    end
  end
end
