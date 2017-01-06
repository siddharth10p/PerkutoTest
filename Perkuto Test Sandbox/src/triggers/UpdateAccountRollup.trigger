/**
 * Description: This trigger calls handler class to update roll up for Won Oppty
 * Copyright © Peruto Solutions Inc.
 *
 *      Author            Date(mm-dd-yyyy)     Version          Changelog
 * Siddharth Pandit        04-13-2016           1.0            Initial draft
 **/
trigger UpdateAccountRollup on Opportunity (after delete, after insert, after undelete, after update) {
	
    if (Trigger.isAfter && Trigger.isDelete)
    	AccRollupTriggerHandler.updateAccRollup (Trigger.oldMap);
    else
    	AccRollupTriggerHandler.updateAccRollup (Trigger.newMap);
}