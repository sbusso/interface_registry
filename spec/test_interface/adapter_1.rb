module TestInterface
  class Adapter1
    include TestInterface

    aattr_accessor :attr1
    aattr_accessor :attr2

    def method1
      return nil
    end

  end
end