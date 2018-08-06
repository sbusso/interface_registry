RSpec.describe InterfaceRegistry do
  it "has a version number" do
    expect(InterfaceRegistry::VERSION).not_to be nil
  end

  context "Implement TestInterface" do

    module TestInterface
      extend InterfaceRegistry::AbstractInterface

      module SubModuleInterface
        extend InterfaceRegistry::AbstractInterface
      end

      method_interface :method1
      method_interface :method2
    end

    require 'test_interface/adapter_1'
    require 'test_interface/adapter_2' # test adapter without aattr accessor to register

    module TestInterface2
      extend InterfaceRegistry::AbstractInterface
    end
    # Created Registry
    # ================
    #
    # {
    #   "test_interface" => {
    #     :adapters =>
    #     {
    #       "Adapter1" => [:attr1, :attr2],
    #       "Adapter2" => []
    #     },
    #     :methods => [:method1, :method2]
    #   },
    #   "test_interface/sub_module_interface" =>
    #   {
    #     :adapters => {},
    #     :methods => []
    #   }
    # }

    it "should provide an array of adapters" do
      expect(InterfaceRegistry::Registry.interfaces).to be_a(Hash)
    end

    it "should have registered 3 interfaces" do
      expect(InterfaceRegistry::Registry.interfaces.keys.count).to be(3)
    end

    it "should have registered TestInterface::SubModuleInterface" do
      expect(InterfaceRegistry::Registry.interfaces).to include('test_interface/sub_module_interface')
    end

    it "should have registered 2 adatpers for TestInterface" do
      expect(InterfaceRegistry::Registry.adapters(TestInterface).size).to be(2)
    end

    it "should have registered 2 adatpers" do
      expect(TestInterface.adapters.size).to be(2)
    end

    it "should have registered 2 methods" do
      expect(TestInterface.methods.size).to be(2)
    end

    it "should have registered 2 methods" do
      expect(InterfaceRegistry::Registry.methods(TestInterface).size).to be(2)
    end

    it "should find 2 attribute accessors" do
      expect(InterfaceRegistry::Registry.interfaces['test_interface'][:adapters]["test_interface/adapter1"].size).to be(2)
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

    it "#new should create a new instance of Adapter1" do
      expect(TestInterface.new('test_interface/adapter1')).to be_kind_of(TestInterface::Adapter1)
    end

  end
end
