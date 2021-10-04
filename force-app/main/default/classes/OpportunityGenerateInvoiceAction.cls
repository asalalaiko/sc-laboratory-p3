public class OpportunityGenerateInvoiceAction {
    
    public ID oppId {get{oppId=ApexPages.currentPage().getParameters().get('id');
                        return oppId;} set;}
    
    
    public  void generateInvoice(){
       
            Opportunity opportunity = new Opportunity();   
            opportunity = [SELECT Id, Name, Invoice_Number__c FROM Opportunity WHERE Id =:this.oppId LIMIT 1];
        
 		
            PageReference defaultPage = Page.OpportunityInvoicePDF;
            defaultPage.getParameters().put('oppId',this.oppId); //passing in id for specific record
            Blob pageData; //variable to hold binary PDF data.
            
             if(!Test.isRunningTest()){ // for code coverage 
                    pageData = defaultPage.getContentAsPDF();
                } else {
                    pageData = Blob.valueOf('This is a test.');
                }
                    
                    	 	
            //ContentVersion
            
            ContentVersion cv = new ContentVersion();
	        List<ContentVersion> cvList = [SELECT Id, IsLatest, VersionNumber, ContentDocumentId FROM ContentVersion WHERE Title =: opportunity.Invoice_Number__c ORDER BY VersionNumber DESC ];
           	if(!cvList.isEmpty()) cv=cvList[0];	else cv=NULL;
        		
        
  
            ContentVersion contentVersion_1 = new ContentVersion();
            if (cv!=NULL){
                contentVersion_1.ContentDocumentId = cv.ContentDocumentId;
                contentVersion_1.ContentLocation = 'S';
                contentVersion_1.Title= opportunity.Invoice_Number__c;
                contentVersion_1.PathOnClient ='/'+opportunity.Invoice_Number__c + '.pdf';
                contentVersion_1.VersionData = pageData;
                contentVersion_1.Origin = 'H';
                
                insert contentVersion_1;
                               
             }
            else{     

                contentVersion_1.Title= opportunity.Invoice_Number__c;
                contentVersion_1.PathOnClient ='/'+opportunity.Invoice_Number__c + '.pdf';
                contentVersion_1.VersionData = pageData;
                contentVersion_1.Origin = 'H';
                
                insert contentVersion_1;
                
                ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId, VersionNumber FROM ContentVersion
                WHERE Id = :contentVersion_1.Id LIMIT 1];
                
                
                ContentDocumentLink contentlink = new ContentDocumentLink();
                contentlink.LinkedEntityId = opportunity.Id;
                contentlink.ContentDocumentId = contentVersion_2.ContentDocumentId;
                contentlink.ShareType = 'V';
                insert contentlink; 
                
          
            }  

 
    }
/*    
        public static void  generateInvoiceToOppId(ID oppId){
        
            Opportunity opportunity = new Opportunity();   
            opportunity = [SELECT Id, Name, Invoice_Number__c FROM Opportunity WHERE Id =: oppId LIMIT 1];
        
 		
            PageReference defaultPage = Page.OpportunityInvoicePDF;
            defaultPage.getParameters().put('oppId', oppId); //passing in id for specific record
            Blob pageData; //variable to hold binary PDF data.
            
             if(!Test.isRunningTest()){ // for code coverage 
                    pageData = defaultPage.getContentAsPDF();
                } else {
                    pageData = Blob.valueOf('This is a test.');
                }
                    
                    	 	
            //ContentVersion
            
            ContentVersion cv = new ContentVersion();
	        List<ContentVersion> cvList = [SELECT Id, IsLatest, VersionNumber, ContentDocumentId FROM ContentVersion WHERE Title =: opportunity.Invoice_Number__c ORDER BY VersionNumber DESC ];
           	if(!cvList.isEmpty()) cv=cvList[0];	else cv=NULL;
        		
        
  
            ContentVersion contentVersion_1 = new ContentVersion();
            if (cv!=NULL){
                System.debug('****************************************************** ');	   
                
                
                contentVersion_1.ContentDocumentId = cv.ContentDocumentId;
                contentVersion_1.ContentLocation = 'S';
                contentVersion_1.Title= opportunity.Invoice_Number__c;
                contentVersion_1.PathOnClient ='/'+opportunity.Invoice_Number__c + '.pdf';
                contentVersion_1.VersionData = pageData;
                contentVersion_1.Origin = 'H';
                
                insert contentVersion_1;
                               
             }
            else{     
                System.debug('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ');      
                
           		contentVersion_1.ContentLocation = 'S';
                contentVersion_1.Title= opportunity.Invoice_Number__c;
                contentVersion_1.PathOnClient ='/'+opportunity.Invoice_Number__c + '.pdf';
                contentVersion_1.VersionData = pageData;
                contentVersion_1.Origin = 'H';
                
                insert contentVersion_1;
                
                ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId, VersionNumber FROM ContentVersion
                WHERE Id = :contentVersion_1.Id LIMIT 1];
                
                
                ContentDocumentLink contentlink = new ContentDocumentLink();
                contentlink.LinkedEntityId = opportunity.Id;
                contentlink.ContentDocumentId = contentVersion_2.ContentDocumentId;
                contentlink.ShareType = 'V';
                insert contentlink; 
                 
            }
 
    }*/
}