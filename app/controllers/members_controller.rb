class MembersController < ApplicationController
  def index
    query = MemberQueryObject.all
    response_streamer(query)
  end

  def current
    query = MemberQueryObject.all_current
    response_streamer(query)
  end

  def letters
    letter = params[:letter]
    query = MemberQueryObject.all_by_letter(letter)
    response_streamer(query)
  end

  def a_z_letters
    query = MemberQueryObject.a_z_letters
    response_streamer(query)
  end

  def current_letters
    letter = params[:letter]
    query = MemberQueryObject.all_current_by_letter(letter)
    response_streamer(query)
  end

  def a_z_letters_current
    query = MemberQueryObject.a_z_letters_current
    response_streamer(query)
  end
end