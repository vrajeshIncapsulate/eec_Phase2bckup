public with sharing class EEC_ContactTriggerHandler {
    
    public List<Contact> ct {get; set;}
    public List<Contact> newC {get; set;}
    public Map<Id,Contact> oldC {get; set;}
    private static list<case> caselist = new list<case> ();
    //private string contactid;
        
	public EEC_ContactTriggerHandler(List<Contact> newListC, Map<Id,Contact> oldMapC){
        this.newC = newListC;
        this.oldC = oldMapC;
	}
    
    public void createTransaction(){
        User portalUser = [SELECT Id, IsPortalEnabled, UserType  FROM USER WHERE Id =: Userinfo.getUserId() LIMIT 1];
        if(portalUser.UserType == 'PowerCustomerSuccess' || portalUser.UserType == 'CustomerSuccess'){
        Id fccRecordTypeId = EEC_RecordTypeUtil.findByName('ACCOUNT.FCC').Id;
        
        for(Contact newContact : newC){
            Contact oldContact = oldC.get(newContact.id);
            
            Account provider = [SELECT Id, Recordtype.Name, RecordTypeId FROM Account 
                                WHERE ID IN (SELECT AccountId FROM user WHERE id = :Userinfo.getUserId()) LIMIT 1];
            
            
            if((oldContact.FirstName != newContact.FirstName || 
               oldContact.LastName != newContact.LastName) && fccRecordTypeId == provider.RecordTypeId &&
              (portalUser.IsPortalEnabled == true || portalUser.UserType == 'PowerCustomerSuccess')){
                  
                Licensing_Transaction__c lt = new Licensing_Transaction__c();
                
                lt.RecordTypeId = EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_Change_of_Name').Id;
                lt.Prior_First_Name__c = oldContact.FirstName;
                lt.Prior_Last_Name__c = oldContact.LastName;
                lt.New_First_Name__c = newContact.FirstName;
                lt.New_Last_Name__c = newContact.LastName;
                lt.Proposed_New_Provider_Name__c = newContact.FirstName + ' ' + newContact.LastName;
                lt.Provider__c = oldContact.AccountId;
                lt.Status__c = 'Submitted';
                lt.Submission_Date__c = Date.today();
                lt.Submitter__c = Userinfo.getUserId();
                lt.Source__c = 'Provider Portal';
                
                insert lt;
            	}
        	}
        }
    }
   public list<case> contactcaselist(string contactid){
     if(contactid!=null)	
     caselist =[select id,Contactid,Foster_Parent__c from case where contactid =: contactid];
    
     return caselist;
    
    }
    public void AccountMandatory(){
    	 for(contact c : newC){
    	 	system.debug('MMMM'+contactcaselist(c.id).size()+c.id);
         if(contactcaselist(c.id).size()==0 && c.accountid == null)
         
           c.adderror('All Contacts must have either an Associated Case or Provider Name');
       }
    }
}