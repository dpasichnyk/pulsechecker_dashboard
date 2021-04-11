RSpec.describe ApplicationService do
  include_dir_context __dir__

  let(:klass) do
    Class.new(described_class) do
      attr_accessor :a

      def slim_perform
        :slim_perform_signature
      end
    end
  end

  describe 'class methods' do
    describe '.[]' do
      it 'generally works' do
        expect(klass[a: 1]).to be_a klass
      end
    end
  end

  describe 'instance methods' do
    use_cl2(:let_a, :attrs)
    use_method_discovery(:m)

    let(:instance) { klass.new(attrs) }

    subject { instance.send(m) }

    # NOTE: This test is needed, we make sure a proper exception is raised.
    #   The feature has its own basic test, too.
    describe '#require_computed' do
      subject { instance.send(m, :a) }

      let_a(:a) { nil }

      context_when a: 21 do
        it { is_expected.to eq 21 }
      end

      it do
        expect { subject }.to raise_error(ServiceDataError, /RuntimeError: Attribute `a` must/)
      end
    end

    describe '#perform' do
      describe 'exception handling' do
        let(:error_message) { 'some error' }

        before :each do
          expect(instance).to receive(:slim_perform).once.and_raise(error_klass, error_message)
        end

        def expect_mapped(klass)
          expect { subject }.to raise_error(klass, /#{error_klass}:/)
        end

        def expect_unmapped
          expect { subject }.to raise_error(ArgumentError, error_message)
        end

        context 'when mapped error class' do
          context_when error_klass: ActiveRecord::RecordInvalid do
            # NOTE: See "Implementation notes".
            let(:error_message) { Pulsechecker.new }
            it { expect_mapped ServiceDataError }
          end

          context_when error_klass: ActiveRecord::RecordNotFound do
            it { expect_mapped ServiceDataError }
          end
        end

        context 'when unmapped error class' do
          context_when error_klass: ArgumentError do
            it { expect_unmapped }
          end
        end
      end

      it 'returns self' do
        expect(subject).to eq instance
      end
    end

    describe '#touch' do
      context 'when no arguments' do
        it do
          expect { subject }.to raise_error(ArgumentError, /^wrong number of arguments/)
        end
      end

      it do
        # NOTE: Value "touching" is all Ruby land which we may trust. What we test here is
        #   method existence, its argument abilities and return value.
        expect(instance.send(m, 'anything', 21)).to be nil
      end
    end
  end
end

#
# Implementation notes:
#
# * `ActiveRecord::RecordInvalid` has internal means to treat its argument as an ActiveRecord
#   object, calling `errors.full_messages`, I18n and other unrelated stuff. Mocking and stubbing
#   is thus difficult. Appears to be much easier to just pass an actual AR object.
