@isTest	
private class GetEmailTemplateTest {
    
    static testMethod void testGetEmail()    {
   	Account a = new Account(Name='TestAccount');
	insert a;
	Opportunity o = new Opportunity(Name='TestOpportunity', AccountId=a.id, StageName='Prospecting', CloseDate=System.today().addMonths(1));
  	insert o;
   	Contact c = new Contact(LastName='LastName', FirstName='FirstName', Email = 'test@test.by');
	insert c;     
	OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.Id,ContactId=c.Id, isPrimary=TRUE);
	insert ocr; 
    EmailTemplate eT = NEW EmailTemplate(ID ='00X5g000001htohEAA');
        
           
 	GetEmailTemplate getET = GetEmailTemplate.GetEmail(o.Id);

    //System.assertEquals('Invoice #'+o.Invoice_Number__c, getET.emailSubject, '++++!');
    System.assertEquals('test@test.by', getET.emailEmail, '++++!');    
	  
    }
    
     static testMethod void testGetContactRoles()    {
   	Account a = new Account(Name='TestAccount');
	insert a;
	Opportunity o = new Opportunity(Name='TestOpportunity', AccountId=a.id, StageName='Prospecting', CloseDate=System.today().addMonths(1));
  	insert o;
   	Contact c = new Contact(LastName='LastName', FirstName='FirstName');
	insert c;     
	OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.Id,ContactId=c.Id, isPrimary=TRUE);
	insert ocr; 
    EmailTemplate eT = NEW EmailTemplate(ID ='00X5g000001htohEAA', Subject = 'Subject TEST', HtmlValue = 'HtmlValue TEST');
    List<OpportunityContactRole> getCR = GetEmailTemplate.GetContactRoles(o.Id);
    
    System.assertEquals(1, getCR.size(),'Do not neglect meaningful messages!'); 

    }
    

    static testMethod void testgetContentDocumentId()   {
	Account a = new Account(Name='TestAccount');
	insert a;
    Contact c = new Contact(LastName='LastName', FirstName='FirstName',MobilePhone = '+999999999999', Email='test@test.te', AccountId = a.Id );
	insert c;    
	Opportunity o = new Opportunity(Name='TestOpportunity', AccountId=a.id, StageName='Prospecting', CloseDate=System.today().addMonths(1));
  	insert o;
    OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.Id,ContactId=c.Id, isPrimary=TRUE);
	insert ocr; 
      
   
    
    	ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = Blob.valueOf('This is a test.');
        cv.Title = 'Test';
        cv.PathOnClient = '/test.pdf';
        insert cv;
		ContentVersion contentVersion = [SELECT Id, Title, ContentDocumentId, VersionNumber FROM ContentVersion
        WHERE Id = :cv.Id LIMIT 1];
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = o.Id;
        contentlink.ContentDocumentId = contentVersion.ContentDocumentId;
        contentlink.ShareType = 'V';
        insert contentlink; 
        
 
    String getCDL = GetEmailTemplate.getContentDocumentId(o.Id);    
    System.assertEquals(contentlink.ContentDocumentId, getCDL,'OK!');     
    } 
    
    
    static testMethod void testsendEmail()  {
        
	Account a = new Account(Name='TestAccount');
	insert a;
    Contact c = new Contact(LastName='LastName', FirstName='FirstName',MobilePhone = '+999999999999', Email='test@test.te', AccountId = a.Id );
	insert c;    
	Opportunity o = new Opportunity(Name='TestOpportunity', AccountId=a.id, StageName='Prospecting', CloseDate=System.today().addMonths(1));
  	insert o;
    OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.Id,ContactId=c.Id, isPrimary=TRUE);
	insert ocr; 
      
   
    
    	ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.VersionData = Blob.valueOf('This is a test.');
        cv.Title = 'Test';
        cv.PathOnClient = '/test.pdf';
        insert cv;
		ContentVersion contentVersion = [SELECT Id, Title, ContentDocumentId, VersionNumber FROM ContentVersion
        WHERE Id = :cv.Id LIMIT 1];
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = o.Id;
        contentlink.ContentDocumentId = contentVersion.ContentDocumentId;
        contentlink.ShareType = 'V';
        insert contentlink; 
        
	 System.assert(GetEmailTemplate.sendEmail(c.Email, o.Id, contentlink.ContentDocumentId)==null, 'Test Ok!');      
    }
    
    

}