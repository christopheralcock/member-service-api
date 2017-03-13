class PartiesController < ApplicationController
  def index
    query = PartyQueryObject.all
    response_streamer(query)
  end

  def lookup
    source = params['source']
    id = params['id']
    query = PartyQueryObject.lookup(source, id)
    response_streamer(query)
  end

  def a_z_letters_all
    query = PartyQueryObject.a_z_letters_all
    response_streamer(query)
  end

  def current
    query = PartyQueryObject.all_current
    response_streamer(query)
  end

  def a_z_letters_current
    query = PartyQueryObject.a_z_letters_current
    response_streamer(query)
  end

  def show
    id = params[:party]
    query = PartyQueryObject.find(id)
    response_streamer(query)
  end

  def members
    id = params[:party_id]
    query = PartyQueryObject.members(id)
    response_streamer(query)
  end

  def current_members
    id = params[:party_id]
    query = PartyQueryObject.current_members(id)
    response_streamer(query)
  end

  def letters
    letter = params[:letter]
    query = PartyQueryObject.all_by_letter(letter)
    response_streamer(query)
  end

  def members_letters
    letter = params[:letter]
    id = params[:party_id]
    query = PartyQueryObject.members_by_letter(id, letter)
    response_streamer(query)
  end

  def a_z_letters_members
    id = params[:party_id]
    query = PartyQueryObject.a_z_letters_members(id)
    response_streamer(query)
  end

  def current_members_letters
    letter = params[:letter]
    id = params[:party_id]
    query = PartyQueryObject.current_members_by_letter(id, letter)
    response_streamer(query)
  end

  def a_z_letters_members_current
    id = params[:party_id]
    query = PartyQueryObject.a_z_letters_members_current(id)
    response_streamer(query)
  end

  def lookup_by_letters
    letters = params[:letters]
    query = PartyQueryObject.lookup_by_letters(letters)
    response_streamer(query)
  end
end
