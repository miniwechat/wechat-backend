class PhotoController < ApplicationController

  def index
    photo = params[:formData]
    p photo
    render json: {:status => 'success'}
  end

  def upload
    # photo = params[:formData]
    # p photo
    # render json: {:status => 'success'}
    if request.post?
      p 'test'
    end
  end
end
