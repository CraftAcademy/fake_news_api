RSpec.describe 'POST /api/articles', type: :request do
  let(:journalist) { create(:user, role: 'journalist') }
  let(:auth_headers) { journalist.create_new_auth_token }

  describe 'successfully' do
    before do
      post '/api/articles',
           params: {
             article: {
               title: 'Obnoxious Title',
               teaser: 'Some damn teaser',
               body: "Husband found dead allegedly because he wasn't testing first",
               category: 'Hollywood',
               user_id: journalist.id
             }
           },
           headers: auth_headers
    end

    it 'is expected to return a 201 status' do
      expect(response).to have_http_status 201
    end

    it 'is expected to return a success message' do
      expect(response_json['message']).to eq 'Your article has been successfully created!'
    end

    it 'is expected to add an article to the database' do
      articles = Article.all
      expect(articles.count).to eq 1
    end
  end
end
