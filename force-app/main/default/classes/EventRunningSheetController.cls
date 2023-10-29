/**
 * @description       : 
 * @author            : Ajshe Aktash
 * @group             : 
 * @last modified on  : 10-29-2023
 * @last modified by  : Ajshe Aktash
**/
public with sharing class EventRunningSheetController {
    @AuraEnabled(cacheable=true)
    public static Event_Plan__c getEventDetails(String recordId) {
        // Use SOQL query to retrieve event details, including Event Name and Event Date
        return [SELECT Name, Event_Date__c , Event_Name__c FROM Event_Plan__c WHERE Id = :recordId  LIMIT 1];
    }

    @AuraEnabled(cacheable=true)
    public static List<Event_Task__c> getTasks(String recordId) {
        // Use SOQL query to retrieve task records, including Task Name, Due Date, and Assigned To
        return [SELECT Task_Name__c, Due_Date__c, Assigned_To__c FROM Event_Task__c WHERE Event_Plan__c = :recordId ORDER BY Due_Date__c];
    }
}