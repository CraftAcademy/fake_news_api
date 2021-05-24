RSpec.describe 'GET /api/articles/:id' do
  let!(:subscriber1) { create(:user, role: 'subscriber') }
  let(:auth_headers1) { subscriber1.create_new_auth_token }
  let!(:subscriber2) { create(:user, role: 'subscriber') }
  let(:auth_headers2) { subscriber2.create_new_auth_token }
  let!(:article) { create(:article) }

  describe 'successfully' do
    before do
      post '/api/ratings',
           params: {
             article_id: article.id,
             rating: 5
           },
           headers: auth_headers1
      post '/api/ratings',
           params: {
             article_id: article.id,
             rating: 2
           },
           headers: auth_headers2
      get "/api/articles/#{article.id}"
    end

    it 'is expected to return 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return title' do
      expect(response_json['article']['title']).to eq 'First title'
    end

    it 'is expected to return teaser' do
      expect(response_json['article']['teaser']).to eq 'some text'
    end

    it 'is expected to return body' do
      expect(response_json['article']['body'].first).to eq "Husband found dead allegedly because he wasn't testing first"
    end

    it 'is expected to return date' do
      expect(response_json['article']['date']).to eq Time.zone.now.strftime('%F, %H:%M')
    end

    it "is expected to include author's first name" do
      expect(response_json['article']['author']['first_name']).to eq 'Mr.'
    end

    it "is expected to include author's last name" do
      expect(response_json['article']['author']['last_name']).to eq 'Fake'
    end

    it 'is expected to show category' do
      expect(response_json['article']['category']).to eq 'Science'
    end

    it 'is expected to show if it is premium' do
      expect(response_json['article']['premium']).to eq true
    end

    it 'is expected to show average rating' do
      expect(response_json['article']['rating']).to eq 3.5
    end
  end

  describe 'unsuccessfully with no article' do
    before do
      get '/api/articles/123'
    end

    it 'is expected to response with status 404' do
      expect(response).to have_http_status 404
    end

    it 'is expected to have error message' do
      expect(response_json['error_message']).to eq "Couldn't find Article with 'id'=123"
    end
  end
end
