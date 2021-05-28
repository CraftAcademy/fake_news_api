RSpec.describe 'GET /api/backyards', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let(:auth_headers) { editor.create_new_auth_token }
  
  describe 'successfully' do
    let!(:backyard_article_1) { create(:article, title: 'First Article', location: 'Sweden') }
    let!(:backyard_article_2) { create(:article, title: 'Second Article', location: 'Denmark') }
    let!(:backyard_article_3) { create(:article, title: 'Second Article', location: 'Russia') }

    before do
      get '/api/articles',
          headers: auth_headers
    end

    it 'is expected to response with status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return 3 articles from all locations' do
      expect(response_json['articles'].count).to eq 3
    end
  end

  describe 'unsuccessfully as there is no articles' do
    before do
      get '/api/backyards',
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
