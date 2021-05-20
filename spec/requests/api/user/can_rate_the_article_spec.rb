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

    it 'is expected to respond with 201' do
      expect(response).to have_http_status 201
    end

    it 'is expected to respond with a message' do
      expect(response_json['message']).to eq 'You successfuly rated this article'
    end

    it 'is expected to have a rating' do
      expect(rating.first['rating']).to eq 5
    end
  end
end
