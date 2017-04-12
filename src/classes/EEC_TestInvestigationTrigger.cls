@isTest
public with sharing class EEC_TestInvestigationTrigger {

    @isTest static void testUpdateClosedInvestigationsBefore() {
        test.startTest();
        
        User u = EEC_TestUtil.mockUser();
        
        System.runAs(u) {
            Investigation__c i = EEC_TestUtil.mockInvestigation(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
            i.Investigation_Status__c = 'Approved - Report to send';
            i.Assigned_To__c = u.id;
            i.Approval_Task_Creation__c = 'NonEscalated Approved';
            update i;
            i.Investigation_Status__c = 'Report Sent to Provider';    
            update i;    
            //i.Investigation_Status__c = 'Closed'; 
            //i.Cover_Letter_Issue_Date__c = System.Today();
            //Intervention__c inv = EEC_TestUtil.mockIntervention(i);
            //inv.Status__c = 'Cancelled';
            //inv.Cancel_Reason__c = 'Testing';
            
            //update inv;
            //update i;
            
            //i = [SELECT Closed_date__c FROM Investigation__c WHERE ID = :i.Id];
             
            //System.assertEquals(System.today(), i.Closed_Date__c); 
        }
        
        test.stopTest();
    }
    
    @isTest static void testUpdateClosedInvestigationsAfter() {
     test.startTest();
        
        User u = EEC_TestUtil.mockUser();
        
        System.runAs(u) {
            Investigation__c i = EEC_TestUtil.mockInvestigation(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
            i.Investigation_Status__c = 'Approved - Report to send';
            i.Assigned_To__c = u.id;
            i.Approval_Task_Creation__c = 'NonEscalated Rejected';
            update i;
            i.Investigation_Status__c = 'Ready to Publish/Send to Provider';
			i.Created_on_the_Web__c = true;   
            update i; 
        }
    }

}