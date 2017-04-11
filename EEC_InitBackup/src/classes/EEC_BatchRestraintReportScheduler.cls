global class EEC_BatchRestraintReportScheduler implements schedulable {
  
  public void execute (SchedulableContext sc) {
    
   
    EEC_BatchRestraintReport rr = new EEC_BatchRestraintReport('Select Id,Restraint_Report_Automation__c from Account  where Use_Physical_Restraints__c = true' +
                                                               ' and Recordtype.Name in (\'Temporary Shelter\' ,\'Group Care\')');
    id boccemea = database.executebatch(rr,10);
  }
  
}