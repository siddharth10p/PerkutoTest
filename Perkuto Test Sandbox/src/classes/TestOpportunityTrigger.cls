@isTest
public class TestOpportunityTrigger {
    static testmethod void TestCreateOpportunityAccountMSATrue(){
        Test.startTest();
        Account acc = TestDataFactoryOpportunity.createOpportunityProcess(1);
        System.assertEquals(null, acc.T_C__c);
        Test.stopTest();
    }
    
    static testmethod void TestCreateOpportunityAccountMSAFalse(){
        Test.startTest();
        Account acc = TestDataFactoryOpportunity.createOpportunityProcess(2);
        System.assertEquals(null, acc.T_C__c);
        Test.stopTest();
    }
    
    static testmethod void TestCreateOpportunityAccountMSAFalseTCFilled(){
        Test.startTest();
        Account acc = TestDataFactoryOpportunity.createOpportunityProcess(3);
        System.assertEquals('Test Text', acc.T_C__c);
        Test.stopTest();
    }
    
    static testmethod void TestCreate200Opportunity(){
        Test.startTest();
        Account acc = TestDataFactoryOpportunity.createOpportunityProcess(3);
        List<Opportunity> listOpp = new List<Opportunity>();
        
        for(Integer i=0; i< 210; i++){
        
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Account - Opp Name ' + i;
            opp.AccountId = acc.id;
            opp.Type = 'New Business';
            opp.StageName = 'Qualification';
            opp.CloseDate = Date.newinstance(2015, 11, 29);
            listOpp.add(opp);
        }
        
         insert listOpp;
         System.assertEquals(210, listOpp.size());
         Test.stopTest();
     }
    
}