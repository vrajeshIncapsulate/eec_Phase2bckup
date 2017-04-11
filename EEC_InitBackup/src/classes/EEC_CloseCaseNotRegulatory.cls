public with sharing class EEC_CloseCaseNotRegulatory {
    
    private Id cId;
    private Case c;
    private List<Task> tasks; 
   // private EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'X7_Notification_to_reporter_a_complaint_is_not_under_authority_of_EEC' LIMIT 1];
   // private Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
   // private User currentUser = [SELECT Email FROM User WHERE username = :UserInfo.getUserName() limit 1];
    
    public EEC_CloseCaseNotRegulatory(ApexPages.StandardController ctr){
        this.cId = (Id) ctr.getId();
        this.c = [SELECT Id, Contact.Name, Contact.Email, Status, Priority FROM Case WHERE Id = :cId]; 
        this.tasks = [SELECT Id FROM Task WHERE WhatId = :cId AND IsRecurrence = false AND Status != 'Completed'];
    }
    
    public PageReference close() {
        c.Status = 'Closed';
        c.Priority = 'Not regulatory in nature';
        upsert c;
        
        for(Task t : tasks){
            t.Status = 'Completed';
        }
        upsert tasks; 
      
        //START:- Mod by LD - Moved the Email/Task Creation logic to WorkFlow Rule - fix for BMMS-225
        /*
        if(c.Contact.Email != NULL && c.Contact.Email != ''){
     
            email.setToAddresses(new List<String> {c.Contact.Email});
            email.setTemplateId(template.Id);
            email.setTargetObjectId(c.Contact.Id);
            email.setWhatId(cId);
            //email.setReplyTo(currentUser.Email);
            email.setReplyTo('eecleaddonotreply@state.ma.us');
            //email.setSenderDisplayName(UserInfo.getFirstName() + ' ' + UserInfo.getLastName());
            email.setSenderDisplayName('EEC LEAD Alert eecleaddonotreply@state.ma.us');
            email.setSaveAsActivity(false);          
         
           // Messaging.SendEmailResult[] res = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        
           Task t = new Task(
                Subject = 'Email sent - Notification to reporter a complaint is not under authority of EEC - #7',
                Description = 'Email sent to the reporter as case does not concerned an area EEC has authority',
                Status = 'Completed', ActivityDate = System.Today(),  WhatId = cId
            );
            
            insert t;
            
        }
        */ //END
        
        return new PageReference('/' + cId);
    }
}