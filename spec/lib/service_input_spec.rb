RSpec.describe ServiceInput do
  include_dir_context __dir__

  let(:error_klass) { described_class::Error }
  let(:instance) { klass.new(params: params) }
  let(:params) { ActionController::Parameters.new(raw_params) }

  let(:klass) do
    Class.new(described_class) do
      pattr :dt1, :datetime
      pattr :dt2_req, :datetime, true

      pattr :f1, :float
      pattr :f2_req, :float, true

      pattr :i1, :integer
      pattr :i2_req, :integer, true

      pattr :s1
      pattr :s2_req, :string, true

      def self.to_s
        'Klass'
      end
    end
  end

  describe 'instance methods' do
    use_method_discovery :m

    let(:instance) { klass.new }

    describe '#ensure_timezone_in_datetime' do
      context 'when valid' do
        it 'generally works' do
          [
            '2010-11-12T13:14:15.456789-05:00',
            '2010-11-12T13:14:15.456789+00:00',
            '2010-11-12T13:14:15.456789+01:00'
          ].each do |input|
            expect(instance.send(m, input)).to eq input
          end
        end
      end

      context 'when invalid' do
        context_when args: ['hey'] do
          it 'generally works' do
            [
              'abc',
              '2010-11-12T13:14:15',
              '2010-11-12T13:14:15.456789'
            ].each do |input|
              expect { instance.send(m, input) }.to raise_error(ArgumentError, /must contain the timezone/)
            end
          end
        end
      end
    end
  end

  describe 'class methods' do
    use_method_discovery :m

    subject do
      klass.send(m)
    end

    describe '.pattr' do
      let(:klass) do
        args = public_send(:args)
        Class.new(described_class) do
          pattr(*args)
        end
      end

      context_when args: %i[x anything] do
        it do
          expect { subject }.to raise_error(ArgumentError, 'Unknown type for `x`: :anything')
        end
      end
    end

    describe '.pattrs' do
      it do
        is_expected.to eq({
          dt1: {type: :datetime, require: false},
          dt2_req: {type: :datetime, require: true},
          f1: {type: :float, require: false},
          f2_req: {type: :float, require: true},
          i1: {type: :integer, require: false},
          i2_req: {type: :integer, require: true},
          s1: {type: :string, require: false},
          s2_req: {type: :string, require: true}
        })
      end
    end
  end

  describe 'attributes' do
    use_method_discovery :m

    let(:km) { "Klass\##{m}" }

    subject { instance.send(m) }

    describe '#dt1' do
      # OPTIMIZE: Use the `k` trick in sibling groups to reduce repetitions.
      define_singleton_method(:k) { :dt1 }

      # NOTE: This canonical order of blocks is used per every attribute: blank, valid, invalid.
      context 'when blank' do
        context_when params: nil do
          it { expect { subject }.to raise_error(RuntimeError, /Attribute `params` must/) }
        end

        context_when raw_params: {} do
          it { is_expected.to be nil }
        end

        context_when raw_params: { k => nil } do
          it { is_expected.to be nil }
        end

        context_when raw_params: { k => ' ' } do
          it { is_expected.to be nil }
        end
      end

      context 'when valid' do
        context_when raw_params: { k => '2010-11-12T13:14:15-05:00' } do
          it do
            expect([subject.class, subject.to_s, subject.usec]).to eq [DateTime, '2010-11-12T13:14:15-05:00', 0]
          end
        end

        context_when raw_params: { k => '2010-11-12T13:14:15.456789-05:00' } do
          it do
            expect([subject.class, subject.to_s, subject.usec]).to eq [DateTime, '2010-11-12T13:14:15-05:00', 456_789]
          end
        end
      end

      context 'when invalid' do
        context_when raw_params: { k => 'abc' } do
          # NOTE: Original exception text doesn't print the value. Can be tuned if needed by own
          #   exception-handling code.
          it do
            expect { subject }.to raise_error(error_klass, /must contain the timezone/)
          end
        end

        context_when raw_params: { k => '2010-11-12T13:14:15' } do
          it do
            expect { subject }.to raise_error(error_klass, /must contain the timezone/)
            # expect([subject.class, subject.to_s, subject.usec]).to eq [DateTime, "2010-11-12T13:14:15+00:00", 0]
          end
        end
      end
    end

    describe '#dt2_req' do
      define_singleton_method(:k) { :dt2_req }

      context 'when blank' do
        context_when params: nil do
          it { expect { subject }.to raise_error(RuntimeError, /Attribute `params` must/) }
        end

        context_when raw_params: {} do
          it { expect { subject }.to raise_error(error_klass, "ActionController::ParameterMissing: param is missing or the value is empty: #{m} (#{km})") }
        end

        context_when raw_params: { k => nil } do
          it { expect { subject }.to raise_error(error_klass, /must contain the timezone/) }
        end

        context_when raw_params: { k => ' ' } do
          it { expect { subject }.to raise_error(error_klass, /must contain the timezone/) }
        end
      end

      context 'when valid' do
        context_when raw_params: { k => '2010-11-12T13:14:15-05:00' } do
          it do
            expect([subject.class, subject.to_s, subject.usec]).to eq [DateTime, '2010-11-12T13:14:15-05:00', 0]
          end
        end

        context_when raw_params: { k => '2010-11-12T13:14:15.456789-05:00' } do
          it do
            expect([subject.class, subject.to_s, subject.usec]).to eq [DateTime, '2010-11-12T13:14:15-05:00', 456_789]
          end
        end
      end

      context 'when invalid' do
        context_when raw_params: { k => 'abc' } do
          # NOTE: Original exception text doesn't print the value. Can be tuned if needed by own
          #   exception-handling code.
          it { expect { subject }.to raise_error(error_klass, /must contain the timezone/) }
        end
      end
    end # describe "#dt2_req"

    describe '#f1' do
      define_singleton_method(:k) { :f1 }

      context 'when blank' do
        context_when params: nil do
          it { expect { subject }.to raise_error(RuntimeError, /Attribute `params` must/) }
        end

        context_when raw_params: {} do
          it { is_expected.to be nil }
        end

        context_when raw_params: { k => nil } do
          it { is_expected.to be nil }
        end

        context_when raw_params: { k => ' ' } do
          it { is_expected.to be nil }
        end
      end

      context 'when valid' do
        context_when raw_params: { k => '21.3' } do
          it { is_expected.to eq 21.3 }
        end
      end

      context 'when invalid' do
        context_when raw_params: { k => 'abc' } do
          it { expect { subject }.to raise_error(error_klass, "ArgumentError: invalid value for Float(): \"abc\" (#{km})") }
        end
      end
    end

    describe '#f2_req' do
      define_singleton_method(:k) { :f2_req }

      context 'when blank' do
        context_when params: nil do
          it { expect { subject }.to raise_error(RuntimeError, /Attribute `params` must/) }
        end

        context_when raw_params: {} do
          it { expect { subject }.to raise_error(error_klass, "ActionController::ParameterMissing: param is missing or the value is empty: #{m} (#{km})") }
        end

        context_when raw_params: { k => nil } do
          it { expect { subject }.to raise_error(error_klass, "TypeError: can't convert nil into Float (#{km})") }
        end

        context_when raw_params: { k => ' ' } do
          it { expect { subject }.to raise_error(error_klass, "ArgumentError: invalid value for Float(): \" \" (#{km})") }
        end
      end

      context 'when valid' do
        context_when raw_params: { k => '21.3' } do
          it { is_expected.to eq 21.3 }
        end
      end

      context 'when invalid' do
        context_when raw_params: { k => 'abc'} do
          it { expect { subject }.to raise_error(error_klass, "ArgumentError: invalid value for Float(): \"abc\" (#{km})") }
        end
      end
    end

     describe '#i1' do
      define_singleton_method(:k) { :i1 }

      context 'when blank' do
        context_when params: nil do
          it { expect { subject }.to raise_error(RuntimeError, /Attribute `params` must/) }
        end

        context_when raw_params: {} do
          it { is_expected.to be nil }
        end

        context_when raw_params: { k => nil } do
          it { is_expected.to be nil }
        end

        context_when raw_params: { k => ' ' } do
          it { is_expected.to be nil }
        end
      end

      context 'when valid' do
        context_when raw_params: { k => '21' } do
          it { is_expected.to eq 21 }
        end
      end

      context 'when invalid' do
        context_when raw_params: { k => 'abc' } do
          it { expect { subject }.to raise_error(error_klass, "ArgumentError: invalid value for Integer(): \"abc\" (#{km})") }
        end
      end
    end

    describe '#i2_req' do
      define_singleton_method(:k) { :i2_req }

      context 'when blank' do
        context_when params: nil do
          it { expect { subject }.to raise_error(RuntimeError, /Attribute `params` must/) }
        end

        context_when raw_params: {} do
          it { expect { subject }.to raise_error(error_klass, "ActionController::ParameterMissing: param is missing or the value is empty: #{m} (#{km})") }
        end

        context_when raw_params: { k => nil } do
          it { expect { subject }.to raise_error(error_klass, "TypeError: can't convert nil into Integer (#{km})") }
        end

        context_when raw_params: { k => ' ' } do
          it { expect { subject }.to raise_error(error_klass, "ArgumentError: invalid value for Integer(): \" \" (#{km})") }
        end
      end

      context 'when valid' do
        context_when raw_params: { k => '21' } do
          it { is_expected.to eq 21 }
        end
      end

      context 'when invalid' do
        context_when raw_params: { k => 'abc' } do
          it { expect { subject }.to raise_error(error_klass, "ArgumentError: invalid value for Integer(): \"abc\" (#{km})") }
        end
      end
    end

    describe '#s1' do
      define_singleton_method(:k) { :s1 }

      context 'when blank' do
        context_when params: nil do
          it { expect { subject }.to raise_error(RuntimeError, /Attribute `params` must/) }
        end

        context_when raw_params: {} do
          it { is_expected.to be nil }
        end

        context_when raw_params: { k => nil } do
          it { is_expected.to be nil }
        end

        context_when raw_params: { k => ' ' } do
          it { is_expected.to eq ' ' }
        end
      end

      context 'when valid' do
        context_when raw_params: { k => 'abc' } do
          it { is_expected.to eq 'abc' }
        end
      end
    end

    describe '#s2_req' do
      define_singleton_method(:k) { :s2_req }

      context 'when blank' do
        context_when params: nil do
          it { expect { subject }.to raise_error(RuntimeError, /Attribute `params` must/) }
        end

        context_when raw_params: {} do
          it { expect { subject }.to raise_error(error_klass, "ActionController::ParameterMissing: param is missing or the value is empty: #{m} (#{km})") }
        end

        context_when raw_params: { k => nil } do
          it { expect { subject }.to raise_error(error_klass, "ArgumentError: Value must be present: nil (#{km})") }
        end

        context_when raw_params: { k => ' ' } do
          it { expect { subject }.to raise_error(error_klass, "ArgumentError: Value must be present: \" \" (#{km})") }
        end
      end

      context 'when valid' do
        context_when raw_params: { k => 'abc' } do
          it { is_expected.to eq 'abc' }
        end
      end
    end
  end # describe "attributes"
end

#
# Implementation notes:
#
# * We do very thorough testing of all possible cases, probably with some redundancy. The reason
#   is that debugging metaprogramming code is fairly difficult. Therefore we must be bulletproof
#   here.
