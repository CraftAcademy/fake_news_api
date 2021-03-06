RSpec.describe 'POST /api/auth/sign_in' do
  let!(:subscriber) { create(:user, role: 'subscriber', email: 'ordinary_guy@random.com') }
  let!(:journalist) { create(:user, role: 'journalist', email: 'pulizer_prize_guy@random.com') }

  describe 'admin-system' do
    describe 'as a subscriber' do
      before do
        post '/api/auth/sign_in', params: {
          email: 'ordinary_guy@random.com',
          password: 'password',
          source: 'admin-system'
        }
      end

      it do
        expect(response).to have_http_status 401
      end
    end

    describe 'as a journalist' do
      before do
        post '/api/auth/sign_in', params: {
          email: 'pulizer_prize_guy@random.com',
          password: 'password',
          source: 'admin-system'
        }
      end

      it do
        expect(response).to have_http_status 200
      end
    end
  end
end
