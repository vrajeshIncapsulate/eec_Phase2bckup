public with sharing class EEC_MassTransferVisitsExtension {
	public List<User> transferToUserList { get; set;}
	public List<Inspection__c> visitsSelected { get; set;}
	public User transferToUserSelected { get; set;}
	public List<SelectOption> transferToOptionsDisplay {get; set;}
	public String selectedUserId {get; set;}
	public String selectedAdditionalStaff {get; set;}
	public Boolean transferAllowed {get; set;}
	public String visitObjectId {get; set;}
	ApexPages.StandardSetController setCon;

	public EEC_MassTransferVisitsExtension(ApexPages.StandardSetController controller) {
		setCon = controller;
		selectedUserId = null;
		selectedAdditionalStaff = null;
		transferAllowed = true;
		//Get 3 digit object key to navaigate back to visits tab.
		Schema.DescribeSObjectResult dsr = Inspection__c.sObjectType.getDescribe();
		visitObjectId = dsr.getKeyPrefix();
		//Verify if user has appropriate role to proceed with mass transfer.
		List<String> allowedRoles = new List<String>{'Executive and Directors', 'Program Supervisor', 'Regional Director'};
		Set<ID> allowedRoleIdSet = (new Map<Id, UserRole>([Select id, Name From UserRole Where Name IN :allowedRoles])).keySet();
		if(!allowedRoleIdSet.contains(UserInfo.getUserRoleId())){
			transferAllowed = false;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You are not authorized to use this feeature. Please contact your supervisor.'));
			return;
		}
		//Get the list of visits selected from the list view
		Set<id> visitsSelectedIds = (new Map<Id, Inspection__c>((Inspection__c[])setCon.getSelected())).keySet();
		//Excluding visits that are locked by offline app or visit mode as it means they are in progress.
		visitsSelected = [SELECT ID, Name, Assigned_To_Id__c, Additional_EEC_Staff__c, Provider_No__c
												, Status__c,  Offline_Lock__c, Visit_Mode_Lock__c
											FROM Inspection__c 
											WHERE ID IN :visitsSelectedIds];
		//Build list of user id's that need to be excluded from the list of transfer to user options
		Set<Id> transferFromUserIds = new Set<Id>();
		for(Inspection__c v : visitsSelected){
			if( (v.Status__c != 'Scheduled' && v.Status__c != 'To be scheduled') || v.Offline_Lock__c || v.Visit_Mode_Lock__c){
				transferAllowed = false;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Visits that are completed or locked can not be transferred. Please update your selection.'));
				break;
			}
			transferFromUserIds.add(v.Assigned_To_Id__c);
		}

		transferToUserList = [SELECT ID, Name, UserRole.Name, UserType, Username 
													FROM User 
													WHERE UserType = 'Standard' AND isActive = true 
														AND ID NOT IN :transferFromUserIds
														AND UserRole.Name NOT IN ('Admin', 'Executive and Directors', ''
														, 'Program Supervisor', 'Regional Director')];
		transferToOptionsDisplay = new List<SelectOption>();
		transferToOptionsDisplay.add(new SelectOption('select', 'Select...'));
		for(User u : transferToUserList){
			transferToOptionsDisplay.add(new SelectOption(u.id, u.Name));
		}
	}
	public pageReference massTransferVisits(){
		List<Inspection__c> visitToBeUpdate = new List<Inspection__c>();
		if(selectedUserId == 'select' && selectedAdditionalStaff == 'select'){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please make a selection.'));
			return null;
		}
		for(Inspection__c visit : visitsSelected){
			if(selectedUserId != 'select'){
				visit.Inspector_del__c = selectedUserId;
			}
			if(selectedAdditionalStaff != 'select'){
				visit.Additional_EEC_Staff__c = selectedAdditionalStaff;
			}
			visitToBeUpdate.Add(visit);
		}
		Update visitToBeUpdate;
		//Update open activities if "Assign To" field is updated
		if(selectedUserId != 'select'){
			Set<Id> visitIdSet = (new Map<Id, Inspection__c>(visitToBeUpdate)).keySet();
			List<Task> tasksOpen = [SELECT ID, Status, OwnerId, WhatID 
																			FROM Task 
																			WHERE WhatId IN :visitIdSet AND Status != 'Completed'];
			List<Task> tasksToBeUpdated = new List<Task>();
			for(Task t : tasksOpen){
				t.OwnerId = selectedUserId;
				tasksToBeUpdated.add(t);
			}
			Update tasksToBeUpdated;
		}
		PageReference pageRef = new PageReference('/' + visitObjectId);
		return pageRef;
	}
	public pageReference goBackToVisitsTab(){
		PageReference pageRef = new PageReference('/' + visitObjectId);
		return pageRef;
	}
}