//Author - Latha Davuluri
//Batch job to process Legacy Non-Compliance Visit Items for the Visits created PART2 - LEAD-4299
	
global class EEC_Batch_ProcessLegacyNonCompVisitItems implements Database.Batchable<sObject>{

    global List<EEC_HistoryOfNonComplianceStaging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Name, ProgramId__c,VisitItem_Processed__c, ErrorText2__c, InvestigationType__c, Observations__c, LicensorOfInteraction__c, InteractionTypeDesc__c,InteractionDate__c, InteractionId__c, CorrectionPlan__c, Citation__c, DuplicateRule1__c FROM EEC_HistoryOfNonComplianceStaging__c WHERE VisitItem_Processed__c = false and Visit_Processed__c = true]);
        
    }

    global void execute(Database.BatchableContext BC,List<EEC_HistoryOfNonComplianceStaging__c> scope){
    	
        dataListSize = scope;
        
        for(EEC_HistoryOfNonComplianceStaging__c v : scope){
        	try{
        		if(String.isNotBlank(v.InvestigationType__c)){
        			EEC_ProcessLegacyVisitData.processLegacyInvestigationAddionalNonComplianceItems(v);
        		} else {
        			EEC_ProcessLegacyVisitData.processLegacyNonComplianceVisitItems(v);
        		}
            v.VisitItem_Processed__c = true;  
      		}
        	catch(exception ex){
        		string errText = ex.getMessage();
        		v.ErrorText2__c = ex.getMessage();      		
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
		            EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyNonCompVisitItems'); 
		        }
		
		        //If NumberOfErrors is "0" - if the execute method processed all records without errors - then call next contact batch.
			    if (batchJob.NumberOfErrors == 0)
			    {     
			        EEC_Batch_ProcessLegacyNonCompVisitItems batchLegacyNonCompVisitItems = new EEC_Batch_ProcessLegacyNonCompVisitItems();   
			        Id batchProcessId = Database.executeBatch(batchLegacyNonCompVisitItems,1);    //finish method logic here
			    }
			    else
			    {
			        //process other code
			        if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
		
		        		 EEC_Batch_ProcessLegacyNonCompVisitItems batchLegacyNonCompVisitItems = new EEC_Batch_ProcessLegacyNonCompVisitItems();   
			             Id batchProcessId = Database.executeBatch(batchLegacyNonCompVisitItems,1);    //finish method logic here
		         		}
		        	else{
		         		//wait for 1 hour
		          	}
			    }
	         }
	         else{
	         	EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyNonCompVisitItems'); 
	         }
    	}
    	catch(exception ex){
    		System.debug('----> Error Processing the EEC_Batch_ProcessLegacyNonCompVisitItems job: ' + ex.getMessage());
    	}
    }

}