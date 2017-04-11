global class EEC_CorrectionAction implements Database.Batchable <sObject>{
	
	String caQuery = '';
	
	global EEC_CorrectionAction(String query)
    {
        this.caQuery =  query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(caQuery);
    } 
     
    global void execute(Database.BatchableContext BC, List <Inspection__c> visitList)
    {
    	
    	List<Task> visitTaks = new List<Task>();
    	for(Inspection__c visit : visitList){
    		System.debug('*******12 -- '+visit.Number_of_non_compliant_items__c+' -- '+visit.Number_of_Items_with_Corrective_Actions__c);
    		if(visit.Number_of_non_compliant_items__c != visit.Number_of_Items_with_Corrective_Actions__c){
	    		Task tsk = new Task();
	    		tsk.WhatId = visit.Id;
	    		tsk.OwnerId = String.isNotBlank(visit.Inspector_del__c)?visit.Inspector_del__c:visit.Provider_No__r.OwnerId;
	    		tsk.Subject = 'Corrective Action Not Received on Deadline';
	    		tsk.ActivityDate = Date.today().addDays(1);
	    		tsk.Status = 'Not Started';
	    		tsk.Priority = 'High';
	    		visitTaks.add(tsk);
    		}
    	}
    	
    	Database.insert(visitTaks);
    }
    
    global void finish(Database.BatchableContext BC)
    {
		
    }
}