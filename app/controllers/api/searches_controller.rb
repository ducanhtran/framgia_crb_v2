class Api::SearchesController < ApplicationController
  include Authenticable unless :is_desktop_client?
  before_action :authenticate_with_token! unless :is_desktop_client?

  def index
    if params[:name].present?
      if params[:term].present?
        @places = Place.search_name(params[:term], current_user.id)
        render json: @places.order_by_name
          .map{|place| {name: place.name, place_id: place.id}}
      end
    elsif params[:term].present?
      @users = User.search(params[:term]).order_by_email
      render json: @users.map{|user| {email: user.email, user_id: user.id}}
    end
  end
end
