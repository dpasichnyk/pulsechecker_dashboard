require 'feature/default_initialize'

RSpec.describe Feature::DefaultInitialize do
  include_dir_context __dir__

  let(:klass) do
    feature = described_class
    Class.new do
      feature.load(self)

      attr_accessor :a
      attr_reader :prot_a
      attr_reader :priv_a

      protected

      attr_writer :prot_a

      private

      attr_writer :priv_a
    end
  end

  # NOTE: Describe/context logic is a bit inverted here.

  context_when attrs: { a: 'a' } do
    describe '.new' do
      it do
        r = klass.new(attrs)
        expect(r.a).to eq 'a'
      end
    end

    describe '.new!' do
      it do
        r = klass.new(attrs)
        expect(r.a).to eq 'a'
      end
    end
  end

  context_when attrs: { a: 'a', prot_a: 'prot_a', priv_a: 'priv_a' } do
    describe '.new' do
      it do
        expect { klass.new(attrs) }.to raise_error NoMethodError
      end
    end

    describe '.new!' do
      it do
        r = klass.new!(attrs)
        expect([r.a, r.prot_a, r.priv_a]).to eq %w[a prot_a priv_a]
      end
    end
  end
end
