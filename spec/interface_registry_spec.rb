RSpec.describe InterfaceRegistry do
  it "has a version number" do
    expect(InterfaceRegistry::VERSION).not_to be nil
  end

  context "Implement TestInterface" do
    module TestInterface
      extend InterfaceRegistry::AbstractInterface
      method_interface :method1
      method_interface :method2
    end

    require 'test_interface/adapter_1'

    # Created Registry
    # ================
    #
    # {
    #   "TestInterface" => {
    #     :methods => [:method1, :method2],
    #     :adapters => {
    #       "Adapter1" => [:attr1, :attr2]
    #     }
    #   }
    # }

    it "should provide an array of adapters" do
      expect(InterfaceRegistry::Registry::INTERFACES).to be_a(Hash)
    end

    it "should have registered 1 interface" do
      expect(InterfaceRegistry::Registry::INTERFACES.keys.count).to be(1)
    end

    it "should have registered 1 adatper" do
      expect(InterfaceRegistry::Registry.adapters('TestInterface').size).to be(1)
    end

    it "should find 2 methods for TestInterface" do
      expect(InterfaceRegistry::Registry::INTERFACES['TestInterface'][:methods].size).to be(2)
    end

    it "should find 2 attribute accessors" do
      expect(InterfaceRegistry::Registry::INTERFACES['TestInterface'][:adapters]["Adapter1"].size).to be(2)
    end

    it "implementing a method should not raise an error" do
      expect {
        TestInterface::Adapter1.new.method1
      }.to_not raise_error
    end

    it "not implementing a method should raise an error" do
      expect {
        TestInterface::Adapter1.new.method2
      }.to raise_error(InterfaceRegistry::InterfaceNotImplementedError)
    end
  end
end
