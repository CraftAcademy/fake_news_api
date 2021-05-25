RSpec.describe 'PUT /api/articles/:id', type: :request do
  let!(:journalist) { create(:user, role: 'journalist') }
  let!(:article) { create(:article, title: 'Old Article', user_id: journalist.id) }
  let(:auth_headers) { journalist.create_new_auth_token }
  let(:updated_article) { Article.find(article.id) }

  describe 'successfully' do
    before do
      put "/api/articles/#{article.id}",
          params: {
            article: {
              title: 'New Article',
              teaser: 'Some damn teaser',
              body: "Husband found dead allegedly because he wasn't testing first or was he?!?!",
              category: 'Hollywood'
            }
          },
          headers: auth_headers
    end

    it 'is expected to response with status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with message' do
      expect(response_json['message']).to eq 'Your article has been successfully updated!'
    end

    it 'is expected to be the same journalist' do
      expect(updated_article['user_id']).to eq journalist.id
    end

    it 'is expected to have new title' do
      expect(updated_article['title']).to eq 'New Article'
    end

    it 'is expected to have new teaser' do
      expect(updated_article['teaser']).to eq 'Some damn teaser'
    end

    it 'is expected to have new body' do
      expect(updated_article['body']).to eq 'Husband found dead allegedly because he wasn\'t testing first or was he?!?!'
    end

    it 'is expected to have new category' do
      expect(updated_article['category']).to eq 'Hollywood'
    end
  end

  describe 'unsuccessfully, article does not exist' do
    before do
      put "/api/articles/#{article.id + 1}",
          params: {
            article: {
              title: 'New Article',
              teaser: 'Some damn teaser',
              body: "Husband found dead allegedly because he wasn't testing first or was he?!?!",
              category: 'Hollywood'
            }
          },
          headers: auth_headers
    end
    it 'is expected to response with status 404' do
      expect(response).to have_http_status 404
    end
    it 'is expected to give an error message' do
      expect(response_json['error_message']).to eq "Couldn\'t find Article with 'id'=#{article.id + 1}"
    end
  end

  describe 'unsuccessfully, not updated because of missing params' do
    before do
      put "/api/articles/#{article.id}",
          params: {
            article: {
              title: '',
              teaser: '',
              body: '',
              category: ''
            }
          },
          headers: auth_headers
    end
    it 'is expected to response with status 422' do
      expect(response).to have_http_status 422
    end
    it 'is expected to give an error message' do
      expect(response_json['message']).to eq "Article has not been updated"
    end
  end
end
