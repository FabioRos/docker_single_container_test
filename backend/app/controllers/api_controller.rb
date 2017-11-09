class ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session

  before_action :set_locale
  before_action :set_client_info


  private
  def set_locale
     # begin
    #   I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first unless request.env['HTTP_ACCEPT_LANGUAGE'].nil?
    # rescue
    #   logger.error 'Invalid locale. HTTP_ACCEPT_LANGUAGE = ' + request.env['HTTP_ACCEPT_LANGUAGE'].to_s
    # end
    I18n.locale = 'en'
  end

  def set_client_info
    @client_platform = @client_version = nil
    begin
      unless request.headers['Client-Version'].blank?
        @client_platform, @client_version = request.headers['Client-Version'].split('/')
      end
    rescue
      logger.error 'Bad Client-Version header provided by client: ' + request.env['Client-Version']
    end
  end

  def set_pagination_headers(name, options = {})
    results = instance_variable_get("@#{name}")
    headers["X-Pagination-Count"] = results.total_count.to_s rescue options[:total_count].to_s || results.count.to_s
    headers["X-Pagination-Page"]  = options[:page] || 1
    headers["X-Pagination-Limit"] = options[:per_page] if options[:per_page]
  end
  
end
