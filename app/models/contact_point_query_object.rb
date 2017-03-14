class ContactPointQueryObject
  extend QueryObject

  def self.all
    'PREFIX parl: <http://id.ukpds.org/schema/>
     CONSTRUCT {
           ?contactPoint
               a parl:ContactPoint ;
               parl:email ?email ;
               parl:phoneNumber ?phoneNumber ;
               parl:faxNumber ?faxNumber ;
               parl:contactPointHasPostalAddress ?postalAddress .
           ?postalAddress a parl:PostalAddress ;
                       parl:postCode ?postCode ;
               			   parl:addressLine1 ?addressLine1 ;
               			   parl:addressLine2 ?addressLine2 ;
               			   parl:addressLine3 ?addressLine3 ;
               			   parl:addressLine4 ?addressLine4 ;
               			   parl:addressLine5 ?addressLine5 .
        }
        WHERE {
        	?contactPoint a parl:ContactPoint ;
        	OPTIONAL{ ?contactPoint parl:email ?email . }
        	OPTIONAL{ ?contactPoint parl:phoneNumber ?phoneNumber . }
        	OPTIONAL{ ?contactPoint parl:faxNumber ?faxNumber . }
        	OPTIONAL{
                ?contactPoint parl:contactPointHasPostalAddress ?postalAddress .
                OPTIONAL{ ?postalAddress parl:postCode ?postCode . }
               	OPTIONAL{ ?postalAddress parl:addressLine1 ?addressLine1 . }
               	OPTIONAL{ ?postalAddress parl:addressLine2 ?addressLine2 . }
               	OPTIONAL{ ?postalAddress parl:addressLine3 ?addressLine3 . }
               	OPTIONAL{ ?postalAddress parl:addressLine4 ?addressLine4 . }
               	OPTIONAL{ ?postalAddress parl:addressLine5 ?addressLine5 . }
          	}
      }'
  end

  def self.find(id)
    "PREFIX parl: <http://id.ukpds.org/schema/>
     CONSTRUCT {
           ?contactPoint
               a parl:ContactPoint ;
               parl:email ?email ;
               parl:phoneNumber ?phoneNumber ;
               parl:faxNumber ?faxNumber ;
               parl:contactPointHasPostalAddress ?postalAddress ;
    		       parl:contactPointHasIncumbency ?incumbency .
    		?incumbency
        		a parl:Incumbency ;
        		parl:incumbencyHasMember ?person .
            ?postalAddress
                a parl:PostalAddress ;
                parl:postCode ?postCode ;
                parl:addressLine1 ?addressLine1 ;
                parl:addressLine2 ?addressLine2 ;
                parl:addressLine3 ?addressLine3 ;
                parl:addressLine4 ?addressLine4 ;
                parl:addressLine5 ?addressLine5 .
    		?person
              a parl:Person ;
              parl:personGivenName ?givenName ;
        			parl:personFamilyName ?familyName ;
              <http://example.com/F31CBD81AD8343898B49DC65743F0BDF> ?displayAs .
        }
        WHERE {
    		BIND(<#{DATA_URI_PREFIX}/#{id}> AS ?contactPoint )
        	?contactPoint a parl:ContactPoint ;
        	OPTIONAL{ ?contactPoint parl:email ?email . }
        	OPTIONAL{ ?contactPoint parl:phoneNumber ?phoneNumber . }
        	OPTIONAL{ ?contactPoint parl:faxNumber ?faxNumber . }
        	OPTIONAL{
                ?contactPoint parl:contactPointHasPostalAddress ?postalAddress .
                OPTIONAL{ ?postalAddress parl:postCode ?postCode . }
               	OPTIONAL{ ?postalAddress parl:addressLine1 ?addressLine1 . }
               	OPTIONAL{ ?postalAddress parl:addressLine2 ?addressLine2 . }
               	OPTIONAL{ ?postalAddress parl:addressLine3 ?addressLine3 . }
               	OPTIONAL{ ?postalAddress parl:addressLine4 ?addressLine4 . }
               	OPTIONAL{ ?postalAddress parl:addressLine5 ?addressLine5 . }
          	}
            OPTIONAL{
				      ?contactPoint parl:contactPointHasIncumbency ?incumbency .
        		  ?incumbency parl:incumbencyHasMember ?person .
        		  OPTIONAL { ?person parl:personFamilyName ?familyName . }
        		  OPTIONAL { ?person parl:personGivenName ?givenName . }
              OPTIONAL { ?person <http://example.com/F31CBD81AD8343898B49DC65743F0BDF> ?displayAs } .
            }
      }"
  end
end