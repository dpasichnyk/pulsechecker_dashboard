# == Schema Information
#
# Table name: pulsecheckers
#
#  id         :bigint           not null, primary key
#  interval   :integer
#  kind       :integer
#  name       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_pulsecheckers_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :pulsechecker do
    association :user
    type { 1 }
    name { Faker::Company.name }
    url { 'https://google.com' }
    interval { 10 }
  end
end
