class API::UsersController < ApiController
  before_action :authenticate_user!
  before_action :required_users_permission, only: [:index, :destroy, :create]
  after_action only: [:index] { set_pagination_headers(:users, params) }

  def create
    @user = User.create(user_params)

    # Create and set random password
    random_password = @user.set_random_password
    # Save user
    if @user.save
      # Notify email
      @user.notify_new_account(random_password) #unless @user.admin?
      render :show
    else
      puts @user.errors
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update

    if params[:id] == current_user.id.to_s
      @user = current_user #self
    elsif has_user_permission
      @user = User.find(params[:id]) #user
      if @user.nil? #user not found
        render json: '', status: :not_found and return
      end
    else
      render json: '', status: :unauthorized and return
    end

    #email has changed
    if params[:user][:email] &&
       params[:user][:email] != @user.email &&
       !@user.first_password_set
      # Change and set random password
      random_password = @user.set_random_password
      email_changed = true
    end

    @user.assign_attributes user_params

    #first_password_set flag
    unless email_changed
      @user.set_flag_on_first_login
    end

    if @user.save

      #email has changed
      if email_changed
        @user.notify_new_account(random_password)
      end

      render :show
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def index

    # Filters
    if params[:q]
      @users = User.ransack(params[:q]).result.select(User.attribute_names - Array.wrap('tokens')).distinct
    else
      @users = User.all
    end

    # Order
    if params[:order]
      @users = @users.order(params[:order])
    end

    # Pagination
    if params[:page]
      @users = @users.page(params[:page]).per(params[:per_page])
    end

    render :index
  end

  def show
    @user = User.find params[:id]
    if stale?(@user)
      render :show
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    render :show
  end

  private

  def has_user_permission
    current_user.role.permissions.pluck(:name).include? 'users'
  end

  def required_users_permission
    unless has_user_permission
      render json: '', status: :unauthorized
    end
  end

  def user_params
    if has_user_permission
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :enabled, :role_id)
    else
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end
  end

end
