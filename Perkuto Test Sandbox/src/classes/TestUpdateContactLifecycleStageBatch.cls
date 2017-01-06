/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestUpdateContactLifecycleStageBatch {

    static testMethod void testBatchClass() {

            // Create test data
        Company_Information__c compInfo = new Company_Information__c (Name ='Test',
                                                            Terms_and_Conditions__c = 'test');
        insert compInfo;
        Account acc = new Account (Name= 'Perkuto Test', Account_Status__c = 'Active',
                                    Type = 'Client', Tax_Code__c = 'Exempt',
                                    Payment_Terms__c = 'Net 15');
        insert acc;

        Opportunity opty = new Opportunity (Name = 'Perkuto Test - Test Oppty',
                                            CloseDate= Date.today(),
                                            StageName = 'Prospecting', AccountId = acc.Id);
        insert opty;

        Opportunity opty2 = new Opportunity (Name = 'Perkuto Test - Test Oppty2',
                                            CloseDate= Date.today(),
                                            Delivery_Team__c = 'Allegro',
                                            StageName = 'Closed Won', AccountId = acc.Id);
        insert opty2;

        Contact con = new Contact (LastName = 'Test Con', AccountId = acc.Id,
                                    p2s_base1__LifecycleStage__c = 'Test LLC');
        insert con;

        Contact con2 = new Contact (LastName = 'Test Con', AccountId = acc.Id,
                                                p2s_base1__LifecycleStage__c = 'Test LLC');
        insert con2;

        OpportunityContactRole opptyConRole = new OpportunityContactRole (ContactId = con.Id,
                                                OpportunityId = opty.Id);
        insert opptyConRole;

        OpportunityContactRole opptyConRole2 = new OpportunityContactRole (ContactId = con2.Id,
                                                OpportunityId = opty2.Id);
        insert opptyConRole2;

        Test.startTest();
            UpdateContactLifecycleStageBatch updateConLLC =
                                                    new UpdateContactLifecycleStageBatch ();
            string schTime = '0 0 * * 1-12 ? *';
            system.schedule('UpdateContactLifecycleStageBatch', schTime, updateConLLC);
            Database.executeBatch (updateConLLC, 200);
        Test.stopTest();
        // Assertion 
        for (Contact conInstance : [SELECT Id, p2s_base1__LifecycleStage__c
                                    FROM Contact]) {
            if (conInstance.Id.equals (con.Id))
                System.assertEquals (UpdateContactLifecycleStageBatch.STAGE_INOPENOPTY,
                                     conInstance.p2s_base1__LifecycleStage__c);
            if (conInstance.Id.equals (con2.Id))
                System.assertEquals ('Test LLC',
                                     conInstance.p2s_base1__LifecycleStage__c);
        }
    }
}