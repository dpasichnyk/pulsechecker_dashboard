# == Schema Information
#
# Table name: pulsecheckers
#
#  id         :bigint           not null, primary key
#  interval   :integer          not null
#  kind       :integer          not null
#  name       :string           default(""), not null
#  url        :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
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
class Pulsechecker < ApplicationRecord
  enum kind: { https: 0, keyword: 1 }

  # associations
  belongs_to :user, inverse_of: :pulsecheckers

  # validations
  validates :name, :kind, :interval, :url, presence: true
  validates :name, uniqueness: { scope: :user_id }
end
