RSpec.describe 'GET /api/statistics', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:journalists) { 2.times { create(:user, role: 'journalist') } }
  let!(:articles) { 5.times { create(:article) } }
  let!(:backyard_articles) { 5.times { create(:backyard_article) } }

  let(:auth_headers) { editor.create_new_auth_token }
  before do
    get '/api/statistics', headers: auth_headers
  end

  it 'is expected to return a 200 status' do
    expect(response).to have_http_status 200
  end

  it 'is expected to return the total number of journalists' do
    binding.pry
    expect(response_json['statistics']['journalists']['total']).to eq 12
  end

  it 'is expected to return the total number of articles' do
    expect(response_json['statistics']['articles']['total']).to eq 5
  end

  it 'is expected to return the total number of backyard articles' do
    expect(response_json['statistics']['backyard_articles']['total']).to eq 5
  end
end
