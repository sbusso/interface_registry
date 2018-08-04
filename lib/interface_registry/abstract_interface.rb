require 'interface_registry/utils'

module InterfaceRegistry
  module AbstractInterface
    extend self

    # def self.included(klass)
    #   klass.send(:include, AbstractInterface::Methods)
    #   klass.send(:extend, AbstractInterface::Methods)
    #   klass.send(:extend, AbstractInterface::ClassMethods)
    # end

    # module Methods

    #   def api_not_implemented(klass, method_name = nil)
    #     if method_name.nil?
    #       caller.first.match(/in \`(.+)\'/)
    #       method_name = $1
    #     end
    #     raise AbstractInterface::InterfaceNotImplementedError.new("#{klass.class.name} needs to implement '#{method_name}' for interface #{self.name}!")
    #   end

    # end

    # module ClassMethods

    #   def needs_implementation(name, *args)
    #     self.class_eval do
    #       define_method(name) do |*args|
    #         api_not_implemented(self, name)
    #       end
    #     end
    #   end

    # end

    @@lock = Mutex.new

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
      @@lock.synchronize do
        begin
          require "#{path}/#{adapter_name}"
        rescue LoadError => e
          raise MissingInterface
        end

        @adapter = self.const_get("#{adapter_name.to_s.capitalize}")
        @adapter_instance = @adapter.new(config)
      end
      @adapter_instance
    end


  end
end