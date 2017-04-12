global class EEC_BatchRestraintReport implements Database.Batchable <sObject>{
  
  String rrQuery = '';
  
  global EEC_BatchRestraintReport(String query)
    {
        this.rrQuery =  query;
    }
    
  global EEC_BatchRestraintReport()
    {
        this.rrQuery =  'Select Id,Restraint_Report_Automation__c from Account  where Use_Physical_Restraints__c = true' +
                                                               ' and Recordtype.Name in (\'Temporary Shelter\' ,\'Group Care\')';
    }
   
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(rrQuery);
    } 
     
    global void execute(Database.BatchableContext BC, List <Account> providerList)
    {
      
      List<Account> provs = new List<Account>();
      for(Account acc : ProviderList){
        Account account = new Account();
        account.id  = acc.Id;
        account.Restraint_Report_Automation__c = true;
        provs.add(account);

      }
      
      Database.update(provs);
    }
    
    global void finish(Database.BatchableContext BC)
    {
    
    }
}