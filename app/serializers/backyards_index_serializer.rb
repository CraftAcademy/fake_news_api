class BackyardsIndexSerializer < ActiveModel::Serializer
  attributes :id, :title, :theme, :date, :written_by, :location, :status

  def date
    object.updated_at.strftime('%F, %H:%M')
  end

  def written_by
    "#{object.user.first_name} #{object.user.last_name}"
  end

  def status
    object.status.capitalize
  end
end
