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

  # this method will be used in the same way as the other lookup methods
  # for now this is just here as a placeholder until there is some kind of registry to look up contact points

  def lookup_by_letters
    letters = params[:letters]
    query = ContactPointQueryObject.lookup_by_letters(letters)
    response_streamer(query)
  end
end
