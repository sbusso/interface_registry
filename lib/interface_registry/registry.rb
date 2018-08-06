module InterfaceRegistry
  module Registry
    INTERFACES = {}

    class << self

      def add_interface(interface)
        interfaces[name_to_key(interface)] = {methods: [], adapters: {}}
      end

      def add_interface_method(interface, method_name)
        interfaces[name_to_key(interface)][:methods] << method_name
      end

      def add_interface_adapter(interface, adapter)
        interfaces[name_to_key(interface)][:adapters][name_to_key(adapter)] = []
      end

      def add_adapter_attr(interface, adapter, a)
        interfaces[name_to_key(interface)][:adapters][name_to_key(adapter)] << a
      end

      # Registered Interfaces
      def interfaces
        INTERFACES
        # return @_interfaces if @_interfaces
        # @_interfaces = {}
        # InterfaceRegistry::Registry::INTERFACES.keys.each do |key|
        #   @_interfaces[key] = InterfaceRegistry::Registry::INTERFACES[key][:adapters] unless InterfaceRegistry::Registry::INTERFACES[key][:adapters].empty?
        # end
        # return @_interfaces
      end

      # Return registered adapters for an Interface
      def methods(interface)
        mod_hash = interfaces[name_to_key(interface)] || {}
        mod_hash[:methods] ? mod_hash[:methods] : []
      end

      # Return registered adapters for an Interface
      def adapters(interface)
        mod_hash = interfaces[name_to_key(interface)] || {}
        mod_hash[:adapters] ? mod_hash[:adapters].keys : []
      end

      ##
      # Registered hooks
      def hooks
        return @hooks if @hooks
        @hooks = {}
        interfaces.keys.each do |key|
          interfaces[key][:methods].each do |i|
            @hooks[i] = [] unless @hooks[i]
            @hooks[i] << key
          end
        end
        return @hooks.freeze
      end

      def name_to_key(klass)
        klass.name.underscore
      end
    end
  end
end