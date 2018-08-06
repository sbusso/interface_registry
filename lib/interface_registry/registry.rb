module InterfaceRegistry
  module Registry
    INTERFACES = {}


    def self.add_interface(interface)
      INTERFACES[name_to_key(interface)] = {methods: [], adapters: {}}
    end

    def self.add_interface_method(interface, method_name)
      INTERFACES[name_to_key(interface)][:methods] << method_name
    end

    def self.add_interface_adapter(interface, adapter)
      INTERFACES[name_to_key(interface)][:adapters][name_to_key(adapter)] = []
    end

    def self.add_adapter_attr(interface, adapter, a)
      INTERFACES[name_to_key(interface)][:adapters][name_to_key(adapter)] << a
    end

    # Registered Interfaces
    def self.interfaces
      INTERFACES
      # return @_interfaces if @_interfaces
      # @_interfaces = {}
      # InterfaceRegistry::Registry::INTERFACES.keys.each do |key|
      #   @_interfaces[key] = InterfaceRegistry::Registry::INTERFACES[key][:adapters] unless InterfaceRegistry::Registry::INTERFACES[key][:adapters].empty?
      # end
      # return @_interfaces
    end

    # Return registered adapters for an Interface
    def self.methods(interface)
      mod_hash = InterfaceRegistry::Registry::INTERFACES[name_to_key(interface)] || {}
      mod_hash[:methods] ? mod_hash[:methods] : []
    end

    # Return registered adapters for an Interface
    def self.adapters(interface)
      mod_hash = InterfaceRegistry::Registry::INTERFACES[name_to_key(interface)] || {}
      mod_hash[:adapters] ? mod_hash[:adapters].keys : []
    end

    ##
    # Registered hooks
    def self.hooks
      return @hooks if @hooks
      @hooks = {}
      InterfaceRegistry::Registry::INTERFACES.keys.each do |key|
        InterfaceRegistry::Registry::INTERFACES[key][:methods].each do |i|
          @hooks[i] = [] unless @hooks[i]
          @hooks[i] << key
        end
      end
      return @hooks.freeze
    end

    def self.name_to_key(klass)
      klass.name.underscore
    end
  end
end