@isTest
public class OpportunityGenerateInvoiceActionTest {
   
    
    static testMethod void testGenerateInvoice1() {
 	Account a = new Account(Name='TestAccount');
	insert a;
    Contact c = new Contact(LastName='LastName', FirstName='FirstName',MobilePhone = '+999999999999', Email='test@test.te', AccountId = a.Id );
	insert c;  
	Opportunity o = new Opportunity(Name='TestOpportunity', AccountId=a.id, StageName='Prospecting', CloseDate=System.today().addMonths(1));
  	insert o;
    Opportunity o2 = [Select Id, Name From Opportunity WHERE Id = :o.Id];    
    OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.Id,ContactId=c.Id, isPrimary=TRUE);
	insert ocr; 
    OpportunityContactRole ocr2 = [Select Contact.Name, CreatedBy.Name From OpportunityContactRole WHERE OpportunityId = :o.Id];
        for(Integer i = 1; i < 10; i++) {
            
            Product2 pro2 = new Product2(Name = 'Product'+i);
            insert pro2;
            Pricebook2 pb2 = new Pricebook2(Name='NONDIE');
  			insert pb2;
            Id pricebookId = Test.getStandardPricebookId();
            PriceBookEntry pbe = new PriceBookEntry(Product2Id = pro2.Id, UnitPrice=10, Pricebook2Id=pricebookId, isActive=true,UseStandardPrice = false );
            insert pbe;
            OpportunityLineItem OLI = new OpportunityLineItem(PricebookEntryId = pbe.id, OpportunityId = o.id, Product2Id = pro2.Id , Quantity = i, UnitPrice=10 );
            insert OLI;
        }   
        
  
   
        
     PageReference pageRef = Page.OpportunityInvoicePDF;
     Test.setCurrentPage(pageRef);
     ApexPages.currentPage().getParameters().put('id', o2.id);
        
    OpportunityGenerateInvoiceAction OPGA = new OpportunityGenerateInvoiceAction();    
	OPGA.oppId = o.Id;
    
    
    OPGA.generateInvoice();
		 
    }
}