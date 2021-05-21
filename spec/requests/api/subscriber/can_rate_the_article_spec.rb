RSpec.describe 'POST /api/ratings', type: :request do
  let!(:subscriber) { create(:user, role: 'subscriber') }
  let(:article) { create(:article) }
  let(:rating) { Rating.where(article_id: article.id) }
  let(:auth_headers) { subscriber.create_new_auth_token }

  describe 'successfully' do
    before do
      post '/api/ratings',
           params: {
             article_id: article.id,
             rating: 5
           },
           headers: auth_headers

      post '/api/ratings',
           params: {
             article_id: article.id,
             rating: 3
           },
           headers: auth_headers
    end

    it 'is expected to respond with 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with a message' do
      expect(response_json['message']).to eq 'You successfuly rated this article'
    end

    it 'is expected to update the existing rating' do
      expect(rating.first['rating']).to eq 3
    end

    it 'is expected that member have a single rating' do
      expect(subscriber.ratings.length).to eq 1
    end
  end

  describe 'Unsuccessfully with wrong credentials' do
    before do
      post '/api/ratings',
           params: {
             article_id: article.id,
             rating: 5
           }
    end
    it 'is expected to response with status 401 ' do
      expect(response).to have_http_status 401
    end
    it 'is expected to have error message' do
      expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'Unsuccessfully with incorrect rating' do
    before do
      post '/api/ratings',
           params: {
             article_id: article.id,
             rating: 10
           },
           headers: auth_headers
    end
    it 'is expected to response with status 401 ' do
      expect(response).to have_http_status 422
    end
    it 'is expected to have error message' do
      expect(response_json['error_message']).to eq 'Can not process recieved parameters'
    end
  end
end
