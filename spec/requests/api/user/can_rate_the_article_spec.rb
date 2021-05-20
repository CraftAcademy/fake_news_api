RSpec.describe 'POST /api/ratings', type: :request do
  let!(:member) { create(:user, role: 'member') }
  let(:article) { create(:article) }
  let(:rating) { Rating.where(article_id: article.id) }
  let(:auth_headers) { member.create_new_auth_token }

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

    it 'is expected to have one rating' do
      expect(rating.length).to eq 1
    end

    it 'is expected to have a rating of 3' do
      expect(rating.first['rating']).to eq 3
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
