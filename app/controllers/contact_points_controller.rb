class ContactPointsController < ApplicationController
  def index
    query = ContactPointQueryObject.all
    response_streamer(query)
  end

  def show
    id = params[:id]
    query = ContactPointQueryObject.find(id)
    response_streamer(query)
  end


end
