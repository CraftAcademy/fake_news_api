RSpec.describe 'DELETE /api/articles/:id' do
  let(:article) { create(:article) }
  let(:editor) { create(:user, role: 'editor') }
  let(:editor_headers) { editor.create_new_auth_token }

  describe 'Successfully' do
    before do
      delete "/api/articles/#{article.id}", headers: editor_headers
    end

    it 'is expected to return status code 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a success message' do
      expect(response_json['message']).to eq 'The article was successfully deleted'
    end

    it 'is expected to have deleted article' do
      expect(Article.all.count).to eq 0
    end
  end

  describe 'Unsuccessfully because article does not exist' do
    before do
      delete '/api/articles/1337', headers: editor_headers
    end

    it 'is expected to return status code 404' do
      expect(response).to have_http_status 404
    end

    it 'is expected to return an error message' do
      expect(response_json['error_message']).to eq "Couldn't find Article with 'id'=1337"
    end
  end

  describe 'Unsuccessfully as a journalist' do
    let(:journalist) { create(:user, role: 'journalist') }
    let(:journalist_headers) { journalist.create_new_auth_token }

    before do
      delete "/api/articles/#{article.id}", headers: journalist_headers
    end

    it 'is expected to return status code 403' do
      expect(response).to have_http_status 403
    end

    it 'is expected to return an error message' do
      expect(response_json['error_message']).to eq 'You are not authorized to delete this article'
    end
  end
end
