/**
 * Description: When a person is given a contact role on an opportunity, an apex batch will
 * change the lifecycle stage on contact should be changed to "In Open Oppty". The batch will be
 * schedule to run daily
 * 
 *    Author           Date (mm-dd-yyyy)  Version    Changelog
 * Siddharth Pandit    11/28/2016           1.0      Inital draft
 *
 * LP URL: /space/118974/projects/show/34104057
 * Test class name: 
 *
 **/
global class UpdateContactLifecycleStageBatch implements Database.Batchable<sObject>,
                                                                                Schedulable {
    public static final String STAGE_INOPENOPTY = 'In Open Opportunity';

    global Database.Querylocator start(Database.BatchableContext BC) {
        Integer maxRows = Test.isRunningTest() ? 10 : 50000000;
        return Database.getQueryLocator([SELECT ContactId,
                                                OpportunityId,
                                                Opportunity.IsClosed,
                                                CreatedDate
                                            FROM OpportunityContactRole
                                            WHERE CreatedDate = YESTERDAY
                                            OR CreatedDate = TODAY
                                            LIMIT : maxRows]);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        Map<String, OpportunityContactRole> conOppIdObjMap = new Map<String, OpportunityContactRole> ();
        Set<String> conIdSet = new Set<String> (); // String contactIds which added on Open Oppty
        for (OpportunityContactRole conOppRole : (List<OpportunityContactRole>) scope) {
            conOppIdObjMap.put (conOppRole.ContactId, conOppRole);
            if (!conOppRole.Opportunity.IsClosed)
                conIdSet.add (conOppRole.ContactId);
        } // End for

        // Update contact's lifecycle stage to "In Open Opportunity"
        List<Contact> conListToUpdate = new List<Contact> ();
        for (Contact conInstance : [SELECT Id, p2s_base1__LifecycleStage__c
                                        FROM Contact
                                        WHERE Id IN: conIdSet]) {
            conInstance.p2s_base1__LifecycleStage__c = STAGE_INOPENOPTY;
            conListToUpdate.add (conInstance);
        } // End for
        if (conListToUpdate.size ()> 0)
            Database.update(conListToUpdate, false);
    }

    global void execute(SchedulableContext SC) {
        UpdateContactLifecycleStageBatch updateConLifecycleStage = new UpdateContactLifecycleStageBatch();
        Id batchprocessid = Database.executeBatch(updateConLifecycleStage, 200);
    }

    global void finish(Database.BatchableContext BC) {
    } 
}