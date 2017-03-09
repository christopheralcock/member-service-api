Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # this is a placeholder that doesn't need implementing
  get 'index', to: 'application#index', as: :index


  # done
  get '/people/members', to: 'members#index'
  # done
  match '/people/:person', to: 'people#show', person: /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/, via: [:get]
  # done
  get '/people/:letter', to: 'people#letters', letter: /[A-Za-z]/, via: [:get]
  # done
  get '/people/lookup', to: 'people#lookup'
  # done
  get '/people/a_z_letters', to: 'people#a_z_letters'
  # done
  get '/people/:letters', to: 'people#lookup_by_letters'

  # done
  get '/people/members/current', to: 'members#current'
  # done
  match '/people/members/:letter', to: 'members#letters', letter: /[A-Za-z]/, via: [:get]
  # done
  get '/people/members/a_z_letters', to: 'members#a_z_letters'
  # done
  match '/people/members/current/:letter', to: 'members#current_letters', letter: /[A-Za-z]/, via: [:get]
  # done
  get '/people/members/current/a_z_letters', to: 'members#a_z_letters_current'

  # done
  match '/constituencies/:constituency', to: 'constituencies#show', constituency: /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/, via: [:get]
  # done
  match '/constituencies/:letter', to: 'constituencies#letters', letter: /[A-Za-z]/, via: [:get]
  # done
  get '/constituencies/a_z_letters', to: 'constituencies#a_z_letters'
  # done
  get '/constituencies/current', to: 'constituencies#current'
  # done
  get '/constituencies/lookup', to: 'constituencies#lookup'
  # done
  get '/constituencies/:letters', to: 'constituencies#lookup_by_letters'
  # done
  match '/constituencies/current/:letter', to: 'constituencies#current_letters', letter: /[A-Za-z]/, via: [:get]
  # done
  get '/constituencies/current/a_z_letters', to: 'constituencies#a_z_letters_current'

  # done
  match '/parties/:party', to: 'parties#show', party: /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/, via: [:get]
  # done
  get '/parties/:letter', to: 'parties#letters', letter: /[A-Za-z]/, via: [:get]
  # done
  get '/parties/current', to: 'parties#current'
  # done
  get '/parties/lookup', to: 'parties#lookup'
  # done 
  get '/parties/a_z_letters', to: 'parties#a_z_letters_all'
  # done
  get '/parties/current/a_z_letters', to: 'parties#a_z_letters_current'
  # done
  get '/parties/:letters', to: 'parties#lookup_by_letters'

  # done
  match '/houses/:house', to: 'houses#show', house: /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/, via: [:get]
  # done
  get '/houses/lookup', to: 'houses#lookup'
  # done 
  get '/houses/:letters', to: 'houses#lookup_by_letters'

  resources :people, only: [:index] do
    # done
    get '/constituencies', to: 'people#constituencies'
    # working on it 
    get '/constituencies/current', to: 'people#current_constituency'
    get '/parties', to: 'people#parties'
    get '/parties/current', to: 'people#current_party'
    get '/contact_points',to: 'people#contact_points'
    get '/houses',to: 'people#houses'
    get '/houses/current', to: 'people#current_house'
    get '/sittings', to: 'people#sittings'
  end

  resources :contact_points, only: [:index, :show]

  resources :parties, only: [:index] do
    get '/members', to: 'parties#members'
    get '/members/current', to: 'parties#current_members'
    match '/members/:letter', to: 'parties#members_letters', letter: /[A-Za-z]/, via: [:get]
    get '/members/a_z_letters', to: 'parties#a_z_letters_members'
    match '/members/current/:letter', to: 'parties#current_members_letters', letter: /[A-Za-z]/, via: [:get]
    get '/members/current/a_z_letters', to: 'parties#a_z_letters_members_current'
  end

  resources :constituencies, only: [:index] do
    get '/members', to: 'constituencies#members'
    get '/members/current', to: 'constituencies#current_member'
    get '/contact_point', to: 'constituencies#contact_point'
  end

  resources :houses, only: [:index] do
    get '/members', to: 'houses#members'
    get '/members/current', to: 'houses#current_members'
    get '/parties', to: 'houses#parties'
    get '/parties/current', to: 'houses#current_parties'
    get '/parties/:party_id', to: 'houses#party'
    match '/members/:letter', to: 'houses#members_letters', letter: /[A-Za-z]/, via: [:get]
    get '/members/a_z_letters', to: 'houses#a_z_letters_members'
    match '/members/current/:letter', to: 'houses#current_members_letters', letter: /[A-Za-z]/, via: [:get]
    get '/members/current/a_z_letters', to: 'houses#a_z_letters_members'
    get '/parties/:party_id/members', to: 'houses#party_members'
    match '/parties/:party_id/members/:letter', to: 'houses#party_members_letters', letter: /[A-Za-z]/, via: [:get]
    get 'parties/:party_id/members/a_z_letters', to: 'houses#a_z_letters_party_members'
    get '/parties/:party_id/members/current', to: 'houses#current_party_members'
    match '/parties/:party_id/members/current/:letter', to: 'houses#current_party_members_letters', letter: /[A-Za-z]/, via: [:get]
    get 'parties/:party_id/members/current/a_z_letters', to: 'houses#a_z_letters_party_members_current'
  end
end
