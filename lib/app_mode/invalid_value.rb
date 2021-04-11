# NOTE: This and other error classes need this to satisfy SimpleCov when `bx rspec` runs.
#   Other than this we rely on Rails autoload.
require_dependency 'app_mode/error'

# OPTIMIZE: Place this and all other error classes under `Error::`. Make them `Error:SomeCase`.

module AppMode
  class InvalidValue < Error
  end
end
