RSpec.shared_examples 'not found' do
  it 'returns a 404 response status' do
    expect(subject.status).to eq 404
  end

  it 'returns errors: not found' do
    expect(subject.body).to eq({ errors: ['Not found.'] }.to_json)
  end
end