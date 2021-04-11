require 'rails_helper'

module AppMode
  RSpec.describe Instance do
    include_dir_context __dir__

    def instance(attrs = {})
      described_class.new(attrs)
    end

    describe 'app-level settings' do
      subject { instance(attrs).public_send(m) }

      #
      # ## Setting test template ("STT")
      #
      # * Use `merge_range` to collect values from contexts in a stackable way.
      #
      # * Use this context hierarchy outside in:
      #
      #     rails_env       # "production" first, then the others, alphabetically.
      #       env           # {} first, then "NAME" => "value" or something.
      #         attribute
      #
      # * Depending on computing logic, omit `rails_env` or `env` contexts.
      # * For "production" test all possible inversions/redefinitions of the result.
      # * For other environments check a few basic inversions only (at least 1).
      #   E.g. test default -> `env` inversion.
      # * Loop over environments with idential behaviour.
      #

      def attrs
        merge_range('a_%d', 1..5)
      end

      describe '#admin_email' do
        let_m

        def self.ak; m; end
        def self.ek; "ADMIN_EMAIL"; end

        context_when a_1: { env: {} } do
          it { expect { subject }.to raise_error(RequiredEvarMissing, /#{self.class.ek}/) }
        end

        context_when a_1: { env: { ek => 'abc' } } do
          it { is_expected.to eq 'abc' }

          context_when a_2: { ak => 'def' } do
            it { is_expected.to eq 'def' }
          end
        end
      end

      describe '#allow_db_destruction?' do
        let_m

        def self.ak; :allow_db_destruction; end

        %w[production varying].each do |r_env|
          context_when a_1: { rails_env: r_env } do
            it { is_expected.to be false }

            context_when a_2: { ak => true } do
              it { is_expected.to be true }
            end
          end
        end

        %w[development staging test].each do |r_env|
          context_when a_1: { rails_env: r_env } do
            it { is_expected.to be true }

            context_when a_2: { ak => false } do
              it { is_expected.to be false }
            end
          end
        end
      end # describe "#allow_db_destruction?"

      describe '#from_email' do
        let_m

        def self.ak; m; end
        def self.ek; "FROM_EMAIL"; end

        context_when a_1: { env: {} } do
          it { is_expected.to eq 'info@pulsechecker.net' }
        end

        context_when a_1: { env: { ek => 'abc' } } do
          it { is_expected.to eq 'abc' }

          context_when a_2: { ak => 'def' } do
            it { is_expected.to eq 'def' }
          end
        end
      end # describe "#from_email"

      describe '#rails_serve_static_files?' do
        let_m

        def self.ak; :rails_serve_static_files; end
        def self.ek; "RAILS_SERVE_STATIC_FILES"; end

        %w[production staging varying].each do |r_env|
          context_when a_1: { rails_env: r_env } do
            context_when a_2: { env: {} } do
              it { is_expected.to eq false }

              context_when a_3: { env: { ek => 'true' } } do
                it { is_expected.to eq true }

                context_when a_4: { ak => false } do
                  it { is_expected.to eq false }
                end
              end
            end
          end
        end

        %w[development test].each do |r_env|
          context_when a_1: { rails_env: r_env } do
            context_when a_2: { env: {} } do
              it { is_expected.to eq true }

              context_when a_3: { env: { ek => 'false' } } do
                it { is_expected.to eq false }
              end
            end
          end
        end
      end

      describe '#root_domain' do
        let_m

        def self.ak; m; end
        def self.ek; "ROOT_DOMAIN"; end

        context_when a_1: { env: {} } do
          context_when a_2: { root_url: '' } do
            it { expect { subject }.to raise_error /^Invalid class of `root_url`/ }
          end

          context_when a_2: { root_url: 'not a URI' } do
            it { expect { subject }.to raise_error URI::InvalidURIError }
          end

          context_when a_2: { root_url: 'ftp://site.com' } do
            it { expect { subject }.to raise_error /^Invalid class of `root_url`/ }
          end

          context_when a_2: { root_url: 'http://site.isp.com:8000' } do
            it { is_expected.to eq 'site.isp.com' }

            context_when a_3: { env: { ek => 'abc' } } do
              it { is_expected.to eq 'abc' }

              context_when a_4: { ak => 'def' } do
                it { is_expected.to eq 'def' }
              end
            end
          end
        end
      end

      describe '#root_url' do
        let_m

        def self.ak; m; end
        def self.ek; "ROOT_URL"; end

        %w[production staging varying].each do |r_env|
          context_when a_1: { rails_env: r_env } do
            context_when a_2: { env: {} } do
              it { expect { subject }.to raise_error(RequiredEvarMissing, /#{self.class.ek}/) }

              context_when a_3: { env: { ek => 'abc' } } do
                it { is_expected.to eq 'abc' }

                context_when a_4: { ak => 'def' } do
                  it { is_expected.to eq 'def' }
                end
              end
            end
          end
        end

        %w[development test].each do |r_env|
          context_when a_1: { rails_env: r_env } do
            context_when a_2: { env: {} } do
              it { is_expected.to eq 'http://localhost:3000' }

              context_when a_3: { env: { ek => 'abc' } } do
                it { is_expected.to eq 'abc' }

                context_when a_4: { ak => 'def' } do
                  it { is_expected.to eq 'def' }
                end
              end
            end
          end
        end
      end # describe "#root_url"

      describe '#secret_key_base' do
        let_m
        let(:valid1) { self.class.valid1 }
        let(:valid2) { self.class.valid2 }

        def self.ak; m; end
        def self.ek; "SECRET_KEY_BASE"; end
        def self.valid1; "a"*30; end
        def self.valid2; "b"*30; end

        %w[production staging varying].each do |r_env|
          context_when a_1: { rails_env: r_env } do
            context_when a_2: { env: {} } do
              it { expect { subject }.to raise_error(RequiredEvarMissing, /#{self.class.ek}/) }

              context_when a_3: { env: { ek => "kk" } } do
                it { expect { subject }.to raise_error(InvalidValue, 'Invalid value, must be at least 30 hexadecimal chars: "kk"') }
              end

              context_when a_3: { env: { ek => valid1 } } do
                it { is_expected.to eq valid1 }

                context_when a_4: { ak => valid2 } do
                  it { is_expected.to eq valid2 }
                end
              end
            end
          end
        end

        %w[development test].each do |r_env|
          context_when a_1: { rails_env: r_env } do
            context_when a_2: { env: {} } do
              it { is_expected.to be_a String }
              it { is_expected.not_to be_blank }

              context_when a_3: { env: { ek => valid1 } } do
                it { is_expected.to eq valid1 }
              end
            end
          end
        end
      end # describe "#secret_key_base"

      describe '#send_notifications?' do
        let_m

        def self.ak; :send_notifications; end
        def self.ek; "DO_NOT_SEND_NOTIFICATIONS"; end

        %w[production staging].each do |r_env|
          context_when a_1: { rails_env: r_env } do
            context_when a_2: { env: {} } do
              it { is_expected.to eq true }

              context_when a_3: { env: { ek => 'true' } } do
                it { is_expected.to eq false }

                context_when a_4: { ak => true } do
                  it { is_expected.to eq true }
                end
              end
            end
          end
        end

        %w[development test varying].each do |r_env|
          context_when a_1: { rails_env: r_env } do
            context_when a_2: { env: {} } do
              it { is_expected.to eq false }

              context_when a_3: { env: { ek => 'false' } } do
                it { is_expected.to eq true }
              end
            end
          end
        end
      end # describe "#send_notifications?"
    end # describe "app-level settings"

    describe 'basic settings' do
      subject { instance.public_send(m) }

      describe '#env' do
        let_m

        describe 'default' do
          it { is_expected.to eq ENV.to_h }
        end
      end

      describe '#rails_env' do
        let_m

        describe 'default' do
          it { is_expected.to eq Rails.env }
        end

        # Step-by-step scenario looks more appropriate here.
        it 'generally works' do
          r = instance(m => 'something')
          expect(r.send(m)).to eq 'something'
          expect(r.send(m).something?).to be true
          expect(r.send(m).other?).to be false

          r.send("#{m}=", 'other')
          expect(r.send(m).other?).to be true
        end
      end
    end

    describe 'service methods' do
      describe '.env_value_truthy?' do
        let_m
        it 'generally works' do
          [
            ['', false],
            [' ', false],
            [0, false],
            ['0', false],
            ['kk', false],
            ['n', false],
            ['N', false],

            [1, true],
            ['1', true],
            ['y', true],
            ['Y', true],
            ['yes', true],
            ['YES', true],
            ['true', true]
          ].each do |input, expected|
            expect([input, described_class.send(m, input)]).to eq [input, expected]
          end
        end
      end

      # NOTE: Test a few cases, no need to test all values.
      describe '#env_truthy?' do
        let_m
        subject { instance(env: { 'VAR' => value }).send(m, 'VAR') }

        context_when value: 'false' do
          it { is_expected.to be false }
        end

        context_when value: 'no' do
          it { is_expected.to be false }
        end

        context_when value: 'true' do
          it { is_expected.to be true }
        end

        context_when value: 'yes' do
          it { is_expected.to be true }
        end
      end

      describe '#missing_required_evars' do
        let_m

        subject { instance(env: env, rails_env: rails_env).public_send(m) }

        # Check a few up-to-date required evars.
        context_when rails_env: 'development' do
          context_when env: {} do
            it { is_expected.to include('ADMIN_EMAIL') }
          end

          context_when env: { 'ADMIN_EMAIL' => 'joe@isp.com' } do
            it { is_expected.not_to include('ADMIN_EMAIL') }
          end
        end
      end
    end # describe "service methods"
  end # RSpec.describe Instance
end # module AppMode

#
# Implementation notes:
#
# * (!) See "Setting test template" comment at the beginning of the settings test block.
# * Methods `[self.]ak` and `[self.]ek` stand for "attribute key" and "environment key",
#   respectively.
# * Envrironment "varying" does not exist and is never going to. The tests use it as a generic
#   newly added environment string.
