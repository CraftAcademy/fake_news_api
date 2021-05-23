RSpec.describe 'GET /api/backyard', type: :request do
  let!(:backyard_articles) {3.times {create(:backyard_article)}}
  let!(:backyard_articles) {2.times {create(:backyard_article, location: 'Denmark')}}
  let(:vistor_location) do
    file_fixture('visitor_location.json').read
  end

  before do
    stub_request(:get, 'https://nominatim.openstreetmap.org/reverse?accept-language=en&addressdetails=1&format=json&lat=59.32021&lon=18.37827')
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent' => 'Ruby'
      }
    )
    .to_return(status: 200, body: vistor_location, headers: {})
    get '/api/backyard/?lat=59.32021&lon=18.37827'
  end

  it 'is expected to respond with a 200 status' do
    expect(response).to have_http_status 200
  end

  it 'is expected to respond with a list of 3 articles' do
    expect(response_json['backyard_articles'])
  end

  it 'is expected to return articles with a title' do
    expect(response_json['backyard_articles'].first['title']]).to eq 'My cat is really spying on me'
  end

  it 'is expected to return articles with a title' do
    expect(response_json['backyard_articles'].first['theme']]).to eq 'Haunted animals'
  end

  it 'is expected to return articles with a title' do
    expect(response_json['backyard_articles'].first['date']]).to eq Time.zone.now().updated_at.strftime('%F, %H:%M')
  end

  it 'is expected to return articles with a title' do
    expect(response_json['backyard_articles'].first['written_by']]).to eq 'Bob Kramer'
  end

  it 'is expected to return articles with a title' do
    expect(response_json['backyard_articles'].first['location']]).to eq 'Sweden'
  end
end