public with sharing class EEC_CaseTriggerHandler {
    
    List<Case> newCaseList;
    Map<Id, Case> oldCaseMap;
    Map<Id,city__c> cityMap;
    Map<Id,Account> accountMap;
    Map<Id,Contact> contactMap;
    Map<Id,String> cityRegionMap;
    Map<Id,Investigation__c> investigationMap;
    List<ProcessInstance> processList;
    Map<Id, User> userList;
    Map<Id, UserRole> userRoleList;
    public static boolean FirstRun = true;
    
    EmailTemplate template20 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X20_Case_Escalated_Approved_info_to_initial_requestor'];
    EmailTemplate template21 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X21_Case_Escalated_Rejected_info_to_initial_requestor'];
    EmailTemplate template22 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'X22_Case_Escalated_Request_Recalled'];
    //EmailTemplate template13 = [SELECT Body, Subject FROM EmailTemplate WHERE DeveloperName = 'Test_13_Email_Template'];
    
    public EEC_CaseTriggerHandler(List<Case> newList){
        this.newCaseList = newList;
    }
    
    public EEC_CaseTriggerHandler(List<Case> newList, Map<Id, Case> oldList){
        this.newCaseList = newList;
        this.oldCaseMap = oldList;
        
        if(UserInfo.getUserType() == 'Standard'){
        	setup();
        }
    }
    
    private void setup(){ 
        
        Set<Id> actors = new Set<Id>{};
        Set<Id> roleIds = new Set<Id>{};
        
        processList = new List<ProcessInstance>([
            SELECT Status, Id, TargetObject.Name, TargetObjectID, TargetObject.Type, 
            (SELECT OriginalActorId, ActorId FROM WorkItems ORDER BY CreatedDate DESC LIMIT 1)  
            FROM ProcessInstance
            WHERE TargetObjectId IN :newCaseList AND Status = 'Pending'
            ORDER BY CreatedDate DESC
        ]);
        
        for(Case c : newCaseList){
            if(c.OwnerId!=null){
                actors.add(c.OwnerId);
            }
        }
        
        for(ProcessInstance pi : processList){
            if(pi.WorkItems.size() > 0){
                actors.add(pi.WorkItems[0].OriginalActorId);
                actors.add(pi.WorkItems[0].ActorId);
            }
        }
        
        userList = new Map<Id, User>([
            SELECT ManagerId, UserRoleId, Email, Name
            FROM User
            WHERE Id IN :actors
        ]);
        
        System.debug('ACTORS---->'+actors);
        for(User u : userList.values()){
            roleIds.add(u.UserRoleId);
        }
        
        userRoleList = new Map<Id, UserRole>([
            SELECT Name
            FROM UserRole
            WHERE ID IN :roleIds
        ]); 
    }
    
    private class TestException extends Exception {}
    
    private void sendTriageResultEmail(Case c, Case oldCase){ 
        if((oldCase == null || oldCase.SendCaseTriageEmail__c == null) && c.SendCaseTriageEmail__c != null){  
            EEC_EmailUtil email = new EEC_EmailUtil(); 
     
            if(c.SendCaseTriageEmail__c == 'Approved'){  
                
                // c.SendCaseTriageEmail__c = 'Approved and Email Triggered';
                email.htmlBody = template20.Body
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c)
                    .replace('{!Case.OwnerFullName}', userList.get(c.OwnerId).Name)
                    .replace('{!Case.Id}', c.Id);
                    
                email.subject = template20.Subject
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c);
                    
            }
            else if (c.SendCaseTriageEmail__c == 'Recalled') {
                email.htmlBody = template22.Body
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c)
                    .replace('{!Case.OwnerFullName}', userList.get(c.OwnerId).Name)
                    .replace('{!Case.Id}', c.Id);
                    
                email.subject = template22.Subject
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c);
            }
            else {
                email.htmlBody = template21.Body
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c)
                    .replace('{!Case.OwnerFullName}', userList.get(c.OwnerId).Name)
                    .replace('{!Case.Id}', c.Id);
                    
                email.subject = template21.Subject
                    .replace('{!Case.Provider_Name_For_Email_Merge__c}', c.Provider_Name_For_Email_Merge__c);
            }
            
            email.toAddresses = new List<String>();
            
            if(c.TriageEscalationApproverEmailList__c != null){
                if(c.TriageEscalationApproverEmailList__c.contains(',')) {
                    email.toAddresses.addAll(c.TriageEscalationApproverEmailList__c.split(',')); 
                } else {
                    email.toAddresses.add(c.TriageEscalationApproverEmailList__c); 
                }
            }
            if(userList.get(c.OwnerId).Email != null) 
            	email.toAddresses.add(userList.get(c.OwnerId).Email);
            if(c.X1st_Escalation_Approver_Email_Address__c != null)
            email.toAddresses.add(c.X1st_Escalation_Approver_Email_Address__c);
            
            System.debug(email.toAddresses);
            
            email.whatId = c.Id;
            email.saveAsActivity = false; 
            email.sendEmail();
        }
    }
    
    public void sendApprovalTriageResultEmail(){
        
        List<Investigation__c> updatedInvestigations = new List<Investigation__c>();
        for(Case c : newCaseList) {               
            sendTriageResultEmail(c, oldCaseMap.get(c.Id));
            
            if(c.SendCaseTriageEmail__c == 'Approved'){ 
                if(c.Investigation__c != null && investigationMap.containsKey(c.Investigation__c)){
                   Investigation__c i = investigationMap.get(c.Investigation__c);
                   i.Escalated_Investigation__c = true;
                   //i.Approval_Task_Creation__c = 'Escalated Approved'; 
                   updatedInvestigations.add(i); 
                }
            }
            c.TriageEscalationApproverEmailList__c = null;
            c.SendCaseTriageEmail__c = null; 
        }
        update updatedInvestigations;
    }
    
    public void updateApprovalManager(){ 
        for(Case c : newCaseList){  
        
            Case oldCase = oldCaseMap.get(c.Id);
            
            if(c.TriggerTriageEscalationApproval__C){
                c.Approver_Manager__c = null;
                c.TriggerTriageEscalationApproval__C = false;
                
                for(ProcessInstance pi : processList) {
                
                    if(pi.TargetObjectId == c.Id && pi.WorkItems.size() > 0){
                    
                        User oActor = userList.get(pi.WorkItems[0].OriginalActorId);
                        UserRole oActorRole = userRoleList.get(oActor.UserRoleId);
                        
                        if(c.TriageEscalationApproverEmailList__c == null){
                            c.TriageEscalationApproverEmailList__c = '';
                        }
                        
                        if(c.TriageEscalationApproverEmailList__c != null && c.TriageEscalationApproverEmailList__c != ''){
                            c.TriageEscalationApproverEmailList__c += ',';
                        }
                        c.TriageEscalationApproverEmailList__c += oActor.Email;
                        
                        if(oActor.ManagerId != NULL && (oActorRole == NULL || oActorRole.Name != 'Executive and Directors')){
                            c.Approver_Manager__c = oActor.ManagerId;
                        } 
                        
                        break;
                    }
                }
            }
            
        } 
    }
    
   
    public void bulkBefore(){
        
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> cityIdSet = new Set<Id>();
        Set<Id> investIdSet = new Set<Id>();
        cityRegionMap = new Map<Id,String>();
        Set<Id> contactIdSet = new Set<Id>();
         
        for(Case cse : newCaseList){
            if(String.isNotBlank(cse.AccountId)){// && String.isBlank(cse.Unlicensed_Provider_Name__c)){
                accountIdSet.add(cse.AccountId);
            }
            if(string.isNotBlank(cse.ContactId)){
            	contactIdSet.add(cse.ContactId);
            }
          //  else if(String.isBlank(cse.Unlicensed_Provider_Region__c) && !String.isBlank(cse.Unlicensed_Provider_City__c) && !String.isBlank(cse.Unlicensed_Provider_Name__c)){
            if(String.isBlank(cse.Unlicensed_Provider_Region__c) && !String.isBlank(cse.Unlicensed_Provider_City__c) && !String.isBlank(cse.Unlicensed_Provider_Name__c)){
                cityIdSet.add(cse.Unlicensed_Provider_City__c);
            }
            
            if(String.isNotBlank(cse.Investigation__c)){
                investIdSet.add(cse.Investigation__c);
            }
        }
        Map<Id,String> tempCRMap = new Map<Id,String>();
        String tRegion = '';
        if(cityIdSet != null && cityIdSet.size() > 0){
            for(City_Assignment__c ca : [SELECT id, city__r.name, Applicable_to__c, Region__c 
                                         FROM City_Assignment__c 
                                         WHERE city__c in :cityIdSet]){
                if(cityRegionMap.containsKey(ca.city__c)){
                    if(ca.Applicable_to__c.contains('Family Child Care')){
                        cityRegionMap.put(ca.city__c,ca.Region__c);
                    }
                }
                else{
                    cityRegionMap.put(ca.city__c,ca.Region__c);
                }
            }
        }
        if(accountIdSet != null && accountIdSet.size() > 0){
            accountMap = new Map<Id,Account>([select Id,name,RecordType.name,Region__c,OwnerId from Account where Id in :accountIdSet]);
        }
        
        if(contactIdSet != null && contactIdSet.size() > 0){
            contactMap = new Map<Id,Contact>([select Id,name,AccountId,Account.Name from Contact where Id in :contactIdSet]);
        }
        
        if(investIdSet != null && investIdSet.size() > 0){
            investigationMap = new Map<Id,Investigation__c>([SELECT Id,name,Investigation_Status__c,Assigned_To__c,Assigned_To__r.Email,
                                                            (SELECT Id,createdDate FROM Cases__r order by createddate) 
                                                             FROM Investigation__c WHERE Id in :investIdSet]);
        }
        
    }
    
    /*public void bulkAfter(){
        
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> investIdSet = new Set<Id>();
         
        for(Case cse : newCaseList){
            if(String.isNotBlank(cse.AccountId)){
                accountIdSet.add(cse.AccountId);
            }
          
            if(String.isNotBlank(cse.Investigation__c)){
                investIdSet.add(cse.Investigation__c);
            }
        }
        Map<Id,String> tempCRMap = new Map<Id,String>();
        
        if(accountIdSet != null && accountIdSet.size() > 0){
            accountMap = new Map<Id,Account>([select Id,name,RecordType.name,Region__c from Account where Id in :accountIdSet]);
        }
        
        if(investIdSet != null && investIdSet.size() > 0){
            investigationMap = new Map<Id,Investigation__c>([select Id,name,Investigation_Status__c,Assigned_To__c,Assigned_To__r.Email,
                                                            (select Id,createdDate from Cases__r order by createddate) 
                                                             from Investigation__c where Id in :investIdSet]);
        } 
        
    }*/
    
    public void updateCaseRegion(){
        Account accnt;
        Region__c region;
        Set<Id> regionIdSet = new Set<Id>();
        Map<Id,Region__c> regionMap;
        
        Map<string,Account> unlicensedProviderMap = new Map<string,Account>();
        for(Account a : [Select Id,Name,Region__c From Account where name like 'Unlicensed Provider -%']){
        	unlicensedProviderMap.put(a.Region__c,a);
        	regionIdSet.add(a.Region__c);
        }
        
        for(Case cse : newCaseList){
        	
          if(String.isBlank(cse.AccountId) && String.isBlank(cse.Unlicensed_Provider_Region__c) && !String.isBlank(cse.Unlicensed_Provider_City__c) && cityRegionMap.containsKey(cse.Unlicensed_Provider_City__c) && (cse.Status == 'New' || cse.Status == 'Not Submitted')){
             
                cse.Unlicensed_Provider_Region__c = cityRegionMap.get(cse.Unlicensed_Provider_City__c);
                  system.debug('*** cse.Unlicensed_Provider_Region__c ***'+cse.Unlicensed_Provider_Region__c);
                
            }
            if(String.isNotBlank(cse.Unlicensed_Provider_Region__c)){
                regionIdSet.add(cse.Unlicensed_Provider_Region__c);
            }
            if(accountMap != null && String.isNotBlank(cse.AccountId) ){
                accnt = accountMap.get(cse.AccountId);
                regionIdSet.add(accnt.Region__c);
            }
            
        }
        
        if(regionIdSet != null && regionIdSet.size() > 0){
            regionMap = new Map<Id,Region__c>([select Id,FCC_New_Case_Default_Assignee__c,SGLSA_New_Case_Default_Assignee__c from Region__c where Id in :regionIdSet]);
        }       
        
        Investigation__c invest;
        EEC_EmailUtil eu;
        List<String> toAddresses;
        
        Id templateId = [select id, name from EmailTemplate where developername = 'X13_Notification_that_a_new_case_has_been_attached_to_investigation'].id;
        //Id templateId = [select id, name from EmailTemplate where developername = 'Test_13_Email_Template'].id;
        //OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'doNotReply@blahblah.com'];
        for(Case cse : newCaseList){
            if(cse.Status == 'New' || cse.Status == 'Not Submitted'){
                if(String.isBlank(cse.AccountId)){
                    system.debug('*** Account is BLANK ***');       
                    if(String.isNotBlank(cse.Unlicensed_Provider_Region__c)){
                        region = regionMap.get(cse.Unlicensed_Provider_Region__c);
                        cse.Triage_Responsible__c = region.FCC_New_Case_Default_Assignee__c;
                        if(String.isNotBlank(cse.ContactId)){
                            Contact con = contactMap.get(cse.ContactId);
                            if(con != null){
                                if(con.AccountId != null){
                                     Account acc = unlicensedProviderMap.get(cse.Unlicensed_Provider_Region__c);
                                     if (acc != null){
                                            cse.AccountId = unlicensedProviderMap.get(cse.Unlicensed_Provider_Region__c).Id;                   
                                            system.debug('*** cse.AccountId ***'+ cse.AccountId);  
                                      } 
                                }
                                else{
                                    cse.AccountId = con.AccountId;
                                }
                            }
                        }       
                    }
                }
                else{
                    //Assign unlicensed Provider (Bucket Provider) on Case
                     if(!String.isBlank(cse.Unlicensed_Provider_Name__c) && !String.isBlank(cse.Unlicensed_Provider_City__c) && cityRegionMap.containsKey(cse.Unlicensed_Provider_City__c)){  	
                            system.debug('******LD'+ cse.AccountId);
                            cse.Unlicensed_Provider_Region__c = cityRegionMap.get(cse.Unlicensed_Provider_City__c);
                            system.debug('******LD REgion ****'+ cse.Unlicensed_Provider_Region__c);
                            
                            region = regionMap.get(cse.Unlicensed_Provider_Region__c);
                            cse.Triage_Responsible__c = region.FCC_New_Case_Default_Assignee__c;
                            Account acc = unlicensedProviderMap.get(cse.Unlicensed_Provider_Region__c);
                            if (acc != null){
                            cse.AccountId = unlicensedProviderMap.get(cse.Unlicensed_Provider_Region__c).Id;
                       
                             system.debug('******LD Unlicensed Provider ****'+ acc);
                            }
                        }
                     else {
                        accnt = accountMap.get(cse.AccountId);
                        system.debug('****Account ***'+accnt);
                        if(String.isNotBlank(accnt.Region__c)){
                            region = regionMap.get(accnt.Region__c);
                            if(accnt.RecordType.name == 'Family Child Care'){
                                cse.Triage_Responsible__c = region.FCC_New_Case_Default_Assignee__c;
                            }
                            else if(accnt.RecordType.name == 'Large Group' || accnt.RecordType.name == 'Small Group' || accnt.RecordType.name == 'Umbrella'){
                                cse.Triage_Responsible__c = region.SGLSA_New_Case_Default_Assignee__c;
                            }
                            else{
                                system.debug('****Account Owner***'+accnt.OwnerId);
                                User[] owner = [SELECT Id,ManagerId FROM User WHERE Id =: accnt.OwnerId LIMIT 1];
                                if(owner.size() > 0)
                                    cse.Triage_Responsible__c = owner[0].ManagerId;
                            }
                        }
                     }
                } // end if
            }
        }       
    }
    
    public void updateCaseStatus(){
    	Investigation__c invest;
        Integer counter = 0;
    	for(Case cse : newCaseList){
    		if(String.isNotBlank(cse.Investigation__c) && cse.Status != 'Escalated'){
                invest = investigationMap.get(cse.Investigation__c);
                if(invest.Cases__r != null && invest.Cases__r.size() > 0 && String.isNotBlank(invest.Assigned_To__c)){
                    if(String.isNotBlank(invest.Investigation_Status__c) && invest.Investigation_Status__c != 'Closed' ){
                        cse.Status = 'Investigation in Progress';
                    }
                    else{
                        cse.Status = 'Closed';
                        cse.Closing_Reasons__c = 'Investigation completed';
                    }
                    
                    if(String.isBlank(cse.ParentId)){
                        Case[] pCase = [SELECT Id FROM Case WHERE ParentId = null AND Investigation__c =: invest.Id AND Id !=: cse.Id LIMIT 1];
                        if(pCase.size() > 0){
                            if(pCase[0].Id != cse.Id){
                                cse.ParentId = pCase[0].Id;
                            }
                        }
                    }
                }
            }
    	}
    }
    
    public void sendCaseEmail(){
        Investigation__c invest;
        EEC_EmailUtil eu;
        List<String> toAddresses;
        Id oldInvest;
        for(Case cse : newCaseList){
        	if(String.isNotBlank(cse.Investigation__c)){
                invest = investigationMap.get(cse.Investigation__c);
                oldInvest = (oldCaseMap == null || String.isBlank(oldCaseMap.get(cse.Id).Investigation__c)) ? null :oldCaseMap.get(cse.Id).Investigation__c;
                if(cse.Investigation__c != oldInvest && invest.Cases__r != null && invest.Cases__r.size() > 0){
                    toAddresses = new List<String>();
                    
                    if(String.isNotBlank(invest.Assigned_To__c)){ 
                        String accntName = '';
                        if(String.isNotBlank(cse.AccountId)){
                            accntName = accountMap.get(cse.AccountId).Name;
                        }
                        else{
                            accntName = cse.Unlicensed_Provider_Name__c;
                        }
                        sendIEmail(invest.Assigned_To__r.Email,invest.name,invest.Assigned_To__c,cse.CaseNumber,cse.Investigation__c,cse.Subject,accntName);
                    }
                }
            }
       }
    }
    
    @future
    public static void sendIEmail(String assignedEmail,String investName,Id assignedTo, String caseName,String investId, String caseSubject, String accntName){
        EEC_EmailUtil eu = new EEC_EmailUtil();
        List<String> toAddresses = new List<String>();
        List<OrgWideEmailAddress> orgList = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'EEC LEAD Alert'];
        String emailBOdy = '';
        URL hostURL = URL.getCurrentRequestUrl(); 
        String domain = 'https://' + hostURL.getHost() +'/'+investId;
        toAddresses.add(assignedEmail);
        if(orgList != null){
        	eu.orgWideEmailId = orgList.get(0).Id;
        }
        eu.targetObjectId = assignedTo;
        //eu.whatId = caseId;
        eu.toAddresses = toAddresses;
        caseSubject = String.isBlank(caseSubject)?'':caseSubject;
        eu.Subject = 'Subject Notification that a new case has been attached to investigation';
        //eu.templateId = templateId;
        emailBody = 'Hello\n\nA new case ('+caseName+' - ' + caseSubject + ') has been attached to investigation ' + investName+' associated to provider : '+accntName + ' you are in charge of.\n\n';
        emailBody = emailBody + 'Please review your investigation ('+domain+' ) in Salesforce to get more information on this case.\n\nLEAD System';
        eu.plainTextBody = emailBody;
        eu.sendEmail();
    }
    
}