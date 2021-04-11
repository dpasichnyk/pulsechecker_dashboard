#
# See https://github.com/dadooda/rspec_include_dir_context.
#

RSpec.configure do |config|
  config.extend Module.new {
    # Include hierarchical contexts from <tt>spec/</tt> up to spec root.
    #
    #   describe Something do
    #     include_dir_context __dir__
    #     ...
    def include_dir_context(dir)
      # Compute root based on this file location.
      spec_root = File.expand_path('../..', __dir__)

      d, steps = dir, []
      while d.size >= spec_root.size
        steps << d
        d = File.split(d).first
      end

      steps.reverse.each do |d|
        begin; include_context d; rescue ArgumentError; end
      end

      # A hack. We've got 2 sub-environments: plain and Rails, which share the same directory root.
      # If we attempt to create 2 root contexts, RSpec will overwrite one with another.
      # Hence we use distinct special names for root contexts and load them by hand.
      begin; include_context 'spec_top'; rescue ArgumentError; end
      begin; include_context 'rails_top'; rescue ArgumentError; end
    end
  } # config.extend
end
