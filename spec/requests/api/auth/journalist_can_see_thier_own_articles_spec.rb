RSpec.describe 'GET /api/articles', type: :request do
  let(:journalist1) { create(:user, role: 'journalist') }
  let!(:journalist2) { create(:user, role: 'journalist') }
  let!(:article1) { create(:article, title: 'Second Article') }
  let!(:article2) { create(:article, title: 'First Article') }
  let!(:article3) { create(:article, title: 'Third Article') }
  let!(:article4) { create(:article, title: 'Fourth Article') }
  let(:auth_headers) { journalist1.create_new_auth_token }
  let(:auth_headers) { journalist2.create_new_auth_token }

  describe 'successfully' do
    before do
      get '/api/articles',
          params: {
            article: {
              title: 'Obnoxious Title',
              teaser: 'Some damn teaser',
              body: "Husband found dead allegedly because he wasn't testing first",
              category: 'Hollywood'
            }
          },
          headers: auth_headers
    end

    it 'is expected to response with status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return 2 articles to the right journalist' do
      expect(response_json['articles']['role'].count).to eq 2
    end

    it 'is expected to have the category that we ask for' do
      expect(response_json['articles'].first['category']).to eq 'Flat Earth'
    end
  end
end
