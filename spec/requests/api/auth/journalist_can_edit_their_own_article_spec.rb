RSpec.describe 'PUT /api/articles/:id', type: :request do
  let!(:journalist) { create(:user, role: 'journalist') }
  let!(:article) { create(:article, title: 'Old Article', user_id: journalist.id) }
  let(:auth_headers) { journalist.create_new_auth_token }

  describe 'successfully' do
    before do
      put "/api/articles/#{article.id}",
          params: {
            article: {
              title: 'New Article',
              teaser: 'Some damn teaser',
              body: "Husband found dead allegedly because he wasn't testing first or was he?!?!",
              category: 'Hollywood'
            }
          },
          headers: auth_headers
    end

    it 'is expected to response with status 200' do
      expect(response).to have_http_status 200
    end
    it 'is expected to return one article' do
      expect(response_json['article'].count).to eq 1
    end
    it 'is expected to be the same journalist' do
      expect(response_json['article']['user_id']).to eq journalist.id
    end
    it 'is expected to have new title' do
      expect(response_json['article']['title']).to eq 'New Article'
    end
    it 'is expected to have new teaser' do
      expect(response_json['article']['teaser']).to eq 'Some damn teaser'
    end
    it 'is expected to have new body' do
      expect(response_json['article']['body']).to eq 'Husband found dead allegedly because he wasn\'t testing first or was he?!?!'
    end
    it 'is expected to have new category' do
      expect(response_json['article']['category']).to eq 'Hollywood'
    end
  end
end
