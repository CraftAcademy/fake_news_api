RSpec.describe 'GET /api/backyards/:id', type: :request do
  let!(:backyard_article) { create(:backyard_article) }
  let!(:article) { create(:article) }

  describe 'successfully' do
    before do
      get "/api/backyards/#{backyard_article.id}"
    end

    it 'is expected to return 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to have title' do
      expect(response_json['backyard_article']['title']).to eq 'My cat is really spying on me'
    end

    it 'is expected to have a body' do
      expect(response_json['backyard_article']['body']).to eq 'My cat was flying yesterday'
    end

    it 'is expected to include written by Mr. fake' do
      expect(response_json['backyard_article']['written_by']).to eq 'Mr. Fake'
    end

    it 'is expected to show category' do
      expect(response_json['backyard_article']['theme']).to eq 'Haunted animals'
    end
  end

  describe 'unsuccessfully with non-existent article' do
    before do
      get '/api/backyards/123'
    end

    it 'is expected to return 404 status' do
      expect(response).to have_http_status 404
    end

    it 'is expected to have error message' do
      expect(response_json['error_message']).to eq "This article does not exist"
    end
  end

  describe 'unsuccessfully with an id from a normal article' do
    before do
      get "/api/backyards/#{article.id}"
    end

    it 'is expected to return 404 status' do
      expect(response).to have_http_status 404
    end
    it 'is expected to have error message' do
      expect(response_json['error_message']).to eq "This article does not exist"
    end
  end

  describe 'unsuccessfully if the article is archived' do
    let!(:archived_backyard_article) { create(:backyard_article, status: 'archived') }
    before do
      get "/api/backyards/#{archived_backyard_article.id}"
    end

    it 'is expected to response with status 404' do
      expect(response).to have_http_status 404
    end

    it 'is expected to have error message' do
      expect(response_json['error_message']).to eq "This article does not exist"
    end
  end
end
