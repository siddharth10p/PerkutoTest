/**
 * Description: This trigger will allign Contact owner with account's owner when an owner is
 * updated on Account object.
 * Copyright © Peruto Solutions Inc.
 *
 *      Author            Date(mm-dd-yyyy)     Version          Changelog
 * Siddharth Pandit        10-14-2016           1.0            Initial draft
 * LP URL- /space/118974/projects/show/33772397P
 **/
trigger AccountTrigger on Account (after update) {
    ContactTriggerHandler.updateChildRecOwner (Trigger.oldMap, Trigger.newMap);
}