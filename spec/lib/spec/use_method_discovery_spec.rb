RSpec.describe '.use_method_discovery feature' do
  include_dir_context __dir__

  # See "Implementation notes".
  describe '.use_method_discovery' do
    # Shared expectation.
    def find_no_descriptions
      raise_error(RuntimeError, /^No method-like descriptions found/)
    end

    # Shared expectation.
    def be_shadowed_by(other_m)
      raise_error(RuntimeError, /is shadowed by `#{other_m}`/)
    end

    # Shared expectation.
    def be_undefined
      raise_error NameError
    end

    context 'when not enabled per context tree' do
      describe '#method1' do
        it do
          expect { m }.to be_undefined
        end
      end
    end

    # NOTE: Discovery should not reach this far outside.
    describe '#wrapper_context' do
      context 'when enabled per context tree as `m`' do
        use_method_discovery(:m)

        # NOTE: We don't use `subject` here on purpose for clarity.
        # NOTE: First compare `m`, then compare `mm` if applicable.

        describe 'non-method sub-context' do
          it do
            expect { m }.to find_no_descriptions
          end
        end

        describe '#method1' do
          describe 'non-method' do
            context 'when re-enabled per sub-context as `mm`' do
              # NOTE: `mm` shadows `m` completely here.
              use_method_discovery(:mm)

              describe '#method11' do
                describe 'non-method' do
                  it do
                    expect { m }.to be_shadowed_by(:mm)
                    expect(mm).to eq :method11
                  end
                end # describe "non-method"

                it do
                  expect { m }.to be_shadowed_by(:mm)
                  expect(mm).to eq :method11
                end
              end # describe "#method11"

              it do
                expect { m }.to be_shadowed_by(:mm)
                expect { mm }.to find_no_descriptions
              end
            end

            it do
              expect(m).to eq :method1
              expect { mm }.to be_undefined
            end
          end # describe "non-method"

          it do
            expect { mm }.to be_undefined
            expect(m).to eq :method1
          end
        end # describe "#method1"
      end # context "when single declaration per context"
    end # describe "#wrapper_context"
  end # describe ".use_method_discovery"

  describe '._use_method_discovery_parser' do
    it 'generally works' do
      [
        ['hey', nil],
        ['#some_method!!', nil],
        ['#some method', nil],
        ['method', nil],
        ['#some_method', :some_method],
        ['#some_method=', :some_method=],
        ['#some_method?', :some_method?],
        ['#some_method!', :some_method!],
        ['.some_method', :some_method],
        ['::some_method', :some_method],
        ['#[]', :[]],
        ['.[]', :[]],
        ['::[]', :[]],
        ['GET some_action', :some_action],
        ['POST some_action', :some_action],
        ['PUT some_action', :some_action],
        ['DELETE some_action', :some_action]
      ].each do |input, expected|
        expect([input, self.class.send(:_use_method_discovery_parser, input)]).to eq [input, expected]
      end
    end
  end # describe "._use_method_discovery_parser"
end

#
# Implementation notes:
#
# * RSpec output for `.use_method_discovery` is somewhat confusing since the feature deals with
#   descriptions formatted as method. E.g. "#method1 should raise NameError" does not mean this.
#   It means that a NameError should occur WHEN description looks like "#method1".
