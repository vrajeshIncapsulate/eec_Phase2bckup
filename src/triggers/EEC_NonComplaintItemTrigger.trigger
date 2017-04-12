trigger EEC_NonComplaintItemTrigger on Non_Compliant__c (before insert, before update, after update) {

   EEC_NonComplaintItemTriggerHandler nocomp = new EEC_NonComplaintItemTriggerHandler(trigger.new,trigger.OldMap);
   if (Trigger.isUpdate && Trigger.isAfter) {
      nocomp.updateRequireFeedback();
      nocomp.SubmissionHistory();
   }
   if(Trigger.isBefore){
       nocomp.updateStatus();
   }
   /*else if(Trigger.isinsert && Trigger.isAfter){ 
     nocomp.SubmissionHistory();
   }*/
   
}