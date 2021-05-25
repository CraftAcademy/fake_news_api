RSpec.describe 'GET /api/articles', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:journalist) { create(:user, role: 'journalist') }
  let!(:journalist2) { create(:user, role: 'journalist') }
  let(:auth_headers) { editor.create_new_auth_token }

  describe 'successfully' do
    let!(:article1) { create(:article, title: 'First Article', user_id: journalist.id) }
    let!(:article3) { create(:article, title: 'Third Article', user_id: journalist2.id) }

    context 'is able to see article from journalist 1' do
      before do
        get "/api/articles/#{article1.id}",
            headers: {source: 'admin-system', **auth_headers}
      end
      
      it 'is expected to response with status 200' do
        expect(response).to have_http_status 200
      end

      it 'is expected to return the article from journalist 1' do
        expect(response_json['article']['title']).to eq 'First Article'
      end
    end

    context 'is able to see article from journalist 2' do
      before do
        get "/api/articles/#{article3.id}",
            headers: {source: 'admin-system', **auth_headers}
      end

      it 'is expected to response with status 200' do
        expect(response).to have_http_status 200
      end

      it 'is expected to return the article from journalist 2' do
        expect(response_json['article']['title']).to eq 'Third Article'
      end
    end

    context 'journalist 2 cannot see articles from journalist 1' do
      let(:journalist2_auth_headers) { journalist2.create_new_auth_token }
      
      before do
        get "/api/articles/#{article1.id}",
            headers: {source: 'admin-system', **journalist2_auth_headers}
      end

      it 'is expected to response with status 403' do
        expect(response).to have_http_status 403
      end

      it 'is expected to return an error message' do
        expect(response_json['error_message']).to eq 'You are not authorized to see this article'
      end
    end
  end

  describe 'unsuccessfully as there is no articles' do
    before do
      get '/api/articles',
                  headers: {source: 'admin-system', **auth_headers}
    end

    it 'is expected to response with status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return an empty array' do
      expect(response_json['articles']).to eq []
    end
  end
end
