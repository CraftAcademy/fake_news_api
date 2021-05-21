RSpec.describe 'POST /api/auth', type: :request do
  let(:member) { User.where(email: 'member@fakenews.com') }

  describe 'successfully' do
    before do
      post '/api/auth', params: {
        email: 'member@fakenews.com',
        password: 'password',
        password_confirmation: 'password',
        first_name: 'Bob',
        last_name: 'Kramer',
        role: 'member'
      }
    end

    it 'is expected to respond with status 200' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with success message' do
      expect(response_json['status']).to eq 'success'
    end

    it 'is expected to make a database record' do
      expect(member.present?).to eq true
    end
  end
end