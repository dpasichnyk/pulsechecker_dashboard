require 'pathname'

module SpecSupport
  # Path-based Rails spec file autodetector.
  #
  #   require_rails = RequireRails.new(config: RSpec.configure { |_| _ }))
  #   ...
  #   if require_rails.true?
  #     require "rails_support"
  #   end
  #
  # OPTIMIZE: Make this a universal "spec type detector".
  # @see #config
  # @see #rails?
  class RequireRails
    # Subpaths of the spec tree, by which we detect Rails-specific tests.
    # @return [Array<String>]
    attr_accessor :subpaths

    attr_writer :config, :is_rails, :files_to_run, :root_path

    def initialize(attrs = {})
      attrs.each { |k, v| public_send("#{k}=", v) }
    end

    # RSpec configuration object. Default is <tt>RSpec.configure do |...|</tt> block value.
    # @return [RSpec::Core::Configuration]
    def config
      @config ||= RSpec.configure { |_| _ }
    end

    # An RSpec configuration object.
    # @return [RSpec::Core::Configuration]

    # @return [Array<String>]
    def files_to_run
      @files_to_run ||= require_attr(:config).files_to_run
    end

    # @return [String]
    def root_path
      # Compute root based on this file location.
      @root_path ||= Pathname(__dir__).realpath + '../..'
    end

    #---------------------------------------

    # Main method. Return <tt>true</tt> if Rails-specific spec files are present in {#files_to_run}.
    # @return [Boolean]
    # @see #rails?
    def is_rails
      require_attr :subpaths

      igetset(:is_rails) do
        config.files_to_run.any? do |fn|
          subpaths.any? { |_| fn.start_with? File.expand_path(_, root_path) }
        end
      end
    end

    alias_method :rails?, :is_rails
    alias_method :true?, :is_rails

    #---------------------------------------

    # Get/set an OTF instance variable of any type.
    private def igetset(attr, &compute)
      if instance_variable_defined?(k = "@#{attr}")
        instance_variable_get(k)
      else
        instance_variable_set(k, compute.call)
      end
    end

    # Require attribute to be set. Return attribute value.
    # @return [mixed]
    private def require_attr(name)
      send(name).tap do |_|
        # NOTE: Conform to more recent AttrMagic message format more or less.
        raise "Attribute `#{name}` must not be nil" if _.nil?
      end
    end
  end
end
