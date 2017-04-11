global class EEC_InvestigationCorrectionAction implements Database.Batchable <sObject>{
	
	String caQuery = '';
	
	global EEC_InvestigationCorrectionAction(String query)
    {
        this.caQuery =  query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(caQuery);
    } 
     
    global void execute(Database.BatchableContext BC, List <Investigation__c> investList)
    {
    	List<Task> visitTaks = new List<Task>();
    	Set<Id> investSet = new Set<Id>();
    	
    	for(Investigation__c invest : investList){
    		if(invest.Non_Compliant_Item__r != null && invest.Non_Compliant_Item__r.size() > 0){
	    		Task tsk = new Task();
	    		tsk.WhatId = invest.Id;
	    		tsk.OwnerId = invest.Provider_No__r.OwnerId;
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

//feedback requested = true