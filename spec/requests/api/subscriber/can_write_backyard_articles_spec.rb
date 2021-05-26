RSpec.describe 'POST /api/backyards', type: :request do
  let(:subscriber) { create(:user, role: 'subscriber') }
  let(:auth_headers) { subscriber.create_new_auth_token }

  describe 'successfully' do
    before do
      post '/api/backyards',
           params: {
             backyardArticle: {
               title: 'I am from the future!',
               theme: 'Buy Crypto',
               body: 'Crypto will rule the world',
               location: 'Sweden'
             }
           },
           headers: auth_headers
    end

    it 'is expected to return a 201 status' do
      expect(response).to have_http_status 201
    end

    it 'is expected to return a success message' do
      expect(response_json['message']).to eq 'Your backyard article has been successfully created!'
    end

    it 'is expected to add an article to the database' do
      articles = Article.all.where(backyard: true)
      expect(articles.count).to eq 1
    end
  end

  describe 'Unsuccessfully as a visitor' do
    before do
      post '/api/backyards',
           params: {
             backyardArticle: {
               title: 'Obnoxious Title',
               teaser: 'Some damn teaser',
               body: "Husband found dead allegedly because he wasn't testing first",
               category: 'Hollywood',
               premium: true
             }
           }
    end

    it 'is expected to have status 401' do
      expect(response).to have_http_status 401
    end

    it 'is expected that visitor cant create article' do
      expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'unsuccessfully with missing params' do
    before do
      post '/api/backyards',
           params: {
             backyardArticle: {
               title: '',
               teaser: 'Some damn teaser',
               body: "Husband found dead allegedly because he wasn't testing first",
               category: 'Hollywood',
               premium: true
             }
           },
           headers: auth_headers
    end
    it 'is expected to have status 422' do
      expect(response).to have_http_status 422
    end

    it 'is expected to return an error message' do
      expect(response_json['error_message']).to eq 'Please fill in all required fields'
    end
  end
end
