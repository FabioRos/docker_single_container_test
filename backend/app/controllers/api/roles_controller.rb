class API::RolesController < ApiController
  before_action :authenticate_user!

  def index

    #TODO Refactor

    @roles_all = Role.all
    @roles = []
    @roles_all.each do |role|
      permissions =  role.permissions.collect{ |p| p.name }
      role = role.attributes.merge({users_count: User.where(role_id: role.id).count.to_s, permissions: permissions})
      @roles << role
    end

    render json: @roles
  end

  def show
    @roles = Role.find(params[:id])
    render :show
  end

  def create
    @role = Role.create(role_params)
    # Save role
    if @role.save
      render :show
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  def update
    @role = Role.find(params[:id])
    @role.assign_attributes role_params

    if @role.save
      render :show
    else
      render json: @role.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @role = Role.find(params[:id])
    if User.where(role_id: params[:id]).count == 0
      @role.destroy!
      render :show
    else
      render json: {error: 'There are users with this role'}, status: :unprocessable_entity
    end
  end

  private

  def role_params
    params.require(:role).permit(:name, :permission_ids=>[])
  end

end
