RSpec.describe 'POST /api/auth/sign_in', type: :request do
  let(:member) {create(:user, role: 'member', email: 'member@member.com')}
  let(:journalist) {create(:user, role: 'journalist', email: 'journalist@journalist.com')}

  describe 'as a member' do
    before do
      post '/api/auth/sign_in', params: {
        email: member.email,
        password: 'password',
        source: 'admin-system'
      }
    end

    it 'is expected to return a 401 status' do
      expect(response).to have_http_status 401
    end
  end

  describe 'as a journalist' do
     before do
      post '/api/auth/sign_in', params: {
        email: journalist.email,
        password: 'password',
        source: 'admin-system'
      }
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end
  end
end