# Make `require_dependency` available without Rails.
require 'active_support/dependencies'

# Optionally include developer-local spec helper.
File.readable?(fn = File.expand_path('spec_local.rb', __dir__)) and require fn

# Load support files.
Dir[File.expand_path('support/spec/**/*.rb', __dir__)].each { |fn| require fn }

# Load hierarchical `_spec_helper.rb` for shared contexts.
Dir[File.expand_path('**/_spec_helper.rb', __dir__)].each { |fn| require fn }

# Instantiate Rails autodetector.
require_rails = SpecSupport::RequireRails.new(
  subpaths: [
    'app'
  ]
)

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration.
RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate assertion/expectation library such
  # as wrong or the stdlib/minitest assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on a real object. This is
    # generally recommended, and will default to `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will have no way to turn it
  # off -- the option exists only for backwards compatibility in RSpec 3). It causes shared context
  # metadata to be inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

if require_rails.true?
  puts 'NOTE: Auto-loading `rails_helper.rb` based on spec file location'
  require 'rails_helper'
end
