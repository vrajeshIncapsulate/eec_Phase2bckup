//Author - Latha Davuluri
//Batch job to process Legacy Visits - LEAD-4231 & LEAD-4298

global class EEC_Batch_ProcessLegacyVisitItems implements Database.Batchable<sObject>{

    global List<EEC_HistoricalVisitItemStaging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, EEC_HeaderVisit__c, EEC_HeaderVisitItem__c, EEC_Comment__c, EEC_VisitDetailId__c, EEC_RegGroupItem__c, EEC_RegGroupItemDesc__c, EEC_ComplianceStatusDesc__c, EEC_VisitItem_Processed__c  FROM EEC_HistoricalVisitItemStaging__c WHERE EEC_VisitItem_Processed__c = false]);
        
    }

    global void execute(Database.BatchableContext BC,List<EEC_HistoricalVisitItemStaging__c> scope){
    	
        dataListSize = scope;
        
        for(EEC_HistoricalVisitItemStaging__c vi : scope){
        	try{
        	   EEC_ProcessLegacyVisitData.processLegacyVisitItems(vi);
               vi.EEC_VisitItem_Processed__c = true;  
             }
        	catch(exception ex){
        		string errText = ex.getMessage();
        		if (errText.contains('List has no rows for assignment to SObject')){
        	        vi.EEC_ErrorText__c = 'Visit Not Found in LEAD';
        		}
        		else{
        			vi.EEC_ErrorText__c = ex.getMessage();
        		}
        		
        	}
        	           
        }
       
        update scope; 
        
    }

    global void finish(Database.BatchableContext BC){
    	
    	try{
	    	if(dataListSize != null){
		    	AsyncApexJob batchJob = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
	       
		        Integer jobs = [Select count() From AsyncApexJob Where JobType = 'BatchApex' and ( Status = 'Queued' or Status = 'Processing' or Status = 'Preparing' )];   
		        
		        if(jobs <= 1){
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyVisitItems'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_ProcessLegacyVisitItems batchLegacyVisitItems = new EEC_Batch_ProcessLegacyVisitItems();   
			        Id batchProcessId = Database.executeBatch(batchLegacyVisitItems,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_ProcessLegacyVisitItems batchLegacyVisitItems = new EEC_Batch_ProcessLegacyVisitItems();   
			             Id batchProcessId = Database.executeBatch(batchLegacyVisitItems,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyVisitItems'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_ProcessLegacyVisitItems job: ' + ex.getMessage());
    	}
    }

}