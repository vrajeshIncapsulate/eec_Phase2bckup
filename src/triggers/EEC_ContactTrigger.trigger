trigger EEC_ContactTrigger on Contact (before insert,before update) {
    
        EEC_ContactTriggerHandler ch = new EEC_ContactTriggerHandler(Trigger.New, Trigger.oldMap);
        
        /*if(trigger.isinsert){
        
        ch.AccountMandatory();
        }*/
        if(trigger.isupdate){
	        ch.createTransaction();
	        ch.AccountMandatory();
        }

}