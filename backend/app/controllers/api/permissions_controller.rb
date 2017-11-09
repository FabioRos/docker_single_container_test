class API::PermissionsController < ApiController
  before_action :authenticate_user!

  def index
    render json: Permission.all
  end
end