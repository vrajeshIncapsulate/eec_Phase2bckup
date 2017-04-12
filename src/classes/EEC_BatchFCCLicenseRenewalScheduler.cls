global class EEC_BatchFCCLicenseRenewalScheduler implements schedulable {
  
  public void execute (SchedulableContext sc) {
    
   
    EEC_BatchFCCLicenseRenewal fr = new EEC_BatchFCCLicenseRenewal('Select Id,License_Status__c,Start_Renewal_Workflow__c,Renewal_date__c,OwnerId,Provider_Status__c from Account  where License_Status__c = \'Licensed\' ' +
                                                               ' and Recordtype.Name = \'Family Child Care\'  ');
    id boccemea = database.executebatch(fr,10);
  }
  
}