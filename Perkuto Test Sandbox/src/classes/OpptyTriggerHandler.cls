/**
 * Description: This is a handler class referred in Oppty trigger
 * 
 *    Author           Date (mm-dd-yyyy)  Version    Changelog
 * Siddharth Pandit    11/29/2016           1.0      Inital draft
 *
 * LP URL: /space/118974/projects/show/34104057
 * Test class name: 
 *
 **/
public with sharing class OpptyTriggerHandler {
    // Final variables
    public static final String STR_CLOSEWON = 'Opportunity Won';
    public static final String STR_CLOSELOST = 'Opportunity Lost';

    // A method that changes contact's lifecycle stage reason
    public static void updateLifecycleReason (Map<Id, Opportunity> idOpptyMap) {
        Map<Id, String> conIdStageMap = new Map<Id, String> ();
        for (OpportunityContactRole opptyCon : [SELECT Id, ContactId, OpportunityId,
                                                    Opportunity.IsClosed, Opportunity.IsWon
                                                FROM OpportunityContactRole
                                                WHERE OpportunityId IN: idOpptyMap.keySet ()]) {
            if (opptyCon.Opportunity.IsClosed) {
                if (opptyCon.Opportunity.IsWon)
                    conIdStageMap.put (opptyCon.ContactId, STR_CLOSEWON);
                else
                    conIdStageMap.put (opptyCon.ContactId, STR_CLOSELOST);
            } //End if
        } // End for

        List<Contact> conListToUpdate = new List<Contact> ();
        for (Contact conInstance : [SELECT Id, Lifecycle_Stage_Reason__c
                                    FROM Contact
                                    WHERE Id IN: conIdStageMap.keySet()]) {
            conInstance.Lifecycle_Stage_Reason__c = conIdStageMap.get (conInstance.Id);
            conListToUpdate.add (conInstance);
        }
        if (!conListToUpdate.isEmpty ())
            update conListToUpdate;
    }
}