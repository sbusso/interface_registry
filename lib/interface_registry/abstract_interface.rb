require 'interface_registry/utils'

module InterfaceRegistry
  module AbstractInterface
    extend self

    # @@lock = Mutex.new

    def extended(mod)
      Registry.add_interface(mod)
      mod.define_singleton_method('extended') do |base|
        Registry.add_interface_adapter(mod, base)
        base.define_singleton_method('aattr_accessor') do |name|
          base.__send__(:attr_accessor, name)
          Registry::INTERFACES[m][:adapters][name_to_key(base)] << name
        end
      end
      mod.define_singleton_method('included') do |base|
        Registry.add_interface_adapter(mod, base)
        base.define_singleton_method('aattr_accessor') do |name|
          base.__send__(:attr_accessor, name)
          Registry.add_adapter_attr(mod, base, name)
        end
      end
    end

    def adapter # adapter # factory
      return @adapter if @adapter
      raise NoInterface
    end

    def method_interface(method_name)

      define_method method_name.to_s do
        raise InterfaceRegistry::InterfaceNotImplementedError.new("#{self.class.name} needs to implement '#{method_name}' for interface")
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
      self.name.underscore
    end

    def new(adapter_name, config = {})
      # @@lock.synchronize do
      #   begin
      #     require "#{path}/#{adapter_name}"
      #   rescue LoadError => e
      #     raise MissingInterface
      #   end

        @adapter = self.const_get("#{adapter_name.camelize}")
        @adapter_instance = @adapter.new(config)
      # end
      # @adapter_instance
    end

    def methods
      Registry::INTERFACES[name_to_key(self)][:methods]
    end

    def adapters
      Registry::INTERFACES[name_to_key(self)][:adapters].keys
    end

  end
end