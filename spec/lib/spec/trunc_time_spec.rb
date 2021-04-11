RSpec.describe '#trunc_time' do
  include_dir_context __dir__
  use_method_discovery(:m)

  def call(*args)
    send(m, *args)
  end

  describe 'matrix' do
    def self.doit
      it do
        # A == B != C.
        eq1, eq2, neq = *abc.map { |_| Time.at(_) }
        expect(call(eq1, precision)).not_to eq call(neq, precision)
        expect(call(eq1, precision)).to eq call(eq2, precision)
      end
    end

    context_when precision: 5, abc: [1508676491.699080, 1508676491.699089, 1508676491.699090] do
      doit
    end

    context_when precision: 4, abc: [1508676491.699100, 1508676491.699199, 1508676491.699200] do
      doit
    end
  end
end
