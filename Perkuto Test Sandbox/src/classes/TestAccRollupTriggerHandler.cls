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
private class TestAccRollupTriggerHandler {

    static testMethod void coverTriggerCode() {
        // Create test data
        Account acc = new Account (Name = 'Test Acc');
        insert acc;
        
        Company_Information__c companyInfo = new Company_Information__c (Name = 'Test Comp',
        													Terms_and_Conditions__c = 'Test New');
        insert companyInfo;
        List<Opportunity> listOpptyToInsert = new List<Opportunity> ();
        for (Integer i=0; i<5; i++) {
        	Opportunity oppty = new Opportunity (Name = 'Test Acc - Test-'+i, CloseDate = Date.today(), 
        									StageName = 'Closed Won', AccountId = acc.Id,
        									Type = 'Existing Business', Amount = 1000);
        	listOpptyToInsert.add (oppty);
        }
        insert listOpptyToInsert;
        Opportunity oppty = new Opportunity (Name = 'Test Acc - Non-Won', CloseDate = Date.today(), 
        									StageName = 'Prospecting', AccountId = acc.Id,
        									Type = 'Existing Business', Amount = 1000);
        insert oppty;
        Account accInstance = [SELECT Won_Opportunity__c FROM Account WHERE Id =: acc.Id];
        System.assertEquals (5000, accInstance.Won_Opportunity__c);
		
		// Winning another Oppty and validating the Won_Opportunity__c field
		oppty.StageName = 'Closed Won';
		update oppty;
		System.assertEquals (6000, [SELECT Won_Opportunity__c FROM Account WHERE Id =: acc.Id].Won_Opportunity__c);
		
		// Deleting oppty and validating the Won_Opportunity__c field
		delete oppty;
		System.assertEquals (5000, [SELECT Won_Opportunity__c FROM Account WHERE Id =: acc.Id].Won_Opportunity__c);
    }
}