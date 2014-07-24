module RSpec
  shared_examples 'a chef sugar' do
    it 'acts as a singleton' do
      described_class.module_eval("def foo; 'result'; end")
      klass = Class.new.tap { |k| k.send(:include, described_class) }
      expect(described_class.foo).to eq(klass.new.foo)
    end

    described_class.instance_methods.each do |name|
      it "defines a `#{name}` DSL method" do
        expect(Chef::Sugar::DSL).to be_method_defined(name)
      end

      it 'has n-1 arity from the parent method' do
        method = Chef::Sugar::DSL.instance_method(name)
        expect(method.arity).to eq(described_class.method(name).arity - 1)
      end
    end
  end
end
