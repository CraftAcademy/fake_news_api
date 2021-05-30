RSpec.describe 'PUT /api/backyards/', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:journalist) { create(:user, role: 'journalist') }
  let!(:backyard_article) { create(:backyard_article, status: 'archived') }
  let!(:auth_headers) { editor.create_new_auth_token }
  let!(:auth_headers_journalist) { journalist.create_new_auth_token }

  describe 'successfully as an editor' do
    before do
      put "/api/backyards/#{backyard_article.id}",
          params: {
            status: 'published'
          },
          headers: auth_headers
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a success message' do
      expect(response_json['message']).to eq 'This backyard article has been successfully updated'
    end

    it 'is expected to set published status to true' do
      expect(backyard_article.reload.published?).to eq true
    end
  end

  describe 'unsuccessfully as a journalist' do
    before do
      put "/api/backyards/#{backyard_article.id}",
          params: {
            status: 'published'
          },
          headers: auth_headers_journalist
    end

    it 'is expected to return a 403 status' do
      expect(response).to have_http_status 403
    end

    it 'is expected to return a error message' do
      expect(response_json['error_message']).to eq 'You are not authorized to update this article'
    end
  end
end
