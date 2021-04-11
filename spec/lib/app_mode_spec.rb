require 'rails_helper'

RSpec.describe AppMode do
  include_dir_context __dir__

  subject { described_class }

  def call(*args)
    subject.send(m, *args)
  end

  describe '.instance' do
    let_m
    it { expect(call).to be_a described_class::Instance }
  end

  describe 'delegates' do
    %i[
      admin_email
      allow_db_destruction?
      from_email
      rails_serve_static_files?
      root_domain
      root_url
      secret_key_base
      send_notifications?

      missing_required_evars
    ].each do |m|
      it { is_expected.to delegate_method(m).to(:instance) }
    end
  end
end
