RSpec.describe 'GET /api/articles', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:journalist) { create(:user, role: 'journalist') }
  let!(:journalist2) { create(:user, role: 'journalist') }
  let(:auth_headers) { editor.create_new_auth_token }

  describe 'successfully' do
    let!(:article1) { create(:article, title: 'First Article', user_id: journalist.id) }
    let!(:article3) { create(:article, title: 'Third Article', user_id: journalist2.id) }

    it 'is expected to response with status 200' do
      expect(response).to have_http_status 200
    end

    context 'is able to see article from journalist 1' do
      before do
        get "/api/articles/#{article1.id}",
            headers: auth_headers
      end
      it 'is expected to have a published status of true' do
        expect(response_json['articles'].first['title']).to eq 'First Article'
      end
    end

    context 'is able to see article from journalist 2' do
      before do
        get "/api/articles/#{article3.id}",
            headers: auth_headers
      end
      it 'is expected to return articles sorted by most recent' do
        expect(response_json['articles'].first['title']).to eq 'Third Article'
      end
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
