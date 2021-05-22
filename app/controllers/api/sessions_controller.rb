class Api::SessionsController < DeviseTokenAuth::SessionsController
  def create
    field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first
    q_value = get_case_insensitive_field_from_resource_params(field)
    @resource = find_resource(field, q_value)
    if (@resource&.member? || @resource&.subscriber?) && params[:source] == 'admin-system'
      render_create_error_bad_credentials
    else
      super
    end
  end
end
