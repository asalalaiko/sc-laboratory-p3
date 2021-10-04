@isTest	
private class getOppInfoTest {
    
    static testMethod void testgetTotalRecords(){
        insert new Account[]{new Account(Name = '1yyy'), 
                   			new Account(Name = 'yyy2'), 
            				new Account(Name = 'yyy23'), 
            				new Account(Name = 'yyy 234'), 
            				new Account(Name = ' yyy'), 
                     		new Account(Name = '1212 yyy')};
        
    Integer getTR = getOppInfo.getTotalRecords('yyy', 0);
    System.assertEquals(6, getTR, '++++!');   
    }
    
    
    static testMethod void testsearchAcc(){
        for (Integer i = 0; i < 10; i++){
        Account a = new Account(Name='TestAccount'+1);
		insert a; 
            for (Integer j = 0; j < 5; j++){
                Opportunity opp = new Opportunity(Name='TestAccount'+1, Amount=Integer.valueof((Math.random() * 1000)), StageName='Closed Won',  CloseDate = date.newInstance(2020, 09, 30));
		insert opp; 
            }
                               } 
       List<getOppInfo.AccOppInf> response = new List<getOppInfo.AccOppInf>();
       response = getOppInfo.searchAcc('yyy', 10, 1, 10); 
    }    
    

    static testMethod void testgetAcc(){
        Account a = new Account(Name='TestAccount');
		insert a; 
         for (Integer j = 0; j < 5; j++){
                Opportunity opp = new Opportunity(Name='TestAccount'+1, accountid = a.Id, Amount=10, ForecastCategoryName = 'Closed', StageName='Closed Won', CloseDate = date.newInstance(2020, 09, 30));
		insert opp; 
   		}
        List<getOppInfo.AccOppInf> response = new List<getOppInfo.AccOppInf>();
       response = getOppInfo.getAcc(a.Id); 
    }
    
    
    
     static testMethod void testgetSummClosedOpp(){
        Account a = new Account(Name='TestAccount');
		insert a; 
         for (Integer j = 0; j < 5; j++){
                Opportunity opp = new Opportunity(Name='TestAccount'+1, accountid = a.Id, Amount=10, ForecastCategoryName = 'Closed', StageName='Closed Won', CloseDate = date.newInstance(2020, 09, 30));
		insert opp; 
   		}
    Decimal summ = getOppInfo.getSummClosedOpp(a.Id);
    System.assertEquals(50.00, summ, '++++!');   
    }
    
 
 
}