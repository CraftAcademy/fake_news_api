RSpec.describe 'POST api/auth/sign_in', type: :request do
  let!(:member) { create(:user, role: 'member', email: 'member@gmail.com') }
  let!(:journalist) { create(:user, role: 'journalist', email: 'mrfake@fakenews.com') }

  describe 'public-system' do
    describe 'as a member' do
      before do
        post '/api/auth/sign_in', params: {
          email: 'member@gmail.com',
          password: 'password',
          source: 'public-system'
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
          password: 'password',
          source: 'public-system'
        }
      end

      it "is expected to respond with a 200" do
        expect(response).to  have_http_status 200
      end
      
    end
  end

  describe 'as a non-member' do
    before do
      post '/api/auth/sign_in', params: {
        email: 'visitor@gmail.com',
        password: 'password',
        source: 'public-system'
      }
    end

    it 'is expected to respond with a 401' do
      expect(response).to have_http_status 401
    end
  end
end
