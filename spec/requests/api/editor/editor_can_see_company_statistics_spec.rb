RSpec.describe 'GET /api/statistics', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:journalists) { 5.times { create(:user, role: 'journalist') } }
  let!(:articles) { 15.times { create(:article) } }
  let!(:backyard_articles) { 40.times { create(:backyard_article) } }

  let(:auth_headers) { editor.create_new_auth_token }
  before do
    get '/api/statistics', headers: auth_headers
  end

  it 'is expected to return a 200 status' do
    expect(response).to have_http_status 200
  end

  it 'is expected to return the total number of journalists' do
    expect(response_json['statistics']['journalists']).to eq 5
  end
end
