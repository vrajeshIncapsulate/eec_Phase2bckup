global class EEC_ProviderEmailContactBatch implements Database.Batchable<sobject> {
	
	public string query;
	global EEC_ProviderEmailContactBatch() {
	  query='Select Id,name,Email from contact where email!=null';
	} 
   global Database.Querylocator start(Database.BatchableContext bc){
    return Database.getQuerylocator(query);
  }
  global Void execute(Database.BatchableContext bc,List<Sobject> scope){
    List<contact> ConList = (List<contact>)scope;
    list<contact> UpdateList = new list<contact>();
    for(Contact C : ConList){
     C.email = 'leadcontact@gmail.com';
     UpdateList.add(C);
    }
    if(!UpdateList.isempty()) 
   update UpdateList;
  }
  global Void finish(Database.BatchableContext bc){
    }
}