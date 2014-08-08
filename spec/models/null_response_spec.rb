require './app/models/null_response'

describe NullResponse do
  it 'returns an empty array for its body and a 204 status code when initialized' do
    null_response = NullResponse.new
    expect(null_response.body).to eq []
    expect(null_response.code).to eq 204
  end
end