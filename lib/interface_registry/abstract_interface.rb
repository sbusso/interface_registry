require 'interface_registry/utils'

module InterfaceRegistry
  module AbstractInterface
    extend self

    # @@lock = Mutex.new

    def extended(mod)
      m = mod.to_s.demodulize
      Registry::INTERFACES[m] = {methods: [], adapters: {}}
      mod.define_singleton_method('extended') do |base|
        Registry::INTERFACES[m][:adapters][base.to_s.demodulize] = []
        base.define_singleton_method('aattr_accessor') do |name|
          base.__send__(:attr_accessor, name)
          Registry::INTERFACES[m][:adapters][base.to_s.demodulize] << name
        end
      end
      mod.define_singleton_method('included') do |base|
        Registry::INTERFACES[m][:adapters][base.to_s.demodulize] = []
        base.define_singleton_method('aattr_accessor') do |name|
          base.__send__(:attr_accessor, name)
          Registry::INTERFACES[m][:adapters][base.to_s.demodulize] << name
        end
      end
    end

    def adapter # adapter # factory
      return @adapter if @adapter
      raise NoInterface
    end

    def method_interface(method_name)
      Registry::INTERFACES[self.to_s.demodulize][:methods] << method_name
      define_method method_name.to_s do
        raise InterfaceRegistry::InterfaceNotImplementedError.new("#{self.class.name} needs to implement '#{method_name}' for interface")
      end
    end

    def path
      self.name.underscore
    end

    def new(adapter_name, config = {})
      # @@lock.synchronize do
      #   begin
      #     require "#{path}/#{adapter_name}"
      #   rescue LoadError => e
      #     raise MissingInterface
      #   end

        @adapter = self.const_get("#{adapter_name.to_s.capitalize}")
        @adapter_instance = @adapter.new(config)
      # end
      # @adapter_instance
    end

    def methods
      Registry::INTERFACES[self.to_s.demodulize][:methods]
    end

    def adapters
      Registry::INTERFACES[self.to_s.demodulize][:adapters].keys
    end

  end
end