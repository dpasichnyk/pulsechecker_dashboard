shared_context __dir__ do
  # NOTE: Local name which is never going to be used directly by tests.
  shared_context '(pattr all)' do
    let(:error_klass) { ServiceInput::Error }
    let(:params) { ActionController::Parameters.new(raw_params) }
    let(:instance) { described_class.new(params: params) }

    # Generic "message Regexp". Better stick to more concrete formulas when matching.
    # OPTIMIZE: Use concrete formulas rather than this in simple matching. We care for meaningful
    #   errors delivered while debugging the API. Once `mrx` usage is zero, remove this.
    let(:mrx) { Regexp.new(m.to_s) }

    let(:raw_params) do
      {}.tap do |_|
        # NOTE: We use auto-discovered `m` here.
        _[m] = value if respond_to?(:value)
      end
    end

    subject { instance.send(m) }
  end

  shared_examples 'pattr type: :array_of_integer, require: true' do
    include_context '(pattr all)'

    # OPTIMIZE: Use "when valid"/"when invalid" segregation in sibling contexts for clarity.
    context 'when valid' do
      context_when value: %w[21 22] do
        it { is_expected.to eq [21, 22] }
      end
    end

    context 'when invalid' do
      context 'when no value' do
        # OPTIMIZE: Use concrete formulas in sibling tests for greater specificity.
        #   Refactor upon touch.
        it { expect { subject }.to raise_error(error_klass, /param is missing.+: #{m}/) }
      end

      context_when value: nil do
        it { expect { subject }.to raise_error(error_klass, /Array expected, NilClass given: nil/) }
      end

      context_when value: ' ' do
        it { expect { subject }.to raise_error(error_klass, /Array expected, String given: " "/) }
      end

      context_when value: 'abc' do
        it { expect { subject }.to raise_error(error_klass, /Array expected, String given: "abc"/) }
      end

      context_when value: [] do
        it { expect { subject }.to raise_error(error_klass, /Array must not be empty/) }
      end

      context_when value: ["abc"] do
        it { expect { subject }.to raise_error(error_klass, /ArgumentError: invalid value for Integer\(\): "abc"/) }
      end

      context_when value: ["1", nil] do
        it { expect { subject }.to raise_error(error_klass, /TypeError: can't convert nil into Integer/) }
      end
    end
  end # shared_examples "pattr type: :array_of_integer, require: true"

  # OPTIMIZE: Add `pattr type: :datetime` upon touch.

  # OPTIMIZE: Make these `type: :datetime` and stuff for consistency with invocation. Upon touch.
  shared_examples 'pattr :datetime, require: true' do
    include_context '(pattr all)'

    context 'when no value' do
      it { expect { subject }.to raise_error(error_klass, mrx) }
    end

    context_when value: nil do
      it { expect { subject }.to raise_error(error_klass, mrx) }
    end

    context_when value: ' ' do
      it { expect { subject }.to raise_error(error_klass, mrx) }
    end

    context_when value: 'abc' do
      it { expect { subject }.to raise_error(error_klass, mrx) }
    end

    context_when value: '2010-11-12T13:14:15.456789' do
      it do
        expect { subject }.to raise_error(error_klass, /must contain the timezone/)
      end
    end

    context_when value: '2010-11-12T13:14:15.456789-05:00' do
      it do
        expect([subject.class, subject.to_s, subject.usec]).to eq [DateTime, '2010-11-12T13:14:15-05:00', 456789]
      end
    end
  end # shared_examples "pattr :float, require: true"

  # OPTIMIZE: Add `pattr type: :float` upon touch.

  shared_examples 'pattr :float, require: true' do
    include_context '(pattr all)'

    context 'when no value' do
      it { expect { subject }.to raise_error(error_klass, mrx) }
    end

    context_when value: nil do
      it { expect { subject }.to raise_error(error_klass, mrx) }
    end

    context_when value: ' ' do
      it { expect { subject }.to raise_error(error_klass, mrx) }
    end

    context_when value: 'abc' do
      it { expect { subject }.to raise_error(error_klass, mrx) }
    end

    context_when value: '21.3' do
      it { is_expected.to eq 21.3 }
    end
  end

  shared_examples 'pattr :integer' do
    include_context '(pattr all)'

    context 'when no value' do
      it { is_expected.to be nil }
    end

    context_when value: nil do
      it { is_expected.to be nil }
    end

    context_when value: ' ' do
      it { is_expected.to be nil }
    end

    context_when value: 'abc' do
      it { expect { subject }.to raise_error(error_klass, /invalid value for Integer\(\): "abc".+#{m}/) }
    end

    context_when value: '21' do
      it { is_expected.to eq 21 }
    end
  end # shared_examples "pattr :integer"

  shared_examples 'pattr :integer, require: true' do
    include_context '(pattr all)'

    context 'when no value' do
      it { expect { subject }.to raise_error(error_klass, /param is missing.+: #{m}/) }
    end

    context_when value: nil do
      it { expect { subject }.to raise_error(/nil into Integer.+#{m}/) }
    end

    context_when value: ' ' do
      it { expect { subject }.to raise_error(error_klass, /invalid value for Integer\(\): " ".+#{m}/) }
    end

    context_when value: 'abc' do
      it { expect { subject }.to raise_error(error_klass, /invalid value for Integer\(\): "abc".+#{m}/) }
    end

    context_when value: '21' do
      it { is_expected.to eq 21 }
    end
  end # shared_examples "pattr :integer, require: true"

  # NOTE: Help from the Doc Angel: explicit `:string` is better than implicit here.
  shared_examples 'pattr type: :string' do
    include_context '(pattr all)'

    context 'when no value' do
      it { is_expected.to be nil }
    end

    context_when value: nil do
      it { is_expected.to be nil }
    end

    context_when value: ' ' do
      it { is_expected.to eq ' ' }
    end
  end # shared_examples "pattr type: :string"

  # OPTIMIZE: Add `pattr type: :string, require: true` upon touch.
end

#
# Implementation notes:
#
# * "pattr" shared examples are for declarative testing of end `Input` classes. The depth and
#   completeness correspond the "middle" logical level. Unlike base `ServiceInput` tests, these
#   tests don't go that deep, e.g. they don't match entire exception messages etc.
