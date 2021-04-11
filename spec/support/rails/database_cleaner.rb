#
# See https://github.com/DatabaseCleaner/database_cleaner#how-to-use.
#

require 'database_cleaner'

RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
