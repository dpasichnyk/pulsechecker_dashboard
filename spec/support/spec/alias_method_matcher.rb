#
# Method alias matcher.
#
#   describe User do
#     it { is_expected.to alias_method(:admin?, :is_admin) }
#   end
#
# Originally from: https://gist.github.com/1950961, but heavily reworked consistency-wise.
#

RSpec::Matchers.define :alias_method do |new_name, old_name|
  match do |subject|
    expect(subject.method(new_name)).to eq subject.method(old_name)
  end

  description do
    "have #{new_name.inspect} aliased to #{old_name.inspect}"
  end
end
