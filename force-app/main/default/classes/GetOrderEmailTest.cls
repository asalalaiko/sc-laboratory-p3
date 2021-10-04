@isTest	
public class GetOrderEmailTest {

    public static testMethod void TestApproved(){
     
       Contact con = new Contact();
       con.LastName = 'sample';
       con.Email = 'someaddress@email.com';
       insert con;
       
        Opportunity opp = new Opportunity();
        opp.Name = 'Opp12221211';
        opp.Amount = 10;
        opp.ForecastCategoryName = 'Closed';
        opp.StageName='Closed Won';
        opp.CloseDate = date.newInstance(2020, 09, 30);
        insert opp;

        Opportunity o = [SELECT Id, Name, StageName, Invoice_Number__c
                          FROM Opportunity
                          LIMIT 100]; 
        

       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
      
      email.subject = o.Invoice_Number__c;
      email.fromAddress = 'someaddress@email.com';
      email.plainTextBody = 'Approved';
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      attachment.body = blob.valueOf('my attachment text');
      attachment.mimeTypeSubType = 'text/plain';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
     
      GetOrderEmail  testInbound=new GetOrderEmail ();
      testInbound.handleInboundEmail(email, env);
        

   }

   public static testMethod void TestRejected(){
     
       Contact con = new Contact();
       con.LastName = 'sample';
       con.Email = 'someaddress@email.com';
       insert con;
       
        Opportunity opp = new Opportunity();
        opp.Name = 'Opp12221211';
        opp.Amount = 10;
        opp.ForecastCategoryName = 'Closed';
        opp.StageName='Closed Won';
        opp.CloseDate = date.newInstance(2020, 09, 30);
        insert opp;

        Opportunity o = [SELECT Id, Name, StageName, Invoice_Number__c
                          FROM Opportunity
                          LIMIT 100]; 
        

       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
      
      email.subject = o.Invoice_Number__c;
      email.fromAddress = 'someaddress@email.com';
      email.plainTextBody = 'Rejected';
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      attachment.body = blob.valueOf('my attachment text');
      attachment.mimeTypeSubType = 'text/plain';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
     
      GetOrderEmail  testInbound=new GetOrderEmail ();
      testInbound.handleInboundEmail(email, env);
        

   }
}