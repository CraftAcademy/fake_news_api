RSpec.describe 'POST /api/articles', type: :request do
  let(:journalist) { create(:user, role: 'journalist') }
  let(:auth_headers) { journalist.create_new_auth_token }
  let(:image) do
    File.read(fixture_path + '/fake-news-fixture.txt')
  end

  describe 'successfully' do
    before do
      post '/api/articles',
           params: {
             article: {
               title: 'Obnoxious Title',
               teaser: 'Some damn teaser',
               body: ["Husband found dead allegedly because he wasn't testing first"],
               category: 'Hollywood',
               image: image,
               premium: true
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

    it 'is expected to have attached an image' do
      article = Article.last
      expect(article.image.attached?).to eq true
    end
  end

  describe 'unsuccessfully if user is not a journalist' do
    let(:member) { create(:user, role: 'member') }
    let(:auth_headers_member) { member.create_new_auth_token }
    before do
      post '/api/articles',
           params: {
             article: {
               title: 'Obnoxious Title',
               teaser: 'Some damn teaser',
               body: ["Husband found dead allegedly because he wasn't testing first"],
               category: 'Hollywood',
               premium: true
             }
           },
           headers: auth_headers_member
    end

    it 'is expected to have status 403' do
      expect(response).to have_http_status 403
    end

    it 'is expected that member cant create article' do
      expect(response_json['error_message']).to eq 'You are not authorized to create an article'
    end

    it 'is expected not to add an article to the database' do
      articles = Article.all
      expect(articles.count).to eq 0
    end
  end

  describe 'unsuccessfully' do
    before do
      post '/api/articles',
           params: {
             article: {
               title: 'Obnoxious Title',
               teaser: 'Some damn teaser',
               body: ["Husband found dead allegedly because he wasn't testing first"],
               category: 'Hollywood',
               premium: true
             }
           },
           headers: { wrong_headers: 'wrong headers' }
    end

    it 'is expected to have status 401' do
      expect(response).to have_http_status 401
    end

    it 'is expected that journalist cant create article' do
      expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
    end
  end

  describe 'unsuccessfully with missing params' do
    before do
      post '/api/articles',
           params: {
             article: {
               title: '',
               teaser: 'Some damn teaser',
               body: ["Husband found dead allegedly because he wasn't testing first"],
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
