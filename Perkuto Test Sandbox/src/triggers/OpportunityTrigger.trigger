/**
 * Description: Oppty trigger to update lifecycle stage on contact
 * 
 *    Author           Date (mm-dd-yyyy)  Version    Changelog
 * Siddharth Pandit    11/29/2016           1.0      Inital draft
 *
 * LP URL: /space/118974/projects/show/34104057
 * Test class name: 
 *
 **/
trigger OpportunityTrigger on Opportunity (after insert, after update) {
    OpptyTriggerHandler.updateLifecycleReason (Trigger.newMap);
}