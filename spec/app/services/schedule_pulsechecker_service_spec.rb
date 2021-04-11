describe SchedulePulsecheckerService do
  include_dir_context __dir__
  use_cl2 :let_a, :attrs

  it_behaves_like 'instantiatable'

  let(:instance) { described_class.new!(attrs) }

  let(:error_namespace) { described_class::Error }

  describe 'instance methods' do
    use_method_discovery :m

    # Declare.
    let_a(:interval) { 1000 }
    let_a(:kind) { 'https' }
    let_a(:name) { 'awesome_name_21' }
    let_a(:url) { 'https://service.isp' }
    let_a(:user_id) { 666 }

    subject { instance.send(m) }

    describe 'actions' do
      describe '#perform' do
        context 'when error' do
          context 'unknown pulsechecker `kind`' do
            context_when kind: 'gibberish_kind' do
              it do
                expect { subject }.to raise_error(error_namespace::KindNotAllowedError, /unknown kind: #{kind}/)
              end
            end
          end # context "unknown pulsechecker `kind`"

          context 'unsupported interval' do
            context_when interval: 999 do
              it do
                expect { subject }.to raise_error(error_namespace::UnsupportedIntervalError, /unsupported interval: #{interval}/)
              end
            end
          end # context "unsupported interval"
        end # context "when error"

        context 'when success' do
          it do
            expect(instance).to receive(:perform).once
            subject
          end
        end # context "when success"
      end # describe "#perform"
    end # describe "actions"

    describe 'attributes' do
      describe '#allowed_kinds' do
        it { is_expected.to eq %w[https] }
      end

      describe '#api_key' do
        let(:scheduler_api_key_signature) { 'scheduler_api_key_21' }

        it do
          expect(AppMode).to receive(:scheduler_api_key)
            .once
            .and_return(scheduler_api_key_signature)

          is_expected.to eq scheduler_api_key_signature
        end
      end

      describe '#base_url' do
        let(:scheduler_api_url_signature) { 'http://provider.isp' }
        let(:scheduler_api_url_path_signature) { '/bla/bla' }

        it do
          expect(AppMode).to receive(:scheduler_api_url)
            .once
            .and_return(scheduler_api_url_signature)

          expect(instance).to receive(:path)
            .once
            .and_return(scheduler_api_url_path_signature)

          is_expected.to eq scheduler_api_url_signature + scheduler_api_url_path_signature
        end
      end

      describe '#interval_range' do
        it { is_expected.to be_a Range }
        it { is_expected.to eq 1000..3_600_000 }
      end

      describe '#is_interval_allowed' do
        context 'when negative' do
          context_when interval: 3.hours.in_milliseconds do
            it { is_expected.to eq false }
          end
        end

        context 'when positive' do
          context_when interval: 1.hour.in_milliseconds do
            it { is_expected.to eq true }
          end
        end
      end

      describe '#is_kind_allowed' do
        context 'when negative' do
          context_when kind: 'babushka_21' do
            it { is_expected.to eq false }
          end
        end

        context 'when positive' do
          it { is_expected.to eq true }
        end
      end

      describe '#path' do
        it { is_expected.to eq 'v1/schedule' }
      end

      describe '#request' do
        let(:api_key) { 'api_key_signature_21' }
        let(:net_http_double) { double :net_http }
        let(:net_http_post_request_double) { double :net_http_post_request }
        let(:path) { '/some_path' }
        let(:request_data) { { signature_21: 'a123' } }
        let(:scheme) { 'http' }
        let(:uri) { "#{scheme}://provider.isp:666#{path}" }

        def expect_post_request
          instance.send(:base_url=, uri)
          instance.send(:api_key=, api_key)
          instance.send(:request_data=, { signature_21: 'a123' })

          expect(Net::HTTP).to receive(:new)
            .with('provider.isp', 666)
            .once
            .and_return(net_http_double)

          expect(Net::HTTP::Post).to receive(:new)
            .with(path)
            .once
            .and_return(net_http_post_request_double)

          yield if block_given?

          expect(net_http_post_request_double).to receive(:[]=)
            .with('api_key', api_key)
            .once

          expect(net_http_post_request_double).to receive(:[]=)
            .with('Content-Type', 'application/json')
            .once

          expect(net_http_post_request_double).to receive(:body=)
            .with(request_data.to_json)
            .once

          expect(net_http_double).to receive(:request)
            .with(net_http_post_request_double)
            .once
        end

        context_when scheme: 'http' do
          it 'doesn\'t enable SSL' do
            expect_post_request do
              expect(net_http_double).not_to receive(:use_ssl)
            end

            subject
          end
        end

        context_when scheme: 'https' do
          it 'enables SSL' do
            expect_post_request do
              expect(net_http_double).to receive(:use_ssl=)
                .with(true)
                .once
            end

            subject
          end
        end
      end

      describe '#request_data' do
        it { is_expected.to eq({ interval: interval, kind: kind, name: name, url: url, userId: user_id }) }
      end

      describe '#result' do
        let(:body_signature) { 'signature_21' }
        let(:code) { '200' }
        let(:response_double) { double 'response' }

        before do
          expect_status_code
        end

        def expect_status_code
          instance.send(:request=, response_double)

          expect(response_double).to receive(:code)
            .at_least(:once)
            .and_return(code)
        end

        context 'when error' do
          context_when code: '401' do
            it do
              expect { subject }.to raise_error(error_namespace::UnauthorizedError, /^Unauthorized$/)
            end
          end

          context_when code: '422' do
            it do
              expect { subject }.to raise_error(error_namespace::ValidationError, /^Unable to validate one or more attributes$/)
            end
          end

          context_when code: '999' do
            it do
              expect { subject }.to raise_error(error_namespace::SchedulingError, /^Unhandled scheduler error$/)
            end
          end
        end

        context 'when success' do
          context_when code: '200' do
            it 'parses `body`' do
              expect(response_double).to receive(:body)
                .once
                .and_return(body_signature)

              expect(JSON).to receive(:parse)
                .with(body_signature)
                .once

              subject
            end
          end
        end
      end

      describe '#should_use_ssl' do
        before do
          instance.send(:base_url=, scheduler_url)
        end

        context_when scheduler_url: 'http://some.isp' do
          it { is_expected.to eq false }
        end

        context_when scheduler_url: 'https://some.isp' do
          it { is_expected.to eq true }
        end
      end # describe "#should_use_ssl"
    end # describe "attributes"
  end # describe "instance methods"
end
