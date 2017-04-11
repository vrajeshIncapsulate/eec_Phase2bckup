@isTest
public with sharing class EEC_TestNonComplaintItemTrigger{
    @isTest static void testupdateRequireFeedback() {
        test.startTest();
        
        User u = EEC_TestUtil.mockUser();        
        System.runAs(u) {
            ID accountid;     
            RecordType r = [select Id from RecordType where DeveloperName='FCC' and sobjecttype='Account'];
            RecordType r1 = [select Id from RecordType where DeveloperName='Investigation_Visits' and sobjecttype='Inspection__c'];        
            Account pAccount = new Account(
            name='TestProvider1',
            RecordTypeId=r.Id,
            Provider_Email__c='test@test.com',
            Provider_Address_1__c='123 Test St',
            Provider_City__c=EEC_TestUtil.mockCity().Id,
            Provider_Zip_Code__c='B3H0A2');
            insert pAccount;
            Regulation__c reg = new Regulation__c(name='Test Reg',Date_Active__c=Date.today(),Reg_key__c='123456',Article__c='TEST Article',Applicable_To__c='Family Child Care');
            insert reg;
            RecordType aiRType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Additional_Inspection_Item'];
            r1 = [select Id from RecordType where DeveloperName='Investigation_Visits' and sobjecttype='Inspection__c'];        
            Inspection__c insp = new Inspection__c(Provider_No__c=pAccount.Id,RecordTypeId=r1.Id,Status__c='Scheduled', Date_of_Visit__c=date.today());
            insert insp;
            Inspection_Item__c iItem = new Inspection_Item__c (Inspection_no__c = insp.Id,Associated_regulation__c=reg.Id,RecordTypeId=aiRType.Id,Inspection_Result__c='Non-Compliant',Date_Implemented__c  = Date.Today(),Correction_Plan__c='Testing 1',observations__c='test',To_Review_on_Portal__c = true);
            insert iItem;
            System.debug('insp record type -->'+insp.RecordTypeId);  
            System.debug('insp id -->'+insp.Id);  
            Investigation__c i = new Investigation__c(Provider_No__c = pAccount.Id,Created_on_the_Web__c=true,Require_Portal_Feedback__c=true);   
            insert i;
            i = [select id from Investigation__c where id = :i.id];
            insp.Investigation__c = i.id;
            update insp;
            Inspection__c insp1 = [select id ,Investigation__c from Inspection__c where id = :insp.id limit 1 ];
            System.debug('Test class value of Investigation__c' + insp1.Investigation__c);
            Non_Compliant__c nc = new Non_Compliant__c(Investigation__c = i.Id,Observations__c='Test');        
            insert nc;
            List<Non_Compliant__c> ncompList = new List<Non_Compliant__c>([select Id,Investigation__c,Date_Implemented__c,Correction_Plan__c from Non_Compliant__c where Id = :nc.Id limit 1]);                                   
            ncompList[0].Date_Implemented__c  = Date.Today();
            ncompList[0].Correction_Plan__c = 'Testing222';
   //         ncompList[0].Investigation__c = insp.id; 
            update ncompList;
                   
            
            i = [SELECT Require_Portal_Feedback__c  FROM Investigation__c WHERE ID = :i.Id];
            
            System.assertEquals(false,i.Require_Portal_Feedback__c);
            
            
             

        }
        
        test.stopTest();
    }    
}