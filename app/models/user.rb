# frozen_string_literal: true

class User < ActiveRecord::Base
  extend  Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum role: {member: 1, journalist: 5, }
  validates_presence_of :first_name, :last_name, :role
  
  has_many :articles

end
