# app.rb
require 'roda'
require 'sequel'
require 'securerandom'

DB = Sequel.sqlite('otps.db')

class App < Roda
  plugin :json
  plugin :all_verbs
  plugin :default_headers, 'Content-Type'=>'application/json'

  route do |r|
    r.on 'send' do
      r.post do
        params = JSON.parse(r.body.read)

        if params['phone'].nil? || params['phone'].empty?
          r.response.status = 422 # Unprocessable Entity
          { message: 'Phone is required' }.to_json
        else
          code = SecureRandom.random_number(100_000..999_999)
          otp = DB[:otps].insert(
            uuid: SecureRandom.uuid,
            phone: params['phone'],
            code: code, # Generate a random OTP
            status: 'sent',
            expired_at: Time.now + 600 # OTP expires in 10 minutes
          )
          r.response.status = 201
          { id: otp, code: code }.to_json
        end
      end
    end
    
    r.on 'check' do
      r.post do
        params = JSON.parse(r.body.read)
   
        # Check if the OTP is valid
        otp = DB[:otps].where(phone: params['phone'], code: params['code'], status: 'sent')
                        .where { expired_at > Time.now }
                        .first
    
        if otp
          DB[:otps].where(id: otp[:id]).update(status: 'used')
          { message: 'OTP is valid' }.to_json
        else
          r.response.status = 404
          { message: 'Invalid OTP or OTP is invalid or expired' }.to_json
        end
      end
    end
  end
end
