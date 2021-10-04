public  with sharing class GetEmailTemplate {
   
     @AuraEnabled
    public String emailSubject {get; set;}
    
    @AuraEnabled
    public String emailBody {get; set;}
    
    @AuraEnabled
    public String emailEmail {get; set;}
    
    @AuraEnabled
    public String emailContactName {get; set;}
    
      
    
    @AuraEnabled(cacheable=true)
    public static GetEmailTemplate GetEmail(ID oppId) {
            
        
       // Opportunity opp = new Opportunity(SELECT Name, 	Opportunity)
        GetEmailTemplate getET = new GetEmailTemplate();
        Organization myOrg = [Select o.Name From Organization o];
        EmailTemplate gEmail = [SELECT Name, Subject, HtmlValue from EmailTemplate WHERE ID ='00X5g000001htohEAA' LIMIT 1];
       	OpportunityContactRole ocrs = [SELECT Opportunity.Invoice_Number__c, Contact.Name, Contact.Email FROM OpportunityContactRole WHERE OpportunityId =: oppId AND isPrimary=TRUE LIMIT 1];

       
       // getET.emailSubject = gEmail.Subject;
        getET.emailSubject = gEmail.Subject.replace('{!Opportunity.Invoice_Number__c}', ocrs.Opportunity.Invoice_Number__c);
        String emailBody = gEmail.HtmlValue.replace('{!Contact.Name}', ocrs.Contact.Name);
        	emailBody = emailBody.replace('{!Opportunity.Invoice_Number__c}', ocrs.Opportunity.Invoice_Number__c);
        	emailBody = emailBody.replace('{!Organization.Name}', myOrg.Name);
        getET.emailBody = emailBody;
        getET.emailEmail = ocrs.Contact.Email;
        getET.emailContactName = ocrs.Contact.Name;
        
        
        return getET;
    }
    
   
   
    @AuraEnabled(cacheable=true)
    public static List<OpportunityContactRole> GetContactRoles(ID oppId) {
        
        OpportunityContactRole[] ocrs = [
            SELECT
                Contact.Name,
                Contact.Email
            FROM OpportunityContactRole
            WHERE OpportunityId =: oppId AND isPrimary=TRUE
        ];
                 
        return ocrs;
    }
    
    @AuraEnabled(cacheable=true)
	public static String getContentDocumentId(Id oppId) {
     String cdi = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId =: oppId LIMIT 1].ContentDocumentId;
        return cdi;
	}
    
    
    
    @AuraEnabled(cacheable=true)
    public static void sendEmail(String toSend, Id oppId, Id oppCD){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            
            ContentVersion wkshtDta = [SELECT Id, Title, FileType, VersionData, isLatest, ContentDocumentId FROM ContentVersion WHERE isLatest = true AND ContentDocumentId=:oppCD LIMIT 1];
            Opportunity opp = [SELECT AccountId,ContactId FROM Opportunity WHERE Id =: oppId LIMIT 1];
           
       		efa.setBody(wkshtDta.VersionData);
            string fileName = wkshtDta.Title + '.pdf';
			efa.setFileName(fileName);
            efa.setInline(false);
            efa.setContentType('application/pdf');
            
                        
            String[] toAddresses = new String[] {toSend};
            mail.setToAddresses(toAddresses);
            mail.setUseSignature(false); 
   			mail.setBccSender(false); 
   			mail.setSaveAsActivity(false); 
            mail.setTargetObjectId(opp.ContactId);
            mail.setWhatId(oppId);
            mail.setTemplateId('00X5g000001htohEAA');
            
            
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    } 
}