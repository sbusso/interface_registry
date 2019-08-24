# frozen_string_literal: true

module InterfaceRegistry
  class Error < NoMethodError; end
  class NoInterface < Error; end
  class MissingInterface < Error; end
  class InterfaceNotImplementedError < Error; end
end
