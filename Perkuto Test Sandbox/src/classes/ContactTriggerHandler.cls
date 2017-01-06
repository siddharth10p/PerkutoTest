/**
 * Description: This trigger will allign owner with account owner when a new record 
 * on Account object.
 * Copyright © Peruto Solutions Inc.
 *
 *      Author            Date(mm-dd-yyyy)     Version          Changelog
 * Siddharth Pandit        10-14-2016           1.0            Initial draft
 * LP URL- /space/118974/projects/show/33772397P
 **/
public with sharing class ContactTriggerHandler {
    // Static variables
    private static final String STR_ACCID = 'AccountId';
    private static final String STR_OWNID = 'OwnerId';

    // A method that triggers batch apex when account owner changes
    public static void updateChildRecOwner (Map<Id, Account> oldAccMap, Map<Id, Account> newAccMap) {
       Set<Id> accIdsSet = new Set<Id> ();
       for (Id accId : oldAccMap.keySet()) {
           // if Account owner is changed
           if (oldAccMap.get (accId).OwnerId != newAccMap.get (accId).OwnerId) {
               accIdsSet.add (accId);
           } // End if
       } // End for
       updateContactOwner (accIdsSet); // Calling contact trigger to update ownership
    }

    public static void updateContactOwner (Set<Id> accIdSet) {
        if (accIdSet.size() > 0) // Dummy update on related contacts to change ownership by contact trigger
        update [SELECT Id FROM Contact WHERE AccountId IN :accIdSet];
    } // End method

    // A method to update Contact or Opportunity owner when they are created of updated
    public static void updateRecordOwner (List<Sobject> objList) {
        Set<String> accIdsSet = new Set<String > ();
        for (Sobject objInstance : objList) {
            if (objInstance.get (STR_ACCID) != null) {
                accIdsSet.add (String.valueOf (objInstance.get (STR_ACCID)));
            } // End if
        } // End for

        Map<String, String> accOwnerIdMap = new Map< String, String> ();
        for (Account accInstance : [SELECT Id, OwnerId
                                    FROM Account
                                    WHERE Id IN :accIdsSet]) {
            accOwnerIdMap.put (accInstance.Id, accInstance.OwnerId);
        } // End for

        for (Sobject objInstance : objList) {
            if (accOwnerIdMap.containsKey (String.valueOf (objInstance.get (STR_ACCID)))) {
                objInstance.put (STR_OWNID, 
                    accOwnerIdMap.get (String.valueOf (objInstance.get (STR_ACCID))));
            }
        } //End for
    } // End method 
}