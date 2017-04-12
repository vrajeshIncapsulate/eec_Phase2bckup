public with sharing class EEC_InvestigationTriggerHandler {

    private Map<Id, Investigation__c> newMap;
    private Map<Id, Investigation__c> oldMap;
    private Map<Id,User> userMap;
    private Map<Id,Account> providerMap;
    private List<Case> cases;
    private List<Inspection__c> inspections;
    private List<Task> tasks;
    private Boolean gotRelatedObjects = false;
    private Set<Id> leaderSet;
    private Set<Id> providerSet;
    public static boolean FirstRun = true;

    public EEC_InvestigationTriggerHandler(Map<Id, Investigation__c> newMap, Map<Id, Investigation__c> oldMap){
        this.newMap = newMap;
        this.oldMap = oldMap; 
    }
    
   
    public void updateClosedInvestigationsBefore(){
        
        leaderSet = new Set<Id>();
        providerSet = new Set<Id>();
        for(Investigation__c inv : newMap.values()){
            
            Investigation__c old = oldMap.get(inv.Id);
            System.debug(inv.Investigation_Status__c);
            System.debug(old);
            
            providerSet.add(inv.Provider_no__c);
            if(String.isNotBlank(inv.Assigned_to__c)){
                leaderSet.add(inv.Assigned_to__c);
            }   
            if((old == NULL || old.Investigation_Status__c != 'Closed') && inv.Investigation_Status__c == 'Closed'){
                inv.Closed_date__c = System.Today();
                inv.Created_on_the_Web__c = true;
            }
        }
        
    }
    
    private void getRelatedObjects(){ 
        
        this.cases = [
            SELECT ID, Investigation__c
            FROM Case 
            WHERE Investigation__c IN :newMap.keySet()
        ];
        
        this.inspections = [
            SELECT ID, Investigation__c
            From Inspection__c 
            WHERE Investigation__c IN :newMap.keySet()
            AND (Status__c = 'Visit Completed')
        ];
        
        this.tasks = [
            SELECT ID, WhatId
            FROM Task 
            WHERE WhatId IN :newMap.keySet() 
            AND IsRecurrence = false AND Status != 'Completed'
        ];

        this.gotRelatedObjects = true;
    }
    
    public void updateClosedInvestigationsAfter() {
    
        for(Investigation__c inv : newMap.values()){
            
            Investigation__c old = oldMap.get(inv.Id);
            
            if((old == NULL || old.Investigation_Status__c != 'Closed') && inv.Investigation_Status__c == 'Closed'){
                
                if(!this.gotRelatedObjects){
                    getRelatedObjects();
                }
                
                List<Case> cases = casesForInvestigation(inv); 
                
                for(Case c : cases){ 
                    c.Status = 'Closed';
                    c.Closing_reasons__c = 'Investigation Closed';
                } 
                
                if(cases.size() != 0){
                    update cases;
                }
                
                System.debug('Inspection ----->' + inspections);
                for(Inspection__c insp : inspectionsForInvestigation(inv)){
                    insp.Status__c = 'Closed';
                    insp.Closed_Cancellation_Date__c = System.Today();
                    insp.Cancellation__c = 'Investigation Closed';
                }
                
                if(inspections.size() != 0){
                    update inspections;
                }
                
               /* List<Task> tasks = tasksForInvestigation(inv);
                
                for(Task t : tasks){
                    t.Status = 'Completed'; 
                }
                
                if(tasks.size() != 0){
                    update tasks;
                }*/
                
            }
        }
    }
    
    public void updateLeaderHeirarchy(){
        
        List<Task> approvalTaskList = new List<Task>();
        Account provider;
        providerMap = new Map<Id,Account>([select Id,Region__c, Region__r.Deputy_Commissioner__c,Region__r.Regional_Director__c,RecordType.Name from Account where Id in :providerSet]);
        if(leaderSet != null && leaderSet.size()>0){
            this.userMap  = new Map<Id,User>([select Id, ManagerId from User where Id in :leaderSet and ManagerId != null]);
        }
        
        for(Investigation__c inv : newMap.values()){
            provider = providerMap.get(inv.Provider_no__c);
            if(String.isNotBlank(provider.Region__c) && String.isNotBlank(provider.Region__r.Deputy_Commissioner__c)){
                inv.Leader_Deputy_Commisioner__c = provider.Region__r.Deputy_Commissioner__c;
            }
            if(userMap != null && String.isNotBlank(inv.Assigned_To__c) && userMap.containsKey(inv.Assigned_To__c)){
                inv.Leader_Manager__c = userMap.get(inv.Assigned_To__c).ManagerId;
            }
            if(provider.RecordType.Name == 'Family Child Care' || provider.RecordType.Name == 'Small Group' || provider.RecordType.Name == 'Large Group'){
                inv.Leader_Director_Supervisor__c = provider.Region__r.Regional_Director__c;
            }
            else{
                inv.Leader_Director_Supervisor__c = inv.Leader_Manager__c;
            }
            
            String newATC = inv.Approval_Task_Creation__c;
            String oldATC;
            Task approvalTask;
            if(String.isNotBlank(newATC)){
                if(oldMap != null){
                    Investigation__c old = oldMap.get(inv.Id);
                    oldATC = (old != null && String.isNotBlank(old.Approval_Task_Creation__c))?old.Approval_Task_Creation__c:'';
                    if(newATC != oldATC){
                        if(newATC == 'NonEscalated Approved' || newATC == 'Escalated Approved'){
                            approvalTask = new Task();
                            approvalTask.Subject = 'Prepare and send investigation report to Provider';
                            approvalTask.Status = 'Not Started';
                            approvalTask.Priority = 'High';
                            approvalTask.WhatId = inv.Id;
                            approvalTask.OwnerId = String.isNotBlank(inv.Assigned_To__c)?inv.Assigned_To__c:UserInfo.getUserId();
                            approvalTask.ActivityDate = Date.today().addDays(3);
                            approvalTaskList.add(approvalTask);
                            
                        }
                        else if(newATC == 'NonEscalated Rejected' || newATC == 'Escalated Rejected'){
                            approvalTask = new Task();
                            approvalTask.Subject = 'Re-work required on investigation following review and rejection';
                            approvalTask.Status = 'Not Started';
                            approvalTask.Priority = 'High';
                            approvalTask.WhatId = inv.Id;
                            approvalTask.OwnerId = String.isNotBlank(inv.Assigned_To__c)?inv.Assigned_To__c:UserInfo.getUserId();
                            approvalTask.ActivityDate = Date.today().addDays(3);
                            approvalTaskList.add(approvalTask);
                        }
                        
                    }
                }
            }
        }
        if(approvalTaskList != null && approvalTaskList.size()>0){
            insert approvalTaskList;
        }
        
    }
    
    
    
    public List<Case> casesForInvestigation(Investigation__c i){ 
        List<Case> l = new List<Case>();
        
        for(Case c : cases){
            if(c.Investigation__c == i.Id){
                l.add(c);
            }
        }
        
        return l;
    }
    
    public List<Task> tasksForInvestigation(Investigation__c i){ 
        List<Task> l = new List<Task>();
        
        for(Task t : tasks){
            if(t.WhatId == i.Id){
                l.add(t);
            }
        }
        
        return l;
    }
    
    public List<Inspection__c> inspectionsForInvestigation(Investigation__c i){ 
        List<Inspection__c> l = new List<Inspection__c>();
        
        for(Inspection__c insp : inspections){
            if(insp.Investigation__c == i.Id){
                l.add(insp);
            }
        }
        
        return l;
    }
    
    /**
     * checkVisitsForPublishedToWeb
     * 
     * This function will verify all visits and non compliants for published to web. 
     * @author Darkis
     */
    public void checkVisitsForPublishedToWeb() {
      for(Investigation__c inv : newMap.values()){
        Investigation__c old = oldMap.get(inv.Id); System.debug('-----> Investigation: ' + inv.Id);
        // If the old record was not published to web and the new one is then continue.  
        if (!old.Created_on_the_Web__c && inv.Created_on_the_Web__c) {
          // Get all the related visits who are not closed or cancelled.
          List<Id> visitIds = new List<Id>();
          List<Inspection__c> visits = [Select Id, Name, Status__c, Created_on_the_Web__c From Inspection__c Where Investigation__c = :inv.Id AND Status__c NOT IN('Cancelled')];  System.debug('-----> Visits: ' + visits);
          // If there are any visits meeting the criteria.
          if (visits != null && visits.size() > 0) {
            // Loop through the results.
            for (Inspection__c visit : visits) {
              visitIds.add(visit.Id);
              visit.Created_on_the_Web__c = true;
            }    
            // Update the visits. The visits will be modified by the Visits trigger to set Visit Items to Review on Portal = true and the Visit to "Report Sent to Provider, Awaiting Feedback".
            update visits;
          }
          //Get all non-compliant items.
          List<Non_Compliant__c> nonCompliantItems = [Select Id, Name, Feedback_Requested__c,Correction_Plan_Status__c, To_Review_on_Portal__c From Non_Compliant__c Where Investigation__c = :inv.Id AND Feedback_Requested__c = true]; System.debug('-----> NonCompliants: ' + nonCompliantItems);
          // If there are non compliant items with feedback requested. 
          List<Non_Compliant__c> updateNonComp = new List<Non_Compliant__c>();
          if (nonCompliantItems != null && nonCompliantItems.size() > 0) {
            // Loop through non compliant items and update To_Review_on_Portal__c to True.
            for (Non_Compliant__c ncItem : nonCompliantItems) {
                Non_Compliant__c ncItem2 = ncItem;
                ncItem2.To_Review_on_Portal__c = true;
                ncItem2.Correction_Plan_Status__c ='Provider To Submit';
                updateNonComp.add(ncItem2);
            }
            update updateNonComp;
          }
          // Get a count of the Visit Items that have Feedback_Requested__c = true.
          Integer visitItemsCount = [Select Count() From Inspection_Item__c Where Feedback_Requested__c = true AND Inspection_No__c IN :visitIds]; System.debug('-----> visitItemsCount: ' + visitItemsCount);
          // If there are any NonCompliant Items OR Visit Items with Feedback_Requested__c = true then update the Investigation.   
          if ((nonCompliantItems != null && nonCompliantItems.size() > 0) || (visitItemsCount != null && visitItemsCount > 0)) {
            // Update Investigation fields.
            Investigation__c newInvest = [Select Id, Name, Require_Portal_Feedback__c,lock_investigation__c From Investigation__c Where Id = :inv.Id];
            system.debug('****locked Investigation ****'+ newInvest.lock_investigation__c);
            newInvest.Require_Portal_Feedback__c = true;
            update newInvest;     
          } 
        }
      }
    }
}