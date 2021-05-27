RSpec.describe 'GET /api/articles/:id', type: :request do
  let!(:article) { create(:article) }

  describe 'Successfully' do
    let(:subscriber_1) { create(:subscriber) }
    let(:subscriber_2) { create(:subscriber) }
    before do
      article.comments.create(user_id: subscriber_1.id, body: 'I see dead people!')
      article.comments.create(user_id: subscriber_2.id, body: 'My husband is always coming home late from work...')
      get "/api/articles/#{article.id}"
    end
    
    it 'responds with a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return an article with a list of 2 comments' do
      expect(response_json['article']['comments'].count).to eq 2 
    end

    it 'is expected to return the comment\'s user' do
      expect(response_json['article']['comments'].first['user']).to eq 'Mrs. Fake' 
    end

    it 'is expected to return the comment\'s body' do
      expect(response_json['article']['comments'].first['body']).to eq 'My husband is always coming home late from work...' 
    end

    it 'is expected to return the comment\'s date of creation' do
      expect(response_json['article']['comments'].first['body']).to eq Time.zone.now().strftime('%F') 
    end
  end
end