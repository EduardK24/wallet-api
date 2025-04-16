shared_examples 'a successful API request' do |status_code = 200|
  it 'returns the expected status code' do
    expect(response.status).to eq(status_code)
  end

  it 'returns JSON content type' do
    expect(response.content_type).to include('application/json')
  end

  it 'includes a success status in the response' do
    json_response = JSON.parse(response.body)
    expect(json_response['status']).to eq(status_code)
  end
end

shared_examples 'a failed API request' do |status_code = 400|
  it 'returns the expected error status code' do
    expect(response.status).to eq(status_code)
  end

  it 'returns JSON content type' do
    expect(response.content_type).to include('application/json')
  end

  it 'includes an error message in the response' do
    json_response = JSON.parse(response.body)
    expect(json_response['error'] || json_response['errors']).to be_present
  end
end

shared_examples 'a not found API request' do
  it_behaves_like 'a failed API request', 404

  it 'includes a not found message' do
    json_response = JSON.parse(response.body)
    expect(json_response['error'] || json_response['errors']).to include('not found')
  end
end

shared_examples 'a validation failure API request' do
  it_behaves_like 'a failed API request', 400

  it 'includes validation error details' do
    json_response = JSON.parse(response.body)
    expect(json_response['errors'] || json_response['error']).to be_present
  end
end

shared_examples 'a service error API request' do
  it_behaves_like 'a failed API request', 422
  
  it 'includes a specific error message' do
    json_response = JSON.parse(response.body)
    expect(json_response['error']).to be_present
  end
end 