global class EEC_BatchFCCLicenseRenewal implements Database.Batchable <sObject>{
    
    String pQuery = '';
    global EEC_BatchFCCLicenseRenewal(String query)
    {
        this.pQuery =  query;
    }
    
    global EEC_BatchFCCLicenseRenewal()
    {
        this.pQuery =  'Select Id,Start_Renewal_Workflow__c,License_Status__c,Renewal_date__c,OwnerId,Provider_Status__c from Account  where License_Status__c = \'Licensed\' ' +
                                                               ' and Recordtype.Name = \'Family Child Care\'  ';
    }
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(pQuery);
    } 
     
    global void execute(Database.BatchableContext BC, List <Account> providerList)
    {
    
    
        Set<Id> provIds = new Set<Id>();
        Date cDate =  System.today();
        List<Account> providerupdatelist = new List<Account>();
        List<Task> providerTasks = new List<Task>();
                        
        for(Account provider : providerList){
            
            Task tsk = new Task();
            tsk.WhatId = provider.Id;
            tsk.OwnerId = provider.OwnerId;
            tsk.Status = 'Not Started';
            tsk.Priority = 'High';

          if(provider.Renewal_date__c != null && provider.Provider_Status__c != null)
          {                                                      
            if (cdate == provider.Renewal_date__c + 30 && !provider.Provider_Status__c.contains('freeze') ){
               
               tsk.Subject = 'Renewal Application Not Submitted - 30 days after expiration notice';
               tsk.ActivityDate = Date.today().addDays(2);
               tsk.Priority = 'Normal';
            }
            
            else{
                if (cdate == provider.Renewal_date__c ){
                   tsk.Subject = 'Renewal Application Not Submitted - On expiration date notice';
                   tsk.ActivityDate = Date.today().addDays(2);
                }
                else if (cdate == provider.Renewal_date__c - 30){
                   tsk.Subject = 'Renewal Application Not Submitted - 30 days prior expiration notice';
                   tsk.ActivityDate = Date.today().addDays(5);
                
                }
                
                else{
                 

                  
                  List<Licensing_Transaction__c>  r =[SELECT Id, Provider__c FROM Licensing_Transaction__c 
                                    WHERE Provider__c  = :provider.Id and Recordtype.Name = 'FCC Renewal' and (Submission_Date__c >= :cDate - 365 ) and
                                    status__c in ('Submitted','Under Review','Pending Manager Approval','Approved By Manager','Closed (License Issued / Updated)')];
                                   
                  
                  if ((provider.Renewal_date__c + 45 >= cDate) && (provider.Renewal_date__c -120 <= cDate) && r.size() == 0 && provider.License_Status__c == 'Licensed' && provider.Start_Renewal_Workflow__c == false ){                     

                     provider.Start_Renewal_Workflow__c = true;
                  }
                 else{
                     provider.Start_Renewal_Workflow__c = false;

                 }
                                                   
                  
                } 
             } 
             providerupdatelist.add(provider);
             providerTasks.add(tsk);
          }
             
         }
                       
        if (providerupdatelist <> null && providerupdatelist.size() > 0){
               
            Database.update(providerupdatelist);
            Database.insert(providerTasks);
        }
       
    }  
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
}