RSpec.describe 'POST /api/auth', type: :request do
  let!(:editor) { create(:user, role: 'editor') }
  let!(:auth_headers) { editor.create_new_auth_token }

  describe 'succesfully' do
    before do
      post '/api/auth',
           params: {
             email: 'new_journalist@fakenews.com',
             password: 'password',
             password_confirmation: 'password',
             first_name: 'New',
             last_name: 'Guy',
             role: 'journalist'
           },
           headers: auth_headers
    end
    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to respond with success message' do
      expect(response_json['status']).to eq 'success'
    end

    it 'is expected to add journalist to database' do
      expect(User.find_by(email: 'new_journalist@fakenews.com').journalist?).to eq true
    end
  end

  describe 'unsuccessfully unauthorised' do
    before do
      post '/api/auth',
           params: {
             email: 'new_journalist@fakenews.com',
             password: 'password',
             password_confirmation: 'password',
             first_name: 'New',
             last_name: 'Guy',
             role: 'journalist'
           }
    end
    it 'is expected to respond with status 401' do
      expect(response).to have_http_status 401
    end

    it 'is expected to respond with a message' do
      expect(response_json['message']).to eq 'You are not authorised to add a journalist'
    end

    it 'is expected not to add journalist to the database' do
      expect(User.find_by(email: 'new_journalist@fakenews.com')).to eq nil
    end
  end
end
