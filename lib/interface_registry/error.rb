module InterfaceRegistry
  class Error < NoMethodError; end
  class NoInterface < Error; end
  class MissingInterface < Error; end
  class InterfaceNotImplementedError < Error; end
end