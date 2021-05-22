RSpec.describe 'POST api/auth/sign_in', type: :request do
  let!(:subscriber) { create(:user, role: 'subscriber', email: 'subscriber@gmail.com') }
  let!(:journalist) { create(:user, role: 'journalist', email: 'mrfake@fakenews.com') }

  describe 'successfully' do
    describe 'as a subscriber' do
      before do
        post '/api/auth/sign_in', params: {
          email: 'subscriber@gmail.com',
          password: 'password'
        }
      end

      it 'is expeced to respond with a 200 status' do
        expect(response).to have_http_status 200
      end
    end

    describe 'as a journalist' do
      before do
        post '/api/auth/sign_in', params: {
          email: 'mrfake@fakenews.com',
          password: 'password'
        }
      end

      it 'is expected to respond with a 200' do
        expect(response).to have_http_status 200
      end
    end
  end
  describe 'unsuccessfully' do
    describe 'as a non-subscriber' do
      before do
        post '/api/auth/sign_in', params: {
          email: 'visitor@gmail.com',
          password: 'password'
        }
      end

      it 'is expected to respond with a 401' do
        expect(response).to have_http_status 401
      end
    end
  end
end
