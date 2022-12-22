class CamsController < ApplicationController
  def index
    @cams = Cam.all
  end

  def show
    @cam = Cam.find(params[:id])
  end

  def add_favorite
    @cam = Cam.find(params[:id])
    @cam.favorite = if @cam.favorite
                      flash[:notice] = 'Cam removed from favorites'
                      false
                    else
                      flash[:notice] = 'Cam added to favorites'
                      true
                    end
    @cam.save

    redirect_to show_cam_path(@cam)
  end

  def favorites
    @cams = Cam.where(favorite: true)
  end
end
