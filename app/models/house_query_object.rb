class HouseQueryObject
  extend QueryObject

  def self.all
    self.uri_builder('
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house
            a parl:House ;
        	  parl:houseName ?houseName .
      }
      WHERE {
          ?house
             a parl:House ;
    			   parl:houseName ?houseName .
      }'
    )
  end

  def self.lookup(source, id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
        ?house
           a parl:House .
      }
      WHERE {
        BIND(\"#{id}\" AS ?id)
        BIND(parl:#{source} AS ?source)

	      ?house a parl:House .
        ?house ?source ?id .
      }")
  end

  def self.find(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house
            a parl:House ;
            parl:houseName ?houseName .
      }
      WHERE {
          BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

          ?house
            a parl:House ;
            parl:houseName ?houseName .
      }")
  end

  def self.members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
        	  a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
            parl:memberHasIncumbency ?incumbency .
    	  ?house
        	  a parl:House ;
        	  parl:houseName ?houseName .
    	  ?incumbency
            a parl:Incumbency ;
        	  parl:incumbencyEndDate ?incumbencyEndDate ;
        	  parl:incumbencyStartDate ?incumbencyStartDate .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

        ?house parl:houseName ?houseName .
    	  ?person a parl:Member;
       			    parl:personFamilyName ?familyName .
    	  ?incumbency parl:incumbencyHasMember ?person ;
       				      parl:incumbencyStartDate ?incumbencyStartDate .

        OPTIONAL { ?incumbency parl:incumbencyEndDate ?incumbencyEndDate . }
        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }

    	  {
    	      ?incumbency parl:houseIncumbencyHasHouse ?house .
    	  }
    	  UNION {
          	?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
          	?seat parl:houseSeatHasHouse ?house .
    	  }
      }
    ")
  end

  def self.members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
        	  a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
            parl:memberHasIncumbency ?incumbency .
    	  ?house
        	  a parl:House ;
        	  parl:houseName ?houseName .
    	  ?incumbency
            a parl:Incumbency ;
        	  parl:incumbencyEndDate ?incumbencyEndDate ;
        	  parl:incumbencyStartDate ?incumbencyStartDate .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

        ?house parl:houseName ?houseName .
    	  ?person a parl:Member;
       			    parl:personFamilyName ?familyName .
    	  ?incumbency parl:incumbencyHasMember ?person ;
       				      parl:incumbencyStartDate ?incumbencyStartDate .

        OPTIONAL { ?incumbency parl:incumbencyEndDate ?incumbencyEndDate . }
        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }

    	  {
    	      ?incumbency parl:houseIncumbencyHasHouse ?house .
    	  }
    	  UNION {
          	?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
          	?seat parl:houseSeatHasHouse ?house .
    	  }

        FILTER regex(str(?familyName), \"^#{letter}\", 'i') .
      }
    ")
  end

  def self.a_z_letters_members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         _:x parl:value ?firstLetter .
      }
      WHERE {
        SELECT DISTINCT ?firstLetter WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

	      ?house parl:houseName ?houseName .
    	  ?person a parl:Member;
         			  parl:personFamilyName ?familyName .
    	  ?incumbency parl:incumbencyHasMember ?person .

    	  {
    	      ?incumbency parl:houseIncumbencyHasHouse ?house .
    	  }

    	  UNION {
          	?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
          	?seat parl:houseSeatHasHouse ?house .
    	  }

        BIND(ucase(SUBSTR(?familyName, 1, 1)) as ?firstLetter)
        }
      }

    ")
  end

  def self.current_members(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
        	  a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
        	  parl:partyMemberHasPartyMembership ?partyMembership ;
            parl:memberHasIncumbency ?incumbency .
    	  ?house
        	  a parl:House ;
        	  parl:houseName ?houseName .
    	  ?seatIncumbency
            a parl:SeatIncumbency ;
        	  parl:incumbencyStartDate ?incumbencyStartDate ;
            parl:seatIncumbencyHasHouseSeat ?seat .
    	  ?houseIncumbency
            a parl:HouseIncumbency ;
        	  parl:incumbencyStartDate ?incumbencyStartDate ;
            parl:houseIncumbencyHasHouse ?house .
        ?seat
            a parl:HouseSeat ;
            parl:houseSeatHasConstituencyGroup ?constituency .
    	  ?partyMembership
        	  a parl:PartyMembership ;
        	  parl:partyMembershipHasParty ?party .
    	  ?party
        	  a parl:Party ;
        	  parl:partyName ?partyName .
        ?constituency
        	a parl:ConstituencyGroup ;
        	parl:constituencyGroupName ?constituencyName .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

        ?house parl:houseName ?houseName .
    	  ?person a parl:Member;
       			  parl:personFamilyName ?familyName .
    	  ?person parl:partyMemberHasPartyMembership ?partyMembership .
    	  FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
    	  ?partyMembership parl:partyMembershipHasParty ?party .
    	  ?party parl:partyName ?partyName .
    	  ?incumbency parl:incumbencyHasMember ?person ;
       			       parl:incumbencyStartDate ?incumbencyStartDate .
    	  FILTER NOT EXISTS { ?incumbency a parl:PastIncumbency . }

    	  {
    	      ?incumbency parl:houseIncumbencyHasHouse ?house .
            BIND(?incumbency AS ?houseIncumbency)
    	  }

    	  UNION {
        	?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
        	?seat parl:houseSeatHasHouse ?house .
        	?seat parl:houseSeatHasConstituencyGroup ?constituency .
        	?constituency parl:constituencyGroupName ?constituencyName .
          BIND(?incumbency AS ?seatIncumbency)
    	  }

        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }
      }
    ")
  end

  def self.current_members_by_letter(id, letter)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?person
        	  a parl:Person ;
            parl:personGivenName ?givenName ;
            parl:personFamilyName ?familyName ;
        	  parl:partyMemberHasPartyMembership ?partyMembership ;
            parl:memberHasIncumbency ?incumbency .
    	  ?house
        	  a parl:House ;
        	  parl:houseName ?houseName .
    	  ?seatIncumbency
            a parl:SeatIncumbency ;
        	  parl:incumbencyStartDate ?incumbencyStartDate ;
            parl:seatIncumbencyHasHouseSeat ?seat .
    	  ?houseIncumbency
            a parl:HouseIncumbency ;
        	  parl:incumbencyStartDate ?incumbencyStartDate ;
            parl:houseIncumbencyHasHouse ?house .
        ?seat
            a parl:HouseSeat ;
            parl:houseSeatHasConstituencyGroup ?constituency .
    	  ?partyMembership
        	  a parl:PartyMembership ;
        	  parl:partyMembershipHasParty ?party .
    	  ?party
        	  a parl:Party ;
        	  parl:partyName ?partyName .
        ?constituency
        	a parl:ConstituencyGroup ;
        	parl:constituencyGroupName ?constituencyName .
      }
      WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

        ?house parl:houseName ?houseName .
    	  ?person a parl:Member;
       			  parl:personFamilyName ?familyName .
    	  ?person parl:partyMemberHasPartyMembership ?partyMembership .
    	  FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
    	  ?partyMembership parl:partyMembershipHasParty ?party .
    	  ?party parl:partyName ?partyName .
    	  ?incumbency parl:incumbencyHasMember ?person ;
       			       parl:incumbencyStartDate ?incumbencyStartDate .
    	  FILTER NOT EXISTS { ?incumbency a parl:PastIncumbency . }

    	  {
    	      ?incumbency parl:houseIncumbencyHasHouse ?house .
            BIND(?incumbency AS ?houseIncumbency)
    	  }

    	  UNION {
        	?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
        	?seat parl:houseSeatHasHouse ?house .
        	?seat parl:houseSeatHasConstituencyGroup ?constituency .
        	?constituency parl:constituencyGroupName ?constituencyName .
          BIND(?incumbency AS ?seatIncumbency)
    	  }

        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }

        FILTER regex(str(?familyName), \"^#{letter}\", 'i') .
      }
    ")
  end

  def self.a_z_letters_members_current(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         _:x parl:value ?firstLetter .
      }
      WHERE {
        SELECT DISTINCT ?firstLetter WHERE {
          BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

	        ?house parl:houseName ?houseName .
    	    ?person a parl:Member;
       			      parl:personFamilyName ?familyName .
    	    ?incumbency parl:incumbencyHasMember ?person .
    	    FILTER NOT EXISTS { ?incumbency a parl:PastIncumbency . }

    	    {
    	        ?incumbency parl:houseIncumbencyHasHouse ?house .
    	    }

    	    UNION {
            	?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
            	?seat parl:houseSeatHasHouse ?house .
    	    }

          BIND(ucase(SUBSTR(?familyName, 1, 1)) as ?firstLetter)
        }
      }
    ")
  end

  def self.parties(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?house
        	a parl:House ;
        	parl:houseName ?houseName .
        ?party
          a parl:Party ;
          parl:partyName ?partyName .
      }
          WHERE {
        	  BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

            ?house parl:houseName ?houseName .
            ?person a parl:Member .
        	  ?incumbency parl:incumbencyHasMember ?person .
    		    ?person parl:partyMemberHasPartyMembership ?partyMembership .
    		    ?partyMembership parl:partyMembershipHasParty ?party .
    		    ?party parl:partyName ?partyName .

    			  {
    			      ?incumbency parl:houseIncumbencyHasHouse ?house .
    			  }

    		    UNION {
            		?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
            		?seat parl:houseSeatHasHouse ?house .
    		    }
         }
    ")
  end

  def self.current_parties(id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?house
        	a parl:House ;
        	parl:houseName ?houseName .
        ?party
          a parl:Party ;
          parl:partyName ?partyName ;
    	    parl:count ?memberCount .
      }
       WHERE {
        BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?house)

         ?house parl:houseName ?houseName .
         ?person a parl:Member .
         ?incumbency parl:incumbencyHasMember ?person .
         FILTER NOT EXISTS { ?incumbency a parl:PastIncumbency . }
    		 ?person parl:partyMemberHasPartyMembership ?partyMembership .
         FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
    		 ?partyMembership parl:partyMembershipHasParty ?party .
    		 ?party parl:partyName ?partyName .

    		{
    		    ?incumbency parl:houseIncumbencyHasHouse ?house .
    		}

    		UNION {
        		?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
        		?seat parl:houseSeatHasHouse ?house .
    		}
       }
     ")
  end

  def self.party(house_id, party_id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>

      CONSTRUCT {
          ?house
            a parl:House ;
            parl:houseName ?houseName .
          ?party
            a parl:Party ;
            parl:partyName ?partyName .
      }
      WHERE {
          BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)

          ?house parl:houseName ?houseName .

          OPTIONAL {
            BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

    		    ?person a parl:Member .
    		    ?person parl:partyMemberHasPartyMembership ?partyMembership .
    		    ?partyMembership parl:partyMembershipHasParty ?party .
    		    ?party parl:partyName ?partyName .
    		    ?incumbency parl:incumbencyHasMember ?person .

    	      {
    	          ?incumbency parl:houseIncumbencyHasHouse ?house .
    	      }

    	      UNION {
              	?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
              	?seat parl:houseSeatHasHouse ?house .
    	      }
          }
      }
   ")
  end

  def self.party_members(house_id, party_id)
    self.uri_builder("
	    PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
    	?person
        	a parl:Person ;
        	parl:personGivenName ?givenName ;
          parl:personFamilyName ?familyName ;
        	parl:partyMemberHasPartyMembership ?partyMembership ;
        	parl:memberHasIncumbency ?incumbency .
    	?house
        	a parl:House ;
        	parl:houseName ?houseName .
    	?party
        	a parl:Party ;
        	parl:partyName ?partyName .
    	?partyMembership
        	a parl:PartyMembership ;
        	parl:partyMembershipStartDate ?partyMembershipStartDate ;
        	parl:partyMembershipEndDate ?partyMembershipEndDate .
    	?incumbency
        	a parl:Incumbency ;
        	parl:incumbencyStartDate ?incumbencyStartDate ;
        	parl:incumbencyEndDate ?incumbencyEndDate .
      }
      WHERE {
      	BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)

    	  ?house parl:houseName ?houseName .

        OPTIONAL {
          BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

          ?person a parl:Member .
    		  ?person parl:partyMemberHasPartyMembership ?partyMembership .
    		  ?partyMembership parl:partyMembershipHasParty ?party .
    		  ?party parl:partyName ?partyName .
          ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
    	    OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }

    		  ?incumbency parl:incumbencyHasMember ?person ;
                    	parl:incumbencyStartDate ?startDate .
          OPTIONAL { ?incumbency parl:incumbencyEndDate ?incumbencyEndDate . }

          OPTIONAL { ?person parl:personGivenName ?givenName . }
    	    OPTIONAL { ?person parl:personFamilyName ?familyName . }

    			{
    			    ?incumbency parl:houseIncumbencyHasHouse ?house .
    			}

    			UNION {
        			?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
        			?seat parl:houseSeatHasHouse ?house .
    			}
        }
      }
    ")
  end

  def self.party_members_letters(house_id, party_id, letter)
    self.uri_builder("
	    PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
    	?person
        	a parl:Person ;
        	parl:personGivenName ?givenName ;
          parl:personFamilyName ?familyName ;
        	parl:partyMemberHasPartyMembership ?partyMembership ;
        	parl:memberHasIncumbency ?incumbency .
    	?house
        	a parl:House ;
        	parl:houseName ?houseName .
    	?party
        	a parl:Party ;
        	parl:partyName ?partyName .
    	?partyMembership
        	a parl:PartyMembership ;
        	parl:partyMembershipStartDate ?partyMembershipStartDate ;
        	parl:partyMembershipEndDate ?partyMembershipEndDate .
    	?incumbency
        	a parl:Incumbency ;
        	parl:incumbencyStartDate ?incumbencyStartDate ;
        	parl:incumbencyEndDate ?incumbencyEndDate .
      }
      WHERE {
      	BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)

    	  ?house parl:houseName ?houseName .

        OPTIONAL {
          BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

          ?person a parl:Member .
    		  ?person parl:partyMemberHasPartyMembership ?partyMembership .
    		  ?partyMembership parl:partyMembershipHasParty ?party .
    		  ?party parl:partyName ?partyName .
          ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
    	    OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }

    		  ?incumbency parl:incumbencyHasMember ?person ;
                    	parl:incumbencyStartDate ?startDate .
          OPTIONAL { ?incumbency parl:incumbencyEndDate ?incumbencyEndDate . }

          OPTIONAL { ?person parl:personGivenName ?givenName . }
    	    OPTIONAL { ?person parl:personFamilyName ?familyName . }

    			{
    			    ?incumbency parl:houseIncumbencyHasHouse ?house .
    			}

    			UNION {
        			?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
        			?seat parl:houseSeatHasHouse ?house .
    			}
          FILTER regex(str(?familyName), \"^#{letter}\", 'i') .
        }
      }
    ")
  end

  def self.a_z_letters_party_members(house_id, party_id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         _:x parl:value ?firstLetter .
      }
      WHERE {
        SELECT DISTINCT ?firstLetter WHERE {
          BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)
          BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

    	    ?person a parl:Member .
          ?person parl:personFamilyName ?familyName .
    	    ?person parl:partyMemberHasPartyMembership ?partyMembership .
    	    ?partyMembership parl:partyMembershipHasParty ?party .
    	    ?incumbency parl:incumbencyHasMember ?person .

    	    {
    	        ?incumbency parl:houseIncumbencyHasHouse ?house .
    	    }

    	    UNION {
            	?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
            	?seat parl:houseSeatHasHouse ?house .
    	    }

          BIND(ucase(SUBSTR(?familyName, 1, 1)) as ?firstLetter)
        }
      }
    ")
  end

  def self.current_party_members(house_id, party_id)
    self.uri_builder("
	    PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
    	?person
        	a parl:Person ;
        	parl:personGivenName ?givenName ;
          parl:personFamilyName ?familyName ;
        	parl:partyMemberHasPartyMembership ?partyMembership ;
        	parl:memberHasIncumbency ?incumbency .
    	?house
        	a parl:House ;
        	parl:houseName ?houseName .
    	?party
        	a parl:Party ;
        	parl:partyName ?partyName .
    	?partyMembership
        	a parl:PartyMembership ;
        	parl:partyMembershipStartDate ?partyMembershipStartDate .
    	?incumbency
        	a parl:Incumbency ;
        	parl:incumbencyStartDate ?incumbencyStartDate .
      }
      WHERE {
      	BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)

    	  ?house parl:houseName ?houseName .

        OPTIONAL {
          BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

          ?person a parl:Member .
    		  ?person parl:partyMemberHasPartyMembership ?partyMembership .
          FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
    		  ?partyMembership parl:partyMembershipHasParty ?party .
    		  ?party parl:partyName ?partyName .
          ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .

    		  ?incumbency parl:incumbencyHasMember ?person ;
                    	parl:incumbencyStartDate ?startDate .

          FILTER NOT EXISTS { ?incumbency a parl:PastIncumbency . }

          OPTIONAL { ?person parl:personGivenName ?givenName . }
    	    OPTIONAL { ?person parl:personFamilyName ?familyName . }

    			{
    			    ?incumbency parl:houseIncumbencyHasHouse ?house .
    			}

    			UNION {
        			?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
        			?seat parl:houseSeatHasHouse ?house .
    			}
        }
      }
    ")
  end

  def self.current_party_members_letters(house_id, party_id, letter)
    self.uri_builder("
	    PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
    	?person
        	a parl:Person ;
        	parl:personGivenName ?givenName ;
          parl:personFamilyName ?familyName ;
        	parl:partyMemberHasPartyMembership ?partyMembership ;
        	parl:memberHasIncumbency ?incumbency .
    	?house
        	a parl:House ;
        	parl:houseName ?houseName .
    	?party
        	a parl:Party ;
        	parl:partyName ?partyName .
    	?partyMembership
        	a parl:PartyMembership ;
        	parl:partyMembershipStartDate ?partyMembershipStartDate .
    	?incumbency
        	a parl:Incumbency ;
        	parl:incumbencyStartDate ?incumbencyStartDate .
      }
      WHERE {
      	BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)

    	  ?house parl:houseName ?houseName .

        OPTIONAL {
          BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

          ?person a parl:Member .
    		  ?person parl:partyMemberHasPartyMembership ?partyMembership .
          FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
    		  ?partyMembership parl:partyMembershipHasParty ?party .
    		  ?party parl:partyName ?partyName .
          ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .

    		  ?incumbency parl:incumbencyHasMember ?person ;
                    	parl:incumbencyStartDate ?startDate .

          FILTER NOT EXISTS { ?incumbency a parl:PastIncumbency . }

          OPTIONAL { ?person parl:personGivenName ?givenName . }
    	    OPTIONAL { ?person parl:personFamilyName ?familyName . }

    			{
    			    ?incumbency parl:houseIncumbencyHasHouse ?house .
    			}

    			UNION {
        			?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
        			?seat parl:houseSeatHasHouse ?house .
    			}
        }
        FILTER regex(str(?familyName), \"^#{letter}\", 'i') .
      }
    ")
  end

  def self.a_z_letters_party_members_current(house_id, party_id)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
         _:x parl:value ?firstLetter .
      }
      WHERE {
        SELECT DISTINCT ?firstLetter WHERE {
          BIND(<#{DATA_URI_PREFIX}/#{house_id}> AS ?house)
          BIND(<#{DATA_URI_PREFIX}/#{party_id}> AS ?party)

    	    ?person a parl:Member .
          ?person parl:personFamilyName ?familyName .
    	    ?person parl:partyMemberHasPartyMembership ?partyMembership .
          FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
    	    ?partyMembership parl:partyMembershipHasParty ?party .
    	    ?incumbency parl:incumbencyHasMember ?person .
          FILTER NOT EXISTS { ?incumbency a parl:PastIncumbency . }

    	    {
    	        ?incumbency parl:houseIncumbencyHasHouse ?house .
    	    }

    	    UNION {
            	?incumbency parl:seatIncumbencyHasHouseSeat ?seat .
            	?seat parl:houseSeatHasHouse ?house .
    	    }

          BIND(ucase(SUBSTR(?familyName, 1, 1)) as ?firstLetter)
        }
      }
    ")
  end

  def self.lookup_by_letters(letters)
    self.uri_builder("
      PREFIX parl: <http://id.ukpds.org/schema/>
      CONSTRUCT {
        ?house
        	a parl:House ;
         	parl:houseName ?houseName .
      }
      WHERE {
        ?house a parl:House .
        ?house parl:houseName ?houseName .

    	  FILTER(regex(str(?houseName), \"#{letters}\", 'i')) .
      }
    ")
  end
end
