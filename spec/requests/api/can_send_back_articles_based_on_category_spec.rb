RSpec.describe 'GET /api/articles?category=Flat+Earth', type: :request do
  describe 'successfully' do
    before do
      get '/api/articles?category=Flat+Earth'
    end
  end

  it 'is expected to return status 200' do
    expect(response).to have_http_status 200
  end

  it 'is expected to return 2 articles' do
    expect(response_json['articles'].count).to eq 2 
  end

  it 'is expected to have the category that we ask for' do
    expect(response_json['articles'].first['category']).to eq 'Flat Earth'
  end
end