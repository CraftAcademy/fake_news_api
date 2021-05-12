# frozen_string_literal: true

class User < ActiveRecord::Base
  extend  Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum role: {visitor: 1, journalist: 2} 

end
