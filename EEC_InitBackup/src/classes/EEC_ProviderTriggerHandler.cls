public with sharing class EEC_ProviderTriggerHandler {
    private List<Account> newProviders = new List<Account>();
    private Map<Id, Account> oldProviders = new Map<Id, Account>();
    private List<Lead_Configuration__c> configRecords = [SELECT Id, Name FROM LEAD_Configuration__c];
    private Map<Id, RecordType> recordTypes = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE sObjectType = 'Account']);
    
    public EEC_ProviderTriggerHandler(List<Account> newList, Map<Id,Account> oldMap){
        this.newProviders = newList;
        this.oldProviders = oldMap;
    } 
    public void updateConfigRecord(){
        for(Account p : newProviders){
            Account oldProvider = oldProviders.get(p.Id);
            
            //If its a new record, if the value has changed
            if(oldProvider == null || p.RecordTypeId != oldProvider.RecordTypeId){
                p.Config_Record__c = null;
                
                for(Lead_Configuration__c config : configRecords){
                    if(config.Name == recordTypes.get(p.RecordTypeId).Name){
                        p.Config_Record__c = config.Id;
                        break;
                    }
                }
            }
        }
    }
    
    public void updateProviderRegion(){
    	List<Account> newList = new List<Account>();
    	Set<Id> ownerIdSet = new Set<Id>();
    	Set<String> regionSet = new Set<String>();
        System.debug('New Providers' + newProviders);
        //System.debug('Old Providers' + oldProviders);
    	for(Account p : newProviders){
    		Account oldProvider = oldProviders.get(p.Id);
            System.debug('Old Provider' + oldProvider);
    		if(oldProvider != null){
    			newList.add(p);
    			ownerIdSet.add(p.OwnerId);
    		}
    	}
        
    	System.debug('Owner ID Set' + ownerIdSet);
    	Map<Id, User> userMap = new Map<Id,User>([select Id,Region__c from User where Id in :ownerIdSet]);
    	for(User usr : userMap.values()){
    		if(String.isNotBlank(usr.Region__c)){
    			regionSet.add(usr.Region__c);
    		}
    	}
        System.debug('User Map' + userMap);
    	if(regionSet != null && regionSet.size() > 0){
    		Map<String, Region__c> regionMap = new Map<String,Region__c>();
	    	for(Region__c reg : [select Id,name from Region__c where name in :regionSet]){
	    		regionMap.put(reg.name, reg);
	    	}
	    	System.debug('Region Map' + regionMap);
	    	User tUsr;
	    	Region__c tReg;
	    	for(Account np : newList){
	    		//Mod by LD:-Don't change the Region for these Unlicesend Providers(BUCKET Accounts)
	    		if(!(np.Name.contains('Unlicensed Provider -')) && np.Region__c == null){
		    		tUsr = userMap.get(np.OwnerId);
		    		if(String.isNotBlank(tusr.Region__c)){
		    			treg = regionMap.get(tusr.Region__c);
		    			if(tReg != null){
		    				np.Region__c = tReg.Id;
		    			}
		    		}
	    		}//end if
	    	}//end for
    	}
    }
}