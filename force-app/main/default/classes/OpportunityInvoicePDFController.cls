public with sharing class OpportunityInvoicePDFController {

     
    public Id oppId { get{oppId=ApexPages.currentPage().getParameters().get('oppId');
                         return oppId;
                         } set; }  // Opportunity selected on Visualforce page
  
    public Organization myOrg{   
        get { myOrg = [Select Name, Country, State, City, Street From Organization ];
        return myOrg;
    }   set;}
    
    public OpportunityContactRole myOpp{ 
        get { myOpp = [Select Contact.Name, CreatedBy.Name From OpportunityContactRole WHERE OpportunityId = :oppId ];
        return myOpp;
    }   set;}
    
    
     public Contact oppContact{ 
        get { oppContact = [Select Name, Phone, MobilePhone, Email, Account.Name From Contact WHERE Id = :myOpp.ContactId ];
             return oppContact;
    }   set;}
    

    public List<OpportunityLineItem> oppProduct{ 
        get { 
            oppProduct = [Select Product2.Name, Quantity, UnitPrice, TotalPrice From OpportunityLineItem WHERE OpportunityId = :oppId ];
            this.sumTotalPrice = 0;
            for(OpportunityLineItem a : oppProduct){
                this.sumTotalPrice = this.sumTotalPrice + a.TotalPrice;
            }
        return oppProduct;
    }   set;}
    
    public Decimal sumTotalPrice{
        get{ return sumTotalPrice;
    }  set; }
    
    public Opportunity Opp{
        get{ 
            Opp = [SELECT Id, Name, Invoice_Number__c, Createddate FROM Opportunity WHERE Id = :oppId ];
            return Opp;
    }  set; }
    
    
}