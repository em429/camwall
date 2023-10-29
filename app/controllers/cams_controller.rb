class CamsController < ApplicationController
  def index
    @cams = Cam.all
  end

  def show
    @cam = Cam.find(params[:id])
  end

  def toggle_favorite
    @cam = Cam.find(params[:id])
    @cam.favorite = if @cam.favorite
                      flash[:notice] = 'Cam removed from favorites'
                      false
                    else
                      flash[:notice] = 'Cam marked as favorite'
                      true
                    end
    @cam.save

    redirect_to cam_path(@cam)
  end

  def favorites
    @cams = Cam.favorites
  end
end
