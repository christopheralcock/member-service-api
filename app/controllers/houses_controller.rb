class HousesController < ApplicationController
  def index
    query = HouseQueryObject.all
    response_streamer(query)
  end

  def lookup
    source = params['source']
    id = params['id']
    query = HouseQueryObject.lookup(source, id)
    response_streamer(query)
  end

  def show
    id = params[:house]
    query = HouseQueryObject.find(id)
    response_streamer(query)
  end

  def members
    id = params[:house_id]
    query = HouseQueryObject.members(id)
    response_streamer(query)
  end

  def current_members
    id = params[:house_id]
    query = HouseQueryObject.current_members(id)
    response_streamer(query)
  end

  def parties
    id = params[:house_id]
    query = HouseQueryObject.parties(id)
    response_streamer(query)
  end

  def current_parties
    id = params[:house_id]
    query = HouseQueryObject.current_parties(id)
    response_streamer(query)
  end

  def members_letters
    letter = params[:letter]
    id = params[:house_id]
    query = HouseQueryObject.members_by_letter(id, letter)
    response_streamer(query)
  end

  def a_z_letters_members
    id = params[:house_id]
    query = HouseQueryObject.a_z_letters_members(id)
    response_streamer(query)
  end

  def current_members_letters
    letter = params[:letter]
    id = params[:house_id]
    query = HouseQueryObject.current_members_by_letter(id, letter)
    response_streamer(query)
  end

  def a_z_letters_members_current
    id = params[:house_id]
    query = HouseQueryObject.a_z_letters_members_current(id)
    response_streamer(query)
  end

  def party
    house_id = params[:house_id]
    party_id = params[:party_id]
    query = HouseQueryObject.party(house_id, party_id)
    response_streamer(query)
  end

  def party_members
    house_id = params[:house_id]
    party_id = params[:party_id]
    query = HouseQueryObject.party_members(house_id, party_id)
    response_streamer(query)
  end

  def party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]
    query = HouseQueryObject.party_members_letters(house_id, party_id, letter)
    response_streamer(query)
  end

  def a_z_letters_party_members
    house_id = params[:house_id]
    party_id = params[:party_id]
    query = HouseQueryObject.a_z_letters_party_members(house_id, party_id)
    response_streamer(query)
  end

  def current_party_members
    house_id = params[:house_id]
    party_id = params[:party_id]
    query = HouseQueryObject.current_party_members(house_id, party_id)
    response_streamer(query)
  end

  def current_party_members_letters
    house_id = params[:house_id]
    party_id = params[:party_id]
    letter = params[:letter]
    query = HouseQueryObject.current_party_members_letters(house_id, party_id, letter)
    response_streamer(query)
  end

  def a_z_letters_party_members_current
    house_id = params[:house_id]
    party_id = params[:party_id]
    query = HouseQueryObject.a_z_letters_party_members_current(house_id, party_id)
    response_streamer(query)
  end

  def lookup_by_letters
    letters = params[:letters]
    query = HouseQueryObject.lookup_by_letters(letters)
    response_streamer(query)
  end
end