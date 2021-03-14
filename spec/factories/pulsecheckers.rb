# == Schema Information
#
# Table name: pulsecheckers
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(TRUE), not null
#  interval      :integer          not null
#  kind          :integer          not null
#  name          :string           default(""), not null
#  response_time :integer          default(500), not null
#  slug          :string           not null
#  url           :string           default(""), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_pulsecheckers_on_name_and_user_id  (name,user_id) UNIQUE
#  index_pulsecheckers_on_user_id           (user_id)
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
