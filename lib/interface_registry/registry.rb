module InterfaceRegistry
  module Registry
    INTERFACES = {}

    # Registered Interfaces
    def self.interfaces
      return @_interfaces if @_interfaces
      @_interfaces = {}
      InterfaceRegistry::Registry::INTERFACES.keys.each do |key|
        @_interfaces[key] = InterfaceRegistry::Registry::INTERFACES[key][:adapters] unless InterfaceRegistry::Registry::INTERFACES[key][:adapters].empty?
      end
      return @_interfaces.freeze
    end

    # Return registered adapters for an Interface
    def self.methods(interface)
      mod_hash = InterfaceRegistry::Registry::INTERFACES[interface.to_s] || {}
      mod_hash[:methods] ? mod_hash[:methods] : []
    end

    # Return registered adapters for an Interface
    def self.adapters(interface)
      mod_hash = InterfaceRegistry::Registry::INTERFACES[interface.to_s] || {}
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
  end
end