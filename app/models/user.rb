# frozen_string_literal: true
class User < ActiveRecord::Base
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  enum role: { member: 1, journalist: 5 }

  has_many :articles
  validates_presence_of :role, :first_name, :last_name
end
