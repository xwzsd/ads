require File.expand_path '../spec_helper.rb', __FILE__

describe 'return ad list' do
  it 'should allow accessing the home page and return ad list' do
    get '/'
    expect(last_response.status).to eq 200
  end
end

describe 'create ad' do
  it 'should create ad' do
    post '/ads', title: 'Test title', description: 'Test desc', city: 'New York', user_id: 1
    expect(last_response.status).to eq 200
  end
end

describe 'create ad with error' do
  it 'should get validation error' do
    post '/ads', title: 'Test title', description: 'Test desc', city: 'New York'
    expect(last_response.status).to eq 422
  end
end
