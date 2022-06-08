class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  # def index
  #   items = Item.all
  #   render json: items, include: :user
  # end

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    if item
      render json: item, include: :user, status: :ok
    else
      render json: {error: "no item found"}, status: :not_found
    end
  end

  def create
    item = Item.create(item_params)
    render json: item, include: :user, status: :created
  end


  private

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found_response(exception)
    render json: {error: "#{exception.model}"}, status: :not_found
  end

end
