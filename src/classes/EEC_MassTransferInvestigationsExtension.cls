public with sharing class EEC_MassTransferInvestigationsExtension {
	public List<User> transferToUserList { get; set;}
	public List<Investigation__c> invSelected { get; set;}
	public User transferToUserSelected { get; set;}
	public List<SelectOption> transferToOptionsDisplay {get; set;}
	public String selectedUserId {get; set;}
	public String selectedBackup {get; set;}
	public Boolean transferAllowed {get; set;}
	public String invObjectId {get; set;}
	ApexPages.StandardSetController setCon;

	public EEC_MassTransferInvestigationsExtension(ApexPages.StandardSetController controller) {
		setCon = controller;
		selectedUserId = null;
		selectedBackup = null;
		transferAllowed = true;
		//Get 3 digit object key to navaigate back to investigations tab.
		Schema.DescribeSObjectResult dsr = Investigation__c.sObjectType.getDescribe();
		invObjectId = dsr.getKeyPrefix();
		//Verify if user has appropriate role to proceed with mass transfer.
		List<String> allowedRoles = new List<String>{'Executive and Directors', 'Program Supervisor', 'Regional Director', 'Associate Commissioner of Investigation'};
		Set<ID> allowedRoleIdSet = (new Map<Id, UserRole>([Select id, Name From UserRole Where Name IN :allowedRoles])).keySet();
		if(!allowedRoleIdSet.contains(UserInfo.getUserRoleId())){
			transferAllowed = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You are not authorized to use this feeature. Please contact your supervisor.'));
			return;
		}
		//Get the list of investigations selected from the list view
		Set<id> invSelectedIds = (new Map<Id, Investigation__c>((Investigation__c[])setCon.getSelected())).keySet();
		//Excluding investigations that are locked by offline app or investigation mode as it means they are in progress.
		invSelected = [SELECT ID, Name, Assigned_To_Id__c, Provider_No__c
												, Investigation_Status__c 
											FROM Investigation__c 
											WHERE ID IN :invSelectedIds];
		//Build list of user id's that need to be excluded from the list of transfer to user options
		Set<Id> transferFromUserIds = new Set<Id>();
		for(Investigation__c v : invSelected){
			if(v.Investigation_Status__c != 'Assigned - In Progress'){
				transferAllowed = false;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Only investigations that are "Assigned - In Progress" can be transferred. Please update your selection.'));
				break;
			}
			transferFromUserIds.add(v.Assigned_To_Id__c);
		}

		transferToUserList = [SELECT ID, Name, UserRole.Name, UserType, Username 
													FROM User 
													WHERE UserType = 'Standard' AND isActive = true 
														AND ID NOT IN :transferFromUserIds
														AND UserRole.Name NOT IN ('Admin', 'Executive and Directors', ''
														, 'Program Supervisor', 'Regional Director', 'Associate Commissioner of Investigation')];
		transferToOptionsDisplay = new List<SelectOption>();
		transferToOptionsDisplay.add(new SelectOption('select', 'Select...'));
		for(User u : transferToUserList){
			transferToOptionsDisplay.add(new SelectOption(u.id, u.Name));
		}
	}
	public pageReference massTransferinvestigations(){
		List<Investigation__c> investigationToBeUpdate = new List<Investigation__c>();
		if(selectedUserId == 'select' && selectedBackup == 'select'){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please make a selection.'));
			return null;
		}
		for(Investigation__c investigation : invSelected){
			if(selectedUserId != 'select'){
				investigation.Assigned_To__c = selectedUserId;
			}
			if(selectedBackup != 'select'){
				investigation.Backup__c = selectedBackup;
			}
			investigationToBeUpdate.Add(investigation);
		}
		Update investigationToBeUpdate;
		//Update open activities if "Assign To" field is updated
		if(selectedUserId != 'select'){
			Set<Id> investigationIdSet = (new Map<Id, Investigation__c>(investigationToBeUpdate)).keySet();
			List<Task> tasksOpen = [SELECT ID, Status, OwnerId, WhatID 
																			FROM Task 
																			WHERE WhatId IN :investigationIdSet AND Status != 'Completed'];
			List<Task> tasksToBeUpdated = new List<Task>();
			for(Task t : tasksOpen){
				t.OwnerId = selectedUserId;
				tasksToBeUpdated.add(t);
			}
			Update tasksToBeUpdated;
		}
		PageReference pageRef = new PageReference('/' + invObjectId);
		return pageRef;
	}
	public pageReference goBackToinvestigationsTab(){
		PageReference pageRef = new PageReference('/' + invObjectId);
		return pageRef;
	}
}