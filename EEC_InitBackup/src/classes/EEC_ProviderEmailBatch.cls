global class EEC_ProviderEmailBatch implements Database.Batchable<sobject> {
    public string query;
    global EEC_ProviderEmailBatch() {
      query='Select Id,name,Provider_Email__c from Account where Provider_Email__c !=null';
    }
   global Database.Querylocator start(Database.BatchableContext bc){
    return Database.getQuerylocator(query);
  }
  global Void execute(Database.BatchableContext bc,List<Sobject> scope){
    List<Account> AList = (List<Account>)scope;
    list<Account> UpdateList = new list<Account>();
    for(Account A : AList){
     A.Provider_Email__c = 'leadprovider@gmail.com';
     UpdateList.add(A);
    }
    if(!UpdateList.isempty()) 
   update UpdateList;
  }
  global Void finish(Database.BatchableContext bc){
    }
    
}