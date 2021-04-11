RSpec.describe '#prevent_call' do
  include_dir_context __dir__

  let(:obj) { Object.new }

  before :each do
    prevent_call(obj, :acts_like?)
  end

  it "generally works" do
    expect { obj.acts_like? :anything }.to raise_error /^Preventing call to .+?\.acts_like\?` with \[:anything\]$/
  end
end
