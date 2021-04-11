RSpec.describe '.described_sym' do
  include_dir_context __dir__

  describe ActiveSupport do
    it { expect(described_sym).to eq :active_support }
  end
end

RSpec.describe '.me' do
  include_dir_context __dir__

  describe ActiveSupport do
    it { expect(described_sym).to eq :active_support }
  end
end
