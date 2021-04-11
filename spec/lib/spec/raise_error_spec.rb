#
# A live demo+guideline of RSpec's `raise_error` matcher modes. Acts as a set of usable examples
# for precise yet affordable error matching.
#
RSpec.describe '.raise_error' do
  include_dir_context __dir__

  def doit
    klass = begin; public_send(:klass); rescue NoMethodError; nil; end
    message = begin; public_send(:message); rescue NoMethodError; nil; end

    if klass
      if message
        raise klass, message
      else
        raise klass
      end
    else
      if message
        raise message
      else
        # Probably, an incorrect test. Don't raise, let the expectation fail.
        STDERR.puts "#{__FILE__}:#{__LINE__}: Neither `klass` nor `message` is given, check your tests"
      end
    end
  end

  def exp
    expect { doit }
  end

  # NOTE: Here and below use doc-like "GOOD:" and "BAD:" labels.
  context_when message: 'hey' do
    describe 'GOOD:' do
      it { exp.to raise_error(RuntimeError, 'hey') }
      it { exp.to raise_error(RuntimeError, /e/) }
      it { exp.to raise_error(StandardError, 'hey') }
    end

    describe 'BAD:' do
      it { exp.to raise_error RuntimeError }
      it { exp.to raise_error 'hey' }
      it { exp.to raise_error /e/ }
    end
  end

  context_when klass: ArgumentError do
    describe 'GOOD:' do
      it { exp.to raise_error ArgumentError }
      it { exp.to raise_error StandardError }
    end
  end

  context_when klass: ArgumentError, message: 'hey' do
    describe 'GOOD:' do
      it { exp.to raise_error(ArgumentError, 'hey') }
      it { exp.to raise_error(ArgumentError, /e/) }
      it { exp.to raise_error(StandardError) }
    end

    describe 'BAD:' do
      it { exp.to raise_error 'hey' }
    end
  end
end
