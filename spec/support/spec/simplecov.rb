#
# See https://github.com/colszowka/simplecov.
#
# * IMPORTANT! This file must be required by hand BEFORE all others. Other that that it's a regular
#   RSpec "support" file.
#

# NOTE: Per convention, gem `simplecov` is not enabled by default. Thus this is a conditional
# require.
begin
  require 'simplecov'
  puts 'NOTE: SimpleCov starting'

  SimpleCov.start do
    # Configure SimpleCov if needed.
    # See https://github.com/colszowka/simplecov#configuring-simplecov.

    # Don't count these, we want real figures.
    add_filter('spec/')
  end
rescue LoadError
  # This is mostly a normal case, don't print anything.
end
