public class EventTaskHealthCheckTriggerHandler {
    
    public  void handlerAfterInsert(List<Event_Task__c> newEventTasks) {
        // Logic for after insert operation
        // Call the updateEventFlags method and pass newEventTasks
        updateEventFlags(newEventTasks);
    }
    
    public  void handlerAfterUpdate(List<Event_Task__c> newEventTasks, Map<Id, Event_Task__c> oldEventTasks) {
        // Logic for after update operation
        // Call the updateEventFlags method and pass newEventTasks
        // Additional logic if needed
        updateEventFlags(newEventTasks);
    }
    
    public  void handlerAfterDelete(List<Event_Task__c> deletedEventTasks) {
        // Logic for after delete operation
        // Call the updateEventFlags method and pass deletedEventTasks with a flag for delete
        // Additional logic if needed
        updateEventFlags(deletedEventTasks);
    }
    public void callupdate(List<Event_Task__c> eventTasks){
        updateEventFlags(eventTasks);
    }
    private void updateEventFlags(List<Event_Task__c> eventTasks) {
        // Your existing logic here
        Integer openTaskCount = 0;
        Integer totalTaskCount = 0;
        
        
        list<Event_Plan__c> planDate=[Select id, Event_Date__c,Event_Flag__c From Event_Plan__c] ;
        /*
         we can create 'planDate' list by using this query as well,but when we use the differences between two days 
		 as integer,we can use the list value like boolean as empty or not
		 in the line58 (Boolean isCritical = openTaskPercentage > 50 && daysDifference <= 7  ;) instead of 'daysDifference'.

         SELECT id, Event_Date__c, Event_Flag__c
		 FROM Event_Plan__c
		 WHERE Event_Date__c >= TODAY
		 AND Event_Date__c <= NEXT_N_DAYS:7


		*/
        
        for (Event_Task__c task : eventTasks) {
            totalTaskCount++;
            if (task.Task_Status__c == 'Not Started'|| task.Task_Status__c == 'In Progress') {
                openTaskCount++;
            }
        }
        
        list<Event_Plan__c> topL = new list<Event_Plan__c>();
        Date currentDate = Date.today();
          for(Event_Plan__c pd:planDate) { 
            if (pd.Event_Date__c != null) {
                Decimal openTaskPercentage = (openTaskCount * 100) / totalTaskCount;
                 Integer daysDifference = pd.Event_Date__c.date().daysBetween(currentDate);
                 
                Boolean isCritical = openTaskPercentage > 50 && daysDifference <= 7  ;
                if (isCritical) {
                    pd.Event_Flag__c ='Critical';
                    topL.add(pd);
                } 
            }
        }
        update topL;
    }
}