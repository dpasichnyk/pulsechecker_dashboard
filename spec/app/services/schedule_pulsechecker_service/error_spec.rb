describe SchedulePulsecheckerService::Error do
  include_dir_context __dir__

  it_behaves_like 'instantiatable'

  it do
    expect(described_class).to be < ServiceError
  end
end
