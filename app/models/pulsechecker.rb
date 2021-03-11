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
class Pulsechecker < ApplicationRecord
  enum kind: { https: 0, keyword: 1 }

  # constants
  INTERVAL_VALUES = [
    10_000, 20_000, 30_000, 40_000, 50_000, 60_000,
    120_000, 180_000, 360_000, 720_000, 1_800_000, 3_600_000
  ].freeze

  RESPONSE_TIME_VALUES = [125, 250, 500, 1000, 2000].freeze

  # callbacks
  before_create :generate_slug

  # associations
  belongs_to :user, inverse_of: :pulsecheckers

  # validations
  validates :name, :kind, :interval, :url, presence: true
  validates :name, uniqueness: { scope: :user_id }

  private

  # Generate it until slug is unique.
  def generate_slug
    self.slug = loop do
      slug = SecureRandom.urlsafe_base64(4)
      break slug unless Pulsechecker.exists?(slug: slug)
    end
  end
end
