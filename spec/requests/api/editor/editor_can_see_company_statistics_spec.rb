RSpec.describe 'GET /api/statistics', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:editor_headers) { editor.create_new_auth_token }
  let!(:journalist)  { create(:user, role: 'journalist') } 
  let!(:journalist_headers) { journalist.create_new_auth_token }
  let!(:subscribers) { 2.times { create(:user, role: 'subscriber') } }
  let!(:published_articles) { 3.times { create(:article) } }
  let!(:unpublished_articles) { create(:article, published: false) }
  let!(:backyard_articles) { 3.times { create(:backyard_article) } }

  describe 'Successfully as an editor' do
    before do
      get '/api/statistics', headers: editor_headers
    end
  
    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end
  
    it 'is expected to return the total number of journalists' do
      expect(response_json['statistics']['journalists']['total']).to eq 8
    end
  
    it 'is expected to return the total number of articles' do
      expect(response_json['statistics']['articles']['total']).to eq 4
    end
  
    it 'is expected to return the total number of published articles' do
      expect(response_json['statistics']['articles']['published']).to eq 3
    end
  
    it 'is expected to return the total number of unpublished articles' do
      expect(response_json['statistics']['articles']['unpublished']).to eq 1
    end
  
    it 'is expected to return the total number of backyard articles' do
      expect(response_json['statistics']['backyard_articles']['total']).to eq 3
    end

    it 'is expected to return the total number of subscribers' do
      expect(response_json['statistics']['subscribers']['total']).to eq 2
    end
  end

  describe 'Unsuccessfully as a journalist' do
    before do
      get '/api/statistics', headers: journalist_headers
    end

    it 'is expected to return a 403 status' do
      expect(response).to have_http_status 403
    end

    it 'is expected to return an error message' do
      expect(response_json['error_message']).to eq 'You are not authorized to view this information'
    end
  end
end
