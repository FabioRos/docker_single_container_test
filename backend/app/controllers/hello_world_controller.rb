class HelloWorldController < ApplicationController
  def hello
    head :ok
    # render json: {
    #     message: "Hello world!"
    # }.to_json
  end
end
