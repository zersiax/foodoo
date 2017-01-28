class PlacesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :delete]
  def index
    @places = Place.all.page params[:page]

  end

  def new
    @place = Place.new
  end

  def create
    @place = current_user.places.create(place_params)
    if @place.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @place = Place.find(params[:id])
   @comment = Comment.new  
  end

  def edit

    @place = Place.find(params[:id])
    if @place.user != current_user
      return render text:'Not Allowed', status: :forbidden
    end

  end

  def update
    @place = Place.find(params[:id])
    if @place.user != current_user
      return render text: 'Not Allowed', status: :forbidden
    end
    @place.update_attributes(place_params)
    if @place.valid?
      redirec_to root_path
    else
      render :edit, status: :unprocessable_entity
    end

  end

  def destroy
    @places = Place.find(params[:id])
    if @place.user != current_user
      return render text: 'Not Allowed', status: :forbidden
    end
    @place.destroy
    redirect_to root_path

  end

  private

  def place_params
    params.require(:place).permit(:name, :address, :description)
  end
end