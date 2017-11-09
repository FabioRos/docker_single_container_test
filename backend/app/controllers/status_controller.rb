class StatusController < ApplicationController
  def status
    head :ok
    # render json: {
    #     message: "Hello world!"
    # }.to_json
  end
end
