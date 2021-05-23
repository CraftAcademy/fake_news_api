RSpec.describe 'GET /api/backyards', type: :request do
  let!(:backyard_articles_denmark) { 2.times { create(:backyard_article, location: 'Denmark') } }
  let(:vistor_location) do
    file_fixture('visitor_location.json').read
  end
 

  describe 'Successfully' do
    let!(:backyard_articles) { 3.times { create(:backyard_article) } }
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
      get '/api/backyards/?lat=59.32021&lon=18.37827'
    end
  
    it 'is expected to respond with a 200 status' do
      expect(response).to have_http_status 200
    end
  
    it 'is expected to respond with a list of 3 articles' do
      expect(response_json['backyard_articles'].count).to eq 3
    end
  
    it 'is expected to return articles with a title' do
      expect(response_json['backyard_articles'].first['title']).to eq 'My cat is really spying on me'
    end
  
    it 'is expected to return articles with a theme' do
      expect(response_json['backyard_articles'].first['theme']).to eq 'Haunted animals'
    end
  
    it 'is expected to return articles with a date' do
      expect(response_json['backyard_articles'].first['date']).to eq Time.zone.now.strftime('%F, %H:%M')
    end
  
    it 'is expected to return articles with a written_by' do
      expect(response_json['backyard_articles'].first['written_by']).to eq 'Mr. Fake'
    end
  
    it 'is expected to return location as its own object' do
      expect(response_json['location']).to eq 'Sweden'
    end
  end

  describe 'Unsuccessfully with no articles of requested location' do
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
      get '/api/backyards/?lat=59.32021&lon=18.37827'
    end
    it 'is expected to respond with a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with an empty array' do
      expect(response_json['backyard_articles']).to eq []
    end

    it 'is expected to still respond with the location' do
      expect(response_json['location']).to eq 'Sweden'
    end
  end
end
