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
class Pulsechecker < ApplicationRecord
  enum kind: { https: 0, keyword: 1 }

  # associations
  belongs_to :user, inverse_of: :pulsecheckers
end
