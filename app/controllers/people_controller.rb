require 'net/http'
require 'uri'

class PeopleController < ApplicationController
  def index
    query = PersonQueryObject.all
    response_streamer(query)
  end

  def lookup
    source = params['source']
    id = params['id']
    query = PersonQueryObject.lookup(source, id)
    response_streamer(query)
  end

  def a_z_letters
    query = PersonQueryObject.a_z_letters
    response_streamer(query)
  end

  def show
    id = params[:person]
    query = PersonQueryObject.find(id)
    response_streamer(query)
  end

  def constituencies
    person_id = params[:person_id]
    query = PersonQueryObject.constituencies(person_id)
    response_streamer(query)
  end

  def current_constituency
    person_id = params[:person_id]
    query = PersonQueryObject.current_constituency(person_id)
    response_streamer(query)
  end

  def parties
    person_id = params[:person_id]
    query = PersonQueryObject.parties(person_id)
    response_streamer(query)
  end

  def current_party
    person_id = params[:person_id]
    query = PersonQueryObject.current_party(person_id)
    response_streamer(query)
  end

  def contact_points
    person_id = params[:person_id]
    query = PersonQueryObject.contact_points(person_id)
    response_streamer(query)
  end

  def houses
    person_id = params[:person_id]
    query = PersonQueryObject.houses(person_id)
    response_streamer(query)
  end

  def current_house
    person_id = params[:person_id]
    query = PersonQueryObject.current_house(person_id)
    response_streamer(query)
  end

  def letters
    letter = params[:letter]
    query = PersonQueryObject.all_by_letter(letter)
    response_streamer(query)
  end

  def lookup_by_letters
    letters = params[:letters]
    query = PersonQueryObject.lookup_by_letters(letters)
    response_streamer(query)
  end
end
