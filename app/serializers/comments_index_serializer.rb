class CommentsIndexSerializer < ActiveModel::Serializer
  attributes :id, :user, :date, :body

  def user
    "#{object.user.first_name} #{object.user.last_name}"
  end

  def date
    object.created_at.strftime('%F')
  end
end
