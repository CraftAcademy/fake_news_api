RSpec.describe 'GET /api/articles', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:journalist) { create(:user, role: 'journalist') }
  let!(:journalist2) { create(:user, role: 'journalist') }
  let(:auth_headers) { editor.create_new_auth_token }
  
  describe 'successfully' do
    let!(:article1) { create(:article, title: 'First Article', user_id: journalist.id) }
    let!(:article2) { create(:article, title: 'Second Article', user_id: journalist.id) }
    let!(:article3) { create(:article, title: 'Third Article', user_id: journalist2.id) }
    let!(:comment) { create(:comment, article_id: article3.id) }
    before do
      get '/api/articles',
          headers: auth_headers
    end

    it 'is expected to response with status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return 3 articles from all journalists' do
      expect(response_json['articles'].count).to eq 3
    end

    it 'is expected to return articles sorted by most recent' do
      expect(response_json['articles'].first['title']).to eq 'Third Article'
    end

    it 'is expected to have a status published' do
      expect(response_json['articles'].first['status']).to eq 'Published'
    end

    it 'is expected to contain amount of comments connected to the article' do
      expect(response_json['articles'].first['comments']).to eq 1
    end
  end

  describe 'unsuccessfully as there is no articles' do
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
