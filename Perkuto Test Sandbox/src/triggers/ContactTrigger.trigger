/**
 * Description: This trigger will allign owner with account owner when a new record 
 * on Account object.
 * Copyright © Peruto Solutions Inc.
 *
 *      Author            Date(mm-dd-yyyy)     Version          Changelog
 * Siddharth Pandit        10-14-2016           1.0            Initial draft
 * LP URL- /space/118974/projects/show/33772397P
 **/
trigger ContactTrigger on Contact (before insert, before update) {
    ContactTriggerHandler.updateRecordOwner (Trigger.new);
}