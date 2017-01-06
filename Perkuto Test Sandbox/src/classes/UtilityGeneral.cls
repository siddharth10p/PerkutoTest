/**
 * Description: This class contains static methods which are reusable
 * 
 *    Author           Date (mm-dd-yyyy)  Version    Changelog
 * Siddharth Pandit    12/16/2016           1.0      Inital draft
 *
 *
 **/
public with sharing class UtilityGeneral {

    // A method that creates data for test classes
    public static void createTestData () {

        // Create test data
        Company_Information__c compInfo = new Company_Information__c (Name ='Test',
                                                            Terms_and_Conditions__c = 'test');
        insert compInfo;
        Account acc = new Account (Name= 'Perkuto Test', Account_Status__c = 'Active',
                                    Type = 'Client', Tax_Code__c = 'Exempt',
                                    Payment_Terms__c = 'Net 15');
        insert acc;

        Opportunity opty = new Opportunity (Name = 'Perkuto Test - Test Oppty', CloseDate= Date.today(),
                                            StageName = 'Prospecting', AccountId = acc.Id);
        insert opty;

        Opportunity opty2 = new Opportunity (Name = 'Perkuto Test - Test Oppty2', CloseDate= Date.today(),
                                            StageName = 'Prospecting', AccountId = acc.Id);
        insert opty2;

        Contact con = new Contact (LastName = 'Test Con', AccountId = acc.Id);
        insert con;

        Contact con2 = new Contact (LastName = 'Test con2', AccountId = acc.Id);
        insert con2;

        OpportunityContactRole opptyConRole = new OpportunityContactRole (ContactId = con.Id,
                                                OpportunityId = opty.Id);
        insert opptyConRole;

        OpportunityContactRole opptyConRole2 = new OpportunityContactRole (ContactId = con2.Id,
                                                OpportunityId = opty2.Id);
        insert opptyConRole2;

        opty.StageName = 'Closed Won';
        update opty;

        opty2.StageName = 'Closed Lost'; opty2.Closed_Lost_Reason__c= 'No Decision';
        update opty2;
    }
}