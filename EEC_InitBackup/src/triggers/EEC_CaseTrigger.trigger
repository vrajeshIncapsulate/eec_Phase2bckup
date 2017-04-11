trigger EEC_CaseTrigger on Case (before insert, after insert, before update,after update) {
    
    EEC_CaseTriggerHandler ect = new EEC_CaseTriggerHandler(Trigger.new, Trigger.oldMap);
    
    /*if(Trigger.isInsert){
        if(Trigger.isBefore){
           ect.updateCaseRegion();
        }
        
    }*/
    if(Trigger.isInsert || Trigger.isUpdate){
        if(EEC_CaseTriggerHandler.FirstRun ){
            ect.bulkBefore(); 
            if(Trigger.isBefore){
    			ect.updateCaseStatus();
				ect.updateCaseRegion();
            }
            else{
                ect.sendCaseEmail();
            }
            EEC_CaseTriggerHandler.FirstRun = false;
        }
    }
    
    if(Trigger.isUpdate && Trigger.isBefore && UserInfo.getUserType() == 'Standard'){
        if(EEC_CaseTriggerHandler.FirstRun || Test.isRunningTest()){
            ect.bulkBefore();
        	ect.updateApprovalManager();
        	ect.sendApprovalTriageResultEmail();
            EEC_CaseTriggerHandler.FirstRun = false;
        }
    }
}