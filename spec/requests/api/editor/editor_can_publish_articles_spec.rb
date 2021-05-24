RSpec.describe 'PUT api/articles', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:journalist) { create(:user, role: 'journalist') }
  let!(:article) { create(:article, title: 'Old Article', user_id: journalist.id, published: false) }
  let!(:auth_headers) { editor.create_new_auth_token }

  describe 'successfully' do
    before do
      put "/api/articles/#{article.id}",
          params: {
            article: {
              title: 'Obnoxious Title',
              teaser: 'Some damn teaser',
              body: ["Husband found dead allegedly because he wasn't testing first"],
              category: 'Hollywood',
              premium: true,
              published: true
            }
          },
          headers: auth_headers
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a success message' do
      expect(response_json['message']).to eq 'Your article has been successfully been updated!'
    end
  end
end
