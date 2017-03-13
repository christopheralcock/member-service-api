class MemberQueryObject
  extend QueryObject

  def self.all
    'PREFIX parl: <http://id.ukpds.org/schema/>
     CONSTRUCT {
         ?houseSeat
          a parl:HouseSeat ;
          parl:houseSeatHasConstituencyGroup ?constituencyGroup .
        ?person
          a parl:Person ;
          parl:personGivenName ?givenName ;
          parl:personFamilyName ?familyName ;
          parl:memberHasIncumbency ?incumbency ;
          parl:partyMemberHasPartyMembership ?partyMembership .
        ?seatIncumbency
          a parl:SeatIncumbency ;
          parl:seatIncumbencyHasHouseSeat ?houseSeat ;
          parl:incumbencyEndDate ?seatIncumbencyEndDate .
    	  ?houseIncumbency
          a parl:HouseIncumbency ;
          parl:incumbencyEndDate ?houseIncumbencyEndDate .
        ?constituencyGroup
          a parl:ConstituencyGroup ;
          parl:constituencyGroupName ?constituencyName .
        ?partyMembership
          a parl:PartyMembership ;
          parl:partyMembershipHasParty ?party .
        ?party
          a parl:Party ;
          parl:partyName ?partyName .
      }
      WHERE {
    	  ?person a parl:Person ;
                parl:memberHasIncumbency ?incumbency .
        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }

         { ?incumbency a parl:HouseIncumbency .
            BIND(?incumbency AS ?houseIncumbency)
            OPTIONAL { ?houseIncumbency parl:incumbencyEndDate ?houseIncumbencyEndDate . }
   		    }
         UNION {
          ?incumbency a parl:SeatIncumbency .
          BIND(?incumbency AS ?seatIncumbency)
          ?seatIncumbency parl:seatIncumbencyHasHouseSeat ?houseSeat .
          OPTIONAL { ?seatIncumbency parl:incumbencyEndDate ?seatIncumbencyEndDate . }
    		  OPTIONAL { ?houseSeat parl:houseSeatHasConstituencyGroup ?constituencyGroup .
       		?constituencyGroup parl:constituencyGroupName ?constituencyName . }
   		  }

        OPTIONAL {
    	    ?person parl:partyMemberHasPartyMembership ?partyMembership .
          FILTER NOT EXISTS { ?partyMembership a parl:PastPartyMembership . }
          ?partyMembership parl:partyMembershipHasParty ?party .
          ?party parl:partyName ?partyName .
        }
      }'
  end

  def self.all_by_letter(letter)
    "PREFIX parl: <http://id.ukpds.org/schema/>
     CONSTRUCT {
         ?houseSeat
         a parl:HouseSeat ;
         parl:houseSeatHasHouse ?house ;
         parl:houseSeatHasConstituencyGroup ?constituencyGroup .
        ?person
         a parl:Person ;
         parl:personGivenName ?givenName ;
         parl:personFamilyName ?familyName ;
         parl:memberHasIncumbency ?incumbency ;
         parl:partyMemberHasPartyMembership ?partyMembership .
        ?seatIncumbency
         a parl:SeatIncumbency ;
         parl:seatIncumbencyHasHouseSeat ?houseSeat ;
         parl:incumbencyStartDate ?seatIncumbencyStartDate ;
         parl:incumbencyEndDate ?seatIncumbencyEndDate .
    	  ?houseIncumbency
         a parl:HouseIncumbency ;
         parl:houseIncumbencyHasHouse ?house ;
         parl:incumbencyStartDate ?houseIncumbencyStartDate ;
         parl:incumbencyEndDate ?houseIncumbencyEndDate .
        ?house
         a parl:House ;
         parl:houseName ?houseName .
        ?constituencyGroup
        a parl:ConstituencyGroup;
        parl:constituencyGroupName ?constituencyName .
        ?partyMembership
        a parl:PartyMembership ;
        parl:partyMembershipHasParty ?party ;
        parl:partyMembershipStartDate ?partyMembershipStartDate ;
        parl:partyMembershipEndDate ?partyMembershipEndDate .
        ?party
        a parl:Party ;
        parl:partyName ?partyName .
      }
      WHERE {
    	  ?person a parl:Person ;
                parl:memberHasIncumbency ?incumbency .
        OPTIONAL { ?person parl:personGivenName ?givenName . }
        OPTIONAL { ?person parl:personFamilyName ?familyName . }
         { ?incumbency a parl:HouseIncumbency .
            BIND(?incumbency AS ?houseIncumbency)
            ?houseIncumbency parl:houseIncumbencyHasHouse ?house .
            ?house parl:houseName ?houseName .
            ?houseIncumbency parl:incumbencyStartDate ?houseIncumbencyStartDate .
            OPTIONAL { ?houseIncumbency parl:incumbencyEndDate ?houseIncumbencyEndDate . }
   		    }
         UNION {
          ?incumbency a parl:SeatIncumbency .
          BIND(?incumbency AS ?seatIncumbency)
          ?seatIncumbency parl:seatIncumbencyHasHouseSeat ?houseSeat .
          ?seatIncumbency parl:incumbencyStartDate ?seatIncumbencyStartDate .
          OPTIONAL { ?seatIncumbency parl:incumbencyEndDate ?seatIncumbencyEndDate . }
       	  ?houseSeat parl:houseSeatHasHouse ?house .
          ?house parl:houseName ?houseName .
    		  OPTIONAL { ?houseSeat parl:houseSeatHasConstituencyGroup ?constituencyGroup .
       		?constituencyGroup parl:constituencyGroupName ?constituencyName . }
   		  }

    	  ?person parl:partyMemberHasPartyMembership ?partyMembership .
         ?partyMembership parl:partyMembershipHasParty ?party .
         ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
         OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
         ?party parl:partyName ?partyName .

    	   FILTER regex(str(?familyName), \"^#{letter}\", 'i') .
      }"
  end

  def self.a_z_letters
    'PREFIX parl: <http://id.ukpds.org/schema/>
     CONSTRUCT {
         _:x parl:value ?firstLetter .
      }
      WHERE {
        SELECT DISTINCT ?firstLetter WHERE {
	        ?Incumbency a parl:Incumbency ;
                        parl:incumbencyHasMember ?person .
          ?person parl:personFamilyName ?familyName .

          BIND(ucase(SUBSTR(?familyName, 1, 1)) as ?firstLetter)
        }
      }'
  end

  def self.all_current
    'PREFIX parl: <http://id.ukpds.org/schema/>
     CONSTRUCT {
         ?houseSeat
         a parl:HouseSeat ;
         parl:houseSeatHasHouse ?house ;
         parl:houseSeatHasConstituencyGroup ?constituencyGroup .
        ?person
         a parl:Person ;
         parl:personGivenName ?givenName ;
         parl:personFamilyName ?familyName ;
         parl:memberHasIncumbency ?incumbency ;
         parl:partyMemberHasPartyMembership ?partyMembership .
        ?seatIncumbency
         a parl:SeatIncumbency ;
         parl:seatIncumbencyHasHouseSeat ?houseSeat ;
         parl:incumbencyStartDate ?seatIncumbencyStartDate ;
         parl:incumbencyEndDate ?seatIncumbencyEndDate .
    	?houseIncumbency
         a parl:HouseIncumbency ;
         parl:houseIncumbencyHasHouse ?house ;
         parl:incumbencyStartDate ?houseIncumbencyStartDate ;
         parl:incumbencyEndDate ?houseIncumbencyEndDate .
        ?house
         a parl:House ;
         parl:houseName ?houseName .
        ?constituencyGroup
        a parl:ConstituencyGroup;
        parl:constituencyGroupName ?constituencyName .
            ?partyMembership
        a parl:PartyMembership ;
        parl:partyMembershipHasParty ?party ;
        parl:partyMembershipStartDate ?partyMembershipStartDate ;
        parl:partyMembershipEndDate ?partyMembershipEndDate .
        ?party
        a parl:Party ;
        parl:partyName ?partyName .
      }
      WHERE {
    	?person a parl:Person ;
          parl:memberHasIncumbency ?incumbency .
          OPTIONAL { ?person parl:personGivenName ?givenName . }
          OPTIONAL { ?person parl:personFamilyName ?familyName . }
           { ?incumbency a parl:HouseIncumbency .
              BIND(?incumbency AS ?houseIncumbency)
              ?houseIncumbency parl:houseIncumbencyHasHouse ?house .
              ?house parl:houseName ?houseName .
              ?houseIncumbency parl:incumbencyStartDate ?houseIncumbencyStartDate .
              OPTIONAL { ?houseIncumbency parl:incumbencyEndDate ?houseIncumbencyEndDate . }
   		      }
           UNION {
            ?incumbency a parl:SeatIncumbency .
            BIND(?incumbency AS ?seatIncumbency)
            ?seatIncumbency parl:seatIncumbencyHasHouseSeat ?houseSeat .
            ?seatIncumbency parl:incumbencyStartDate ?seatIncumbencyStartDate .
            OPTIONAL { ?seatIncumbency parl:incumbencyEndDate ?seatIncumbencyEndDate . }
        		?houseSeat parl:houseSeatHasHouse ?house .
            ?house parl:houseName ?houseName .
    				OPTIONAL {
              ?houseSeat parl:houseSeatHasConstituencyGroup ?constituencyGroup .
        			?constituencyGroup parl:constituencyGroupName ?constituencyName .
             }
   				}
    	    ?person parl:partyMemberHasPartyMembership ?partyMembership .
         ?partyMembership parl:partyMembershipHasParty ?party .
         ?party parl:partyName ?partyName .
         ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
         OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
         FILTER NOT EXISTS {?incumbency a parl:PastIncumbency}
      }'
  end

  def self.all_current_by_letter(letter)
    "PREFIX parl: <http://id.ukpds.org/schema/>
     CONSTRUCT {
         ?houseSeat
         a parl:HouseSeat ;
         parl:houseSeatHasHouse ?house ;
         parl:houseSeatHasConstituencyGroup ?constituencyGroup .
        ?person
         a parl:Person ;
         parl:personGivenName ?givenName ;
         parl:personFamilyName ?familyName ;
         parl:memberHasIncumbency ?incumbency ;
         parl:partyMemberHasPartyMembership ?partyMembership .
        ?seatIncumbency
         a parl:SeatIncumbency ;
         parl:seatIncumbencyHasHouseSeat ?houseSeat ;
         parl:incumbencyStartDate ?seatIncumbencyStartDate ;
         parl:incumbencyEndDate ?seatIncumbencyEndDate .
    	?houseIncumbency
         a parl:HouseIncumbency ;
         parl:houseIncumbencyHasHouse ?house ;
         parl:incumbencyStartDate ?houseIncumbencyStartDate ;
         parl:incumbencyEndDate ?houseIncumbencyEndDate .
        ?house
         a parl:House ;
         parl:houseName ?houseName .
        ?constituencyGroup
        a parl:ConstituencyGroup;
        parl:constituencyGroupName ?constituencyName .
            ?partyMembership
        a parl:PartyMembership ;
        parl:partyMembershipHasParty ?party ;
        parl:partyMembershipStartDate ?partyMembershipStartDate ;
        parl:partyMembershipEndDate ?partyMembershipEndDate .
        ?party
        a parl:Party ;
        parl:partyName ?partyName .
      }
      WHERE {
    	?person a parl:Person ;
          parl:memberHasIncumbency ?incumbency .
          OPTIONAL { ?person parl:personGivenName ?givenName . }
          OPTIONAL { ?person parl:personFamilyName ?familyName . }
           { ?incumbency a parl:HouseIncumbency .
              BIND(?incumbency AS ?houseIncumbency)
              ?houseIncumbency parl:houseIncumbencyHasHouse ?house .
              ?house parl:houseName ?houseName .
              ?houseIncumbency parl:incumbencyStartDate ?houseIncumbencyStartDate .
              OPTIONAL { ?houseIncumbency parl:incumbencyEndDate ?houseIncumbencyEndDate . }
   		   }
           UNION {
            ?incumbency a parl:SeatIncumbency .
            BIND(?incumbency AS ?seatIncumbency)
            ?seatIncumbency parl:seatIncumbencyHasHouseSeat ?houseSeat .
            ?seatIncumbency parl:incumbencyStartDate ?seatIncumbencyStartDate .
            OPTIONAL { ?seatIncumbency parl:incumbencyEndDate ?seatIncumbencyEndDate . }
        		?houseSeat parl:houseSeatHasHouse ?house .
            ?house parl:houseName ?houseName .
    				OPTIONAL {
              ?houseSeat parl:houseSeatHasConstituencyGroup ?constituencyGroup .
        			?constituencyGroup parl:constituencyGroupName ?constituencyName .
            }
   				}
    	    ?person parl:partyMemberHasPartyMembership ?partyMembership .
         ?partyMembership parl:partyMembershipHasParty ?party .
         ?party parl:partyName ?partyName .
         ?partyMembership parl:partyMembershipStartDate ?partyMembershipStartDate .
         OPTIONAL { ?partyMembership parl:partyMembershipEndDate ?partyMembershipEndDate . }
         FILTER NOT EXISTS {?incumbency a parl:PastIncumbency}
         FILTER regex(str(?familyName), \"^#{letter}\", 'i') .
       }"
  end

  def self.a_z_letters_current
    'PREFIX parl: <http://id.ukpds.org/schema/>
     CONSTRUCT {
         _:x parl:value ?firstLetter .
      }
      WHERE {
        SELECT DISTINCT ?firstLetter WHERE {
	        ?incumbency a parl:Incumbency ;
          FILTER NOT EXISTS { ?incumbency a parl:PastIncumbency .	}
          ?incumbency parl:incumbencyHasMember ?person .
          ?person parl:personFamilyName ?familyName .
          BIND(ucase(SUBSTR(?familyName, 1, 1)) as ?firstLetter)
        }
      }'
  end
end