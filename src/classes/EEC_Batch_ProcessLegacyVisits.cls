//Author - Latha Davuluri
//Batch job to process Legacy Visits - LEAD-4231 & LEAD-4298

global class EEC_Batch_ProcessLegacyVisits implements Database.Batchable<sObject>{

    global List<EEC_HistoricalVisitStaging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,Name,EEC_ProgramId__c, EEC_LeadReasonOfVisit__c, EEC_VisitingLicensorId1__c, EEC_VisitId__c, EEC_Comment__c, EEC_VisitDate__c, EEC_ErrorText__c, EEC_ComplianceCodeDesc__c, EEC_Visit_Processed__c, EEC_DuplicateRule1__c,EEC_FCC_Mobile_Visit__c FROM EEC_HistoricalVisitStaging__c WHERE EEC_Visit_Processed__c = false]);
        
    }

    global void execute(Database.BatchableContext BC,List<EEC_HistoricalVisitStaging__c> scope){
    	
        dataListSize = scope;
        
        for(EEC_HistoricalVisitStaging__c v : scope){
        	try{
        	   EEC_ProcessLegacyVisitData.processLegacyVisits(v);
               v.EEC_Visit_Processed__c = true;  
        	}
        	catch(exception ex){
        		string errText = ex.getMessage();
        		if (errText.contains('List has no rows for assignment to SObject')){
        	        v.EEC_ErrorText__c = 'Provider Not Found in LEAD';
        		}
        		else{
        			v.EEC_ErrorText__c = ex.getMessage();
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
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyVisits'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_ProcessLegacyVisits batchLegacyVisits = new EEC_Batch_ProcessLegacyVisits();   
			        Id batchProcessId = Database.executeBatch(batchLegacyVisits,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_ProcessLegacyVisits batchLegacyVisits = new EEC_Batch_ProcessLegacyVisits();   
			             Id batchProcessId = Database.executeBatch(batchLegacyVisits,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyVisits'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_ProcessLegacyVisits job: ' + ex.getMessage());
    	}
    }

}