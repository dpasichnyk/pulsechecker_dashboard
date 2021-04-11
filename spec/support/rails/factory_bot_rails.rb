#
# See https://github.com/thoughtbot/factory_bot.
#

require 'factory_bot_rails'

# Extend FactoryGirl with our own methods. Might need it some time. Hackish, but it works.
# See https://github.com/thoughtbot/factory_girl/issues/564.
module FactoryBot
  class SyntaxRunner
    # def fixture_path
    #   Rails.root + "spec/fixtures"
    # end
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
