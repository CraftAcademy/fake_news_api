RSpec.describe 'GET /api/articles', type: :request do
  let!(:journalist) { create(:user, role: 'journalist') }
  let(:auth_headers) { journalist.create_new_auth_token }

  describe 'successfully' do
    let!(:article1) { create(:article, title: 'First Article', user_id: journalist.id) }
    let!(:article2) { create(:article, title: 'Second Article', user_id: journalist.id) }
    before do
      get '/api/articles',
          headers: auth_headers
    end

    it 'is expected to response with status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return 2 articles to the right journalist' do
      expect(response_json['articles'].count).to eq 2
    end

    it 'is expected to return articles sorted by most recent' do
      expect(response_json['articles'].first['title']).to eq 'Second Article'
    end
  end
  describe 'unsuccessfully because journalist does not have any article' do
    let!(:article3) { create(:article, title: 'Third Article') }
    let!(:article4) { create(:article, title: 'Fourth Article') }
    before do
      get '/api/articles',
          headers: auth_headers
    end

    it 'is expected to response with status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return an empty array' do
      expect(response_json['articles']).to eq []
    end
  end
end
