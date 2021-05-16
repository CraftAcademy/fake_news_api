RSpec.describe 'GET /api/articles/?category=Science', type: :request do
  let!(:article) { 2.times { create(:article) } }
  let!(:article2) { 2.times { create(:article, category: 'Aliens') } }
  describe 'successfully' do
    before do
      get '/api/articles/?category=Science'
    end
    it 'is expected to return status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return 2 articles' do
      expect(response_json['articles'].count).to eq 2
    end

    it 'is expected to have the category that we ask for' do
      expect(response_json['articles'].first['category']).to eq 'Science'
    end
  end
  describe 'unsuccessfully with no articles of specified category' do
    before do
      get '/api/articles/?category=Hollywood'
    end

    it 'is expected to return status 200 ' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return an empty array' do
      expect(response_json['articles']).to eq []
    end
  end
end
