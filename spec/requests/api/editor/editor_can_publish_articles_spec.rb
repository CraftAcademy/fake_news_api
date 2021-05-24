RSpec.describe 'PUT api/articles', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:journalist) { create(:user, role: 'journalist') }
  let!(:article) { create(:article, title: 'Old Article', user_id: journalist.id, published: false) }
  let!(:auth_headers) { editor.create_new_auth_token }
  let!(:auth_headers_journalist) { journalist.create_new_auth_token }


  describe 'successfully' do
    before do
      put "/api/articles/#{article.id}",
          params: { 
              published: true
          },
          headers: auth_headers
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a success message' do
      expect(response_json['message']).to eq 'Your article has been successfully updated!'
    end
  end
  describe 'unsuccessfully' do
    before do
      put "/api/articles/#{article.id}",
          params: { 
              published: true
          },
          headers: auth_headers_journalist
    end

    it 'is expected to return a 401 status' do
      expect(response).to have_http_status 401
    end

    it 'is expected to return a error message' do
      expect(response_json['error_message']).to eq 'You are not authorized to publish an article!'
    end
  end
end
