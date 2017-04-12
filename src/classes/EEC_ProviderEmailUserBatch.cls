global class EEC_ProviderEmailUserBatch implements Database.Batchable<sobject> {
	public string query;
	global EEC_ProviderEmailUserBatch() {
	  query='Select Id,name,Email from User where email !=null';
	}
   global Database.Querylocator start(Database.BatchableContext bc){
    return Database.getQuerylocator(query);
  }
  global Void execute(Database.BatchableContext bc,List<Sobject> scope){
    List<user> UList = (List<user>)scope;
    list<user> UpdateList = new list<user>();
    for(User U : UList){
     U.email = 'leaduser@gmail.com';
     UpdateList.add(U);
    }
    if(!UpdateList.isempty()) 
   update UpdateList;
  }
  global Void finish(Database.BatchableContext bc){
    }
    
}