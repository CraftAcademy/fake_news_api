RSpec.describe 'GET api/backyards/:id', type: :request do
  let!(:backyard_article) { create(:backyard_article) }

  describe 'successfully' do
    before do
      get "/api/backyards/#{backyard_article.id}"
    end

    it "is expected to return 200 status" do
      expect(response).to have_http_status 200  
    end

    it "is expected to have title" do
      expect(response_json['backyard_articles']['title']).to eq 'My cat is really spying on me' 
    end
    
    it "is expected to have a body" do
      expect(response_json['backyard_articles']['body']).to eq 'My cat was flying yesterday'  
      
    end
    
    
  end
end
