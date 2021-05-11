RSpec.describe 'GET /api/articles', type: :request do
  describe 'successfully' do
    before do
      get '/api/articles'
    end

    it 'is expected to return 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to have lenght of 3 articles' do
      expect(response_json['articles'].count).to eq 3
    end

    it 'is expected to have a title' do
      expect(response_json['articles'].first['title']).to eq 'First title'
    end

    it 'is expected that the article has a teaser text' do
      expect(response_json['articles']['teaser']).to eq 'some text'
    end
  end
end