global class GetOrderEmail implements Messaging.InboundEmailHandler{
     global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                            Messaging.InboundEnvelope env){
    
	Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
                                                                
	 list <Opportunity> opp = new List <opportunity>();
                                                                
	// Convert the subject line to lower case so the program can match on lower case.
    String mySubject = email.subject.toUpperCase();
    // The search string used in the subject line.
    String myBody = email.plainTextBody;
    // The search string used in the subject line.
    String sApproved = 'Approved';                                                            
    String sRejected = 'Rejected';   

	if (myBody.contains(sApproved)) {
          
        try {
        for (Opportunity o : [SELECT Id, Name, StageName, Invoice_Number__c
                          FROM Opportunity
                          WHERE StageName = 'Prospecting'
                          AND Invoice_Number__c =: mySubject
                          LIMIT 100]) {
                          
                // Add all the matching contacts into the list.   
                o.StageName = 'Qualification' ;
                opp.add(o);
            }
            // Update all of the contact records.
            System.debug('Opp Update: ' + opp);
            update opp;
        }
        catch (System.QueryException e) {
            System.debug('Contact Query Issue: ' + e);
        }   
    }
                                                                
    if (myBody.contains(sRejected)) {
          
        try {
        for (Opportunity o : [SELECT Id, Name, StageName, Invoice_Number__c
                          FROM Opportunity
                          WHERE Invoice_Number__c =: mySubject
                          LIMIT 100]) {
                          
                // Add all the matching contacts into the list.   
                o.StageName = 'Closed Lost' ;
                opp.add(o);
            }
            // Update all of the contact records.
           	System.debug('Opp Update: ' + opp);
            update opp;
        }
        catch (System.QueryException e) {
            System.debug('Contact Query Issue: ' + e);
        }   
    }
                                                                
                                                                


	return result;
                                                                
	}

}