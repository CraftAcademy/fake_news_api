RSpec.describe 'POST /api/articles/:id/comments', type: :request do
  let(:article) { create(:article) }
  let(:subscriber) { create(:subscriber) }
  let(:subscriber_headers) { subscriber.create_new_auth_token }

  describe 'Successfully as a subscriber' do
    before do
      post "/api/articles/#{article.id}/comments", params: {
        body: 'What a great website, I have subscribed solely based on the awesome design!'
      },
      headers: subscriber_headers
    end

    it 'is expected to return status 201' do
      expect(response).to have_http_status 201
    end

    it 'is expected to respond with a success message' do
      expect(response_json['message']).to eq 'Your comment has been published'
    end

    it 'is expected to add a comment to the article' do
      expect(article.comments.count).to eq 1
    end

    it 'is expected to create an instance of a Comment with the expected body content' do
      expect(Comment.last['body']).to eq 'What a great website, I have subscribed solely based on the awesome design!'
    end
  end

  describe 'Unsuccessfully as a visitor' do
    before do
      post "/api/articles/#{article.id}/comments", params: {
        body: 'ITS FAKE NEWS'
      }
    end

    it 'is expected to return status 401' do
      expect(response).to have_http_status 401
    end

    it 'is expected to respond with an error message' do
      expect(response_json['errors'].first).to eq 'You need to sign in or sign up before continuing.'
    end
  end

  describe "unsuccessfully with empty body parameter" do
    before do
      post "/api/articles/#{article.id}/comments",
      headers: subscriber_headers
    end

    it "is expected to respond with a status of 422" do
      expect(response).to have_http_status 422  
    end

    it "is expected to respond with an error message" do
      expect(response_json['error_message']).to eq 'Comment can\'t be empty'  
    end
  end
end