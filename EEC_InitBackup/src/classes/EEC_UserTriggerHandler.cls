public with sharing class EEC_UserTriggerHandler {
	
	List<User> newList;
	Map<Id,User> oldMap;
	Map<Id,Account> accountMap;
	Set<Id> hasActiveUsers;
	
	public EEC_UserTriggerHandler(List<User> newList,Map<Id,User> oldMap){
		this.newList = newList;
		this.oldMap = oldMap;
	}
	
	public void bulkAfter(){
		
		Set<Id> accountIds = new Set<Id>();
		hasActiveUsers = new Set<Id>();
		
		for(User usr :newList){
			if(usr.AccountId != null){
				accountIds.add(usr.AccountId);
			}
		}
		
		if(accountIds != null && accountIds.size() > 0){
			accountMap = new Map<Id,Account>([select Id,Electronic_Communication__c,Provider_Email__c,OwnerId from Account where Id in :accountIds]);
			for(User usr :[select Id,isActive,IsPortalEnabled,AccountId from User where AccountId in :accountIds and isActive = true]){
				hasActiveUsers.add(usr.AccountId);
			}
		}
		
	}
	
	public void updateActiveAccounts(){
		List<Account> updateAccounts = new List<Account>();
		Account newAccnt;
		Boolean sUpdate = false;
		for(User usr :newList){
			if(usr.IsPortalEnabled && usr.AccountId != null && usr.isActive){
				newAccnt = accountMap.get(usr.AccountId);
				sUpdate = false;
				if(!newAccnt.Electronic_Communication__c){
					newAccnt.Electronic_Communication__c = true;
					sUpdate = true;
				}
				if(String.isBlank(newAccnt.Provider_Email__c)){
					newAccnt.Provider_Email__c = usr.Email;
					sUpdate = true;
				}
				if(sUpdate){
					updateAccounts.add(newAccnt);
				}
			}
		}
		if(updateAccounts != null && updateAccounts.size() > 0){
			try{
				update updateAccounts;
				} catch(Exception e){
					System.debug(e);
				}
			
		}
	}
	
	public void updateInActiveAccounts(){
		Account newAccnt;
		User oldUsr;
		Map<Id,Id> accntIdMap = new Map<Id,Id>();
		for(User usr :newList){
			oldUsr = oldMap.get(usr.Id);
			if(oldUsr.IsPortalEnabled && oldUsr.isActive && !usr.isActive){
				newAccnt = accountMap.get(oldUsr.AccountId);
				if(hasActiveUsers == null || newAccnt.Provider_Email__c == usr.Email || !hasActiveUsers.contains(usr.AccountId)){
					accntIdMap.put(newAccnt.Id,newAccnt.OwnerId);
				}
			}
		}
		if(accntIdMap != null && accntIdMap.size() > 0){
			createTasks(accntIdMap);
		}
	}
	
	@future
	public static void createTasks(Map<Id,Id> accntIdMap){
		List<Task> insertTasks = new List<Task>();
		
		for(Id accntId : accntIdMap.keySet()){
			Task tsk = new Task();
			tsk.Subject = 'Electronic Communication Issue on Provider';
			tsk.Description = 'Please check one these 2 cases may have happen: this provider has "Electronic Communication" checked but no more active Portal user, or the email address of the provider is associated to a non-active Portal user';
			tsk.Priority = 'Normal';
			tsk.ActivityDate = Date.today().addDays(3);
			tsk.Status = 'Not Started';
			tsk.OwnerId = accntIdMap.get(accntId);
			tsk.WhatId = accntId;
			insertTasks.add(tsk);
		}
		
		insert insertTasks;
	}
}