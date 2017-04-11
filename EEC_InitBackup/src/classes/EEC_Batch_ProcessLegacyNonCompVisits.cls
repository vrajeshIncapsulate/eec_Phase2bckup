//Author - Latha Davuluri
//Batch job to process Legacy Non-Compliance Visits - PART 1 - LEAD-4299
    
global class EEC_Batch_ProcessLegacyNonCompVisits implements Database.Batchable<sObject>{

    global List<EEC_HistoryOfNonComplianceStaging__c> dataListSize = null;
      
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Name, ProgramId__c,Visit_Processed__c, ErrorText__c, InvestigationType__c, Observations__c, LicensorOfInteraction__c, InteractionTypeDesc__c,InteractionDate__c, InteractionId__c, CorrectionPlan__c, Citation__c, DuplicateRule1__c, IntakeID__c FROM EEC_HistoryOfNonComplianceStaging__c WHERE Visit_Processed__c = false]);
        
    }

    global void execute(Database.BatchableContext BC,List<EEC_HistoryOfNonComplianceStaging__c> scope){
        
        dataListSize = scope;
        
        for(EEC_HistoryOfNonComplianceStaging__c v : scope){
            try{
               if(String.isNotBlank(v.InvestigationType__c)){
                    EEC_ProcessLegacyVisitData.processLegacyInvestigations(v);
                } else{
                    EEC_ProcessLegacyVisitData.processLegacyNonComplianceVisits(v);
                }

                v.Visit_Processed__c = true;  
            }
            catch(exception ex){
                string errText = ex.getMessage();
                if (errText.contains('List has no rows for assignment to SObject')){
                    v.ErrorText__c = 'Provider Not Found in LEAD';
                }
                else{
                    v.ErrorText__c = ex.getMessage();
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
                    EEC_Batch_ProcessLegacyNonCompVisits batchLegacyNonCompVisits = new EEC_Batch_ProcessLegacyNonCompVisits();   
                    Id batchProcessId = Database.executeBatch(batchLegacyNonCompVisits,1);    //finish method logic here
                }
                else
                {
                    //process other code
                    if ((batchJob.NumberOfErrors == 0) && (jobs < 5)){
        
                         EEC_Batch_ProcessLegacyNonCompVisits batchLegacyNonCompVisits = new EEC_Batch_ProcessLegacyNonCompVisits();   
                         Id batchProcessId = Database.executeBatch(batchLegacyNonCompVisits,1);    //finish method logic here
                        }
                    else{
                        //wait for 1 hour
                    }
                }
             }
             else{
                EEC_Util.batchEmailSuccess(bc, 'EEC_Batch_ProcessLegacyNonComplianceItem'); 
             }
        }
        catch(exception ex){
            System.debug('----> Error Processing the EEC_Batch_ProcessLegacyNonCompVisits job: ' + ex.getMessage());
        }
    }

}