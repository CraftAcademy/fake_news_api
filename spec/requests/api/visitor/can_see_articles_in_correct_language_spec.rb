RSpec.describe 'GET api/articles', type: :request do
  let!(:article_en) { create(:article, language: 'EN') }
  let!(:article_se) { create(:article, language: 'SE') }

  describe 'succesfully, in english, with no params' do
    before do
      get '/api/articles'
    end

    it 'is expected to have status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return one article' do
      expect(response_json['articles'].length).to eq 1
    end

    it 'is expected to return article in english' do
      expect(response_json['articles'].first['language']).to eq 'EN'
    end
  end

  describe 'succesfully, in swedish' do
    before do
      get '/api/articles/?language=se'
    end

    it 'is expected to have status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return one article' do
      expect(response_json['articles'].length).to eq 1
    end

    it 'is expected to return article in swedish' do
      expect(response_json['articles'].first['language']).to eq 'SE'
    end
  end
end
