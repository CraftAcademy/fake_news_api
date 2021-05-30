RSpec.describe 'PUT /api/backyards/:id' do
  let(:article) { create(:backyard_article) }
  let(:editor) { create(:user, role: 'editor') }
  let(:editor_headers) { editor.create_new_auth_token }

  describe 'Successfully' do
    before do
      put "/api/backyards/#{article.id}",
          params: {
            status: 'archived'
          },
          headers: editor_headers
    end

    it 'is expected to return status code 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a success message' do
      expect(response_json['message']).to eq 'This backyard article has been successfully updated'
    end

    it 'is expected to have archive article' do
      expect(Article.where(status: 'archived').count).to eq 1
    end
  end

  describe 'Unsuccessfully because article does not exist' do
    before do
      put "/api/backyards/#{article.id + 1}",
          params: {
            status: 'archived'
          },
          headers: editor_headers
    end

    it 'is expected to return status code 404' do
      expect(response).to have_http_status 404
    end

    it 'is expected to return an error message' do
      expect(response_json['error_message']).to eq "Couldn't find Article with 'id'=#{article.id + 1}"
    end
  end

  describe 'Unsuccessfully as a journalist' do
    let(:journalist) { create(:user, role: 'journalist') }
    let(:journalist_headers) { journalist.create_new_auth_token }

    before do
      put "/api/backyards/#{article.id}",
          params: {
            status: 'archived'
          },
          headers: journalist_headers
    end

    it 'is expected to return status code 403' do
      expect(response).to have_http_status 403
    end

    it 'is expected to return an error message' do
      expect(response_json['error_message']).to eq 'You are not authorized to update this article'
    end
  end
end
