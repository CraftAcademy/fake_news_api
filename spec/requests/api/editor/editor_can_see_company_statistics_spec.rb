RSpec.describe 'GET /api/statistics', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:editor_headers) { editor.create_new_auth_token }
  let!(:journalist) { create(:user, role: 'journalist') }
  let!(:journalist_headers) { journalist.create_new_auth_token }
  let!(:published_articles1) { create(:article, created_at: Time.zone.now) }
  let!(:published_articles2) { create(:article, created_at: Time.zone.now - 100_000)  }
  let!(:published_articles3) { create(:article, created_at: Time.zone.now - 200_000)  }
  let!(:unpublished_articles) { create(:article, published: false) }
  let!(:backyard_articles) { 3.times { create(:backyard_article) } }
  let!(:subscriptions_data) do
    file_fixture('stripe_stats.json').read
  end

  describe 'Successfully as an editor' do
    before do
      stub_request(:get, 'https://api.stripe.com/v1/subscriptions')
        .to_return(status: 200, body: subscriptions_data, headers: {})
      get '/api/statistics', headers: editor_headers
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return the total number of journalists' do
      expect(response_json['statistics']['journalists']['total']).to eq 8
    end

    it 'is expected to return the total number of articles' do
      expect(response_json['statistics']['articles']['total']).to eq 4
    end

    it 'is expected to return the total number of published articles' do
      expect(response_json['statistics']['articles']['published']).to eq 3
    end

    it 'is expected to return the total number of unpublished articles' do
      expect(response_json['statistics']['articles']['unpublished']).to eq 1
    end

    it 'is expected to return the total number of backyard articles' do
      expect(response_json['statistics']['backyard_articles']['total']).to eq 3
    end

    it 'is expected to return the total number of subscribers' do
      expect(response_json['statistics']['subscribers']['total']).to eq 10
    end
  end

  describe 'Unsuccessfully as a journalist' do
    before do
      get '/api/statistics', headers: journalist_headers
    end

    it 'is expected to return a 403 status' do
      expect(response).to have_http_status 403
    end

    it 'is expected to return an error message' do
      expect(response_json['error_message']).to eq 'You are not authorized to view this information'
    end
  end
end
