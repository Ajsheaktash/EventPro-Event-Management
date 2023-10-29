public class EventSummaryController {
    public static  Map<String, Integer> getTaskStatusSummary(String id) {
        Map<String, Integer> taskStatusSummary = new Map<String, Integer>();
        // Write SOQL query and aggregate function here
        // Use GROUP BY to group results by Task_Status__c
        
        // Use COUNT() to calculate task counts
        List<AggregateResult> results = [SELECT Status, COUNT(Id)
                                         FROM Task
                                         GROUP BY Status];
        for (AggregateResult ar : results) {
            String status = (String)ar.get('status');
            Integer count = (Integer)ar.get('count');
            taskStatusSummary.put(status, count);
        }
        
        return taskStatusSummary;
    }
    public static List<Event_Task__c> getOpenTasks(String id) {
        List<Event_Task__c> openTasks = new List<Event_Task__c>();
        // Write SOQL query to fetch open tasks
        // Use WHERE to filter tasks by status "Not Started"
        // Use ORDER BY to sort tasks by Due_Date__c in descending order
        openTasks = [SELECT Id, Name, Due_Date__c, Task_Status__c
                     FROM Event_Task__c
                     WHERE Task_Status__c = 'Not Started'
                     ORDER BY Due_Date__c DESC]; 
        
        return openTasks;
    } 
    
    public static Map<String, Decimal> getExpensesByCategory(String id) {
        Map<String, Decimal> expensesByCategory = new Map<String, Decimal>();
        // Write SOQL query and aggregate function here
        // Use GROUP BY to group results by Category__c
        // Use SUM() to calculate total expenses
        List<AggregateResult> results = [SELECT Category__c category, SUM(Amount__c) totalExpense
                                         FROM Event_Expense__c
                                         GROUP BY Category__c];  
        
        for (AggregateResult ar : results) {
            String category = (String)ar.get('category');
            Decimal totalExpense = (Decimal)ar.get('totalExpense');
            expensesByCategory.put(category, totalExpense);
        } 
        return expensesByCategory;
    }
    
    public static Event_Expense__c getMostExpensiveExpense(String id) {
        Event_Expense__c mostExpensiveExpense;
        // Write SOQL query here
        // Use ORDER BY to sort expenses by Amount__c in descending order
        // Use LIMIT to retrieve only one record
        List<Event_Expense__c> expenses = [SELECT Id, Name, Amount__c
                                           FROM Event_Expense__c
                                           ORDER BY Amount__c DESC
                                           LIMIT 1];
        
        if (!expenses.isEmpty()) {
            mostExpensiveExpense = expenses[0];
        }
        
        return mostExpensiveExpense;
    }
}