class MapOverlaysController < ApplicationController
  before_action :check_super_user_role

  def index
    @map_overlays = MapOverlay.all
  end

  # def show
  #   @map_overlay = MapOverlay.find params[:id]
  # end

  def new
    @map_overlay = MapOverlay.new
  end

  def create
    @map_overlay = MapOverlay.new resource_params
    if @map_overlay.save
      flash[:notice] = "Added the new map overlay."
      redirect_to action: :index
    else
      flash[:errors] = "Sorry couldn't do it."
      render action: :new
    end
  end

  def edit
    @map_overlay = MapOverlay.find params[:id]
  end

  def update
    @map_overlay = MapOverlay.find params[:id]
    if @map_overlay.update_attributes resource_params
      flash[:notice] = "Updated the map overlay."
      redirect_to action: :index
    else
      flash[:errors] = "Sorry couldn't do it."
      render action: :edit
    end
  end

  def destroy
    @map_overlay = MapOverlay.find params[:id]
    if @map_overlay.destroy
      flash[:notice] = "Deleted the map overlay."
      redirect_to action: :index
    else
      flash[:errors] = "Sorry couldn't do it."
      redirect_back fallback_location: { action: :index }
    end
  end

  private

  def resource_params
    params.require(:map_overlay).permit!
  end
end