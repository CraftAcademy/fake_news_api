RSpec.describe 'GET /api/articles/?category=Flat+Earth', type: :request do
  let!(:article) { 2.times { create(:article) } }
  let!(:article2) { 2.times { create(:article, category: 'Aliens') } }
  describe 'successfully' do
    before do
      get '/api/articles/?category=Flat+Earth'
    end
    it 'is expected to return status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return 2 articles' do
      expect(response_json['articles'].count).to eq 2
    end

    it 'is expected to have the category that we ask for' do
      expect(response_json['articles'].first['category']).to eq 'Flat Earth'
    end
  end
  describe 'unsuccessfull' do
    before do
      get '/api/articles/?category=bollywood'
    end
    
    it 'is expected to return status 404 ' do
      expect(response).to have_http_status 404
    end

    it 'is expected to return error message' do
      expect(response_json['error_message']).to eq 'This Category does not exist'
    end
  end
end
