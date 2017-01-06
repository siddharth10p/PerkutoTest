/**
 * Description: This class contains methods that are used to update Total Won Opportunity field
 * on Account object.
 * Copyright © Peruto Solutions Inc.
 *
 *      Author            Date(mm-dd-yyyy)     Version          Changelog
 * Siddharth Pandit        04-13-2016           1.0            Initial draft
 **/
public with sharing class AccRollupTriggerHandler {

    public static void updateAccRollup (Map<Id, Opportunity> mapOpptyIdObj) {
        if (mapOpptyIdObj != null && mapOpptyIdObj.size() > 0) {
        	Set<Id> setAccIds = new Set<Id> ();
        	for (Opportunity oppty : mapOpptyIdObj.values()) {
        		if (String.isNotBlank (oppty.AccountId))
        			setAccIds.add (oppty.AccountId);
        	}
            Map<Id, Decimal> mapAccIdOpptyAmt = new Map<Id, Decimal> ();
            for (Opportunity oppty : [SELECT Id, AccountId, Amount, 
            								convertCurrency(amount) convertedAmt,
                                            FORMAT(convertCurrency(amount)) convertedCurrency 
                                        FROM Opportunity
                                        WHERE StageName = 'Closed Won'
                                        AND AccountId IN : setAccIds]) {
                if (!mapAccIdOpptyAmt.containsKey (oppty.AccountId))
                    mapAccIdOpptyAmt.put (oppty.AccountId, 0);
                    Decimal amtExist = mapAccIdOpptyAmt.get (oppty.AccountId) + oppty.Amount;//(Decimal) oppty.get ('convertedAmt');
                    mapAccIdOpptyAmt.put (oppty.AccountId, amtExist);
            } // End for

            List<Account> lstAccountToUpdate = new List<Account> ();
            for (Account accInstance : [SELECT Id, Won_Opportunity__c
                                        FROM Account
                                        WHERE Id IN : mapAccIdOpptyAmt.keySet()
                                        OR Id IN : setAccIds]) {
                if (mapAccIdOpptyAmt.containsKey(accInstance.Id))
                	accInstance.Won_Opportunity__c = mapAccIdOpptyAmt.get (accInstance.Id);
                else 
                	accInstance.Won_Opportunity__c = null;
                lstAccountToUpdate.add (accInstance);
            } // End for
    
            if (lstAccountToUpdate.size() > 0)
                update lstAccountToUpdate;
        } // End if
    } // End method
}