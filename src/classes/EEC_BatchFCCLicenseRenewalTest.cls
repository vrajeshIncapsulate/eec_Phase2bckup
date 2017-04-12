/**
 * EEC_CorrectionActionSchedulerTest
 * 
 * This class will contain all the test methods for the EEC_BatchFCCLicenseRenewal class.
 * @author Madhav Kuchimanchi
 */

@isTest
private class EEC_BatchFCCLicenseRenewalTest {   
   
   
  static testMethod void testscenario1() {
         String query ='Select Id,Start_Renewal_Workflow__c,Renewal_date__c,License_Status__c,OwnerId,Provider_Status__c from Account  where License_Status__c = \'Licensed\' ' +
                        ' and Recordtype.Name = \'Family Child Care\'  ';                       

          Account acc1 = new Account();          
          Date cDate =  System.today();  
          // Scenario 1 : Renewal Application Not Submitted - 30 days prior to  expiration notice
          acc1.Name = 'Test account 1 ';
          acc1.License_Status__c = 'Licensed';
          acc1.Provider_Status__c = 'Current';
          acc1.Provider_Email__c ='test@incapsulate.com';
          acc1.RecordTypeId = [select Id from RecordType where Name = 'Family Child Care' and SobjectType = 'Account'].Id;
          acc1.Provider_Address_1__c = 'Test address';
          acc1.Provider_City__c = 'a0Ej0000002fMa2';
          acc1.Provider_Zip_Code__c = '99999';
          acc1.Language__c = 'English';
          acc1.Preferred_Language__c = 'English';
          acc1.Start_Renewal_Workflow__c = false;
          acc1.Renewal_date__c = cdate +30; 
          //acclist.add(acc1);
          insert acc1;       
          Account acc = new Account();
          acc = [Select Id,Start_Renewal_Workflow__c,Renewal_date__c,OwnerId,Provider_Status__c from Account  where id = :acc1.id];
                                
          Test.startTest(); 
             EEC_BatchFCCLicenseRenewal sfbatchSync = new EEC_BatchFCCLicenseRenewal(query);
             ID batchprocessid = Database.executeBatch(sfbatchSync);
          Test.stopTest();
             AsyncApexJob job  = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                                    FROM AsyncApexJob WHERE Id =:batchprocessid];
                //assert for total number of errors
            System.assertEquals(job.NumberOfErrors, 0);            
            Task task1 = new Task();
            Date tdate = Date.today().addDays(5);
            task1 = [select id ,Subject,ActivityDate from Task where WhatId = :acc.id limit 1];
            System.assertEquals(task1.Subject,'Renewal Application Not Submitted - 30 days prior expiration notice');
            System.assertEquals(task1.ActivityDate,tdate);                   
            
         }   
       
       //Scenario 2:Renewal Application Not Submitted - On expiration date notice
         static testMethod void testscenario2() {
         String query ='Select Id,Start_Renewal_Workflow__c,License_Status__c,Renewal_date__c,OwnerId,Provider_Status__c from Account  where License_Status__c = \'Licensed\' ' +
                        ' and Recordtype.Name = \'Family Child Care\'  ';
          Account acc1 = new Account();          
          Date cDate =  System.today();  
          
          
          acc1.Name = 'Test account 2 ';
          acc1.License_Status__c = 'Licensed';
          acc1.Provider_Status__c = 'Current';
          acc1.Provider_Email__c ='test@incapsulate.com';
          acc1.RecordTypeId = [select Id from RecordType where Name = 'Family Child Care' and SobjectType = 'Account'].Id;
          acc1.Provider_Address_1__c = 'Test address';
          acc1.Provider_City__c = 'a0Ej0000002fMa2';
          acc1.Provider_Zip_Code__c = '99999';
          acc1.Language__c = 'English';
          acc1.Preferred_Language__c = 'English';
          acc1.Start_Renewal_Workflow__c = false;
          acc1.Renewal_date__c = cdate;
          insert acc1;       
          Account acc = new Account();
          acc = [Select Id,Start_Renewal_Workflow__c,Renewal_date__c,OwnerId,Provider_Status__c from Account  where id = :acc1.id];
          Test.startTest(); 
             EEC_BatchFCCLicenseRenewal sfbatchSync = new EEC_BatchFCCLicenseRenewal(query);
             ID batchprocessid = Database.executeBatch(sfbatchSync);
          Test.stopTest();
             AsyncApexJob job  = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                                    FROM AsyncApexJob WHERE Id =:batchprocessid];
                //assert for total number of errors
            System.assertEquals(job.NumberOfErrors, 0);            
            Task task = new Task();
            Date tdate = Date.today().addDays(2);
            task = [select id ,Subject,ActivityDate from Task where WhatId = :acc.id limit 1];
            System.assertEquals(task.Subject,'Renewal Application Not Submitted - On expiration date notice');
            System.assertEquals(task.ActivityDate,tdate);                   
       }
        
          //Scenario 3:Renewal Application Not Submitted - 30 days after expiration notice
       static testMethod void testscenario3() {
         String query ='Select Id,Start_Renewal_Workflow__c,License_Status__c,Renewal_date__c,OwnerId,Provider_Status__c from Account  where License_Status__c = \'Licensed\' ' +
                        ' and Recordtype.Name = \'Family Child Care\'  ';
          Account acc1 = new Account();          
          Date cDate =  System.today();  
       
          acc1.Name = 'Test account 3';
          acc1.License_Status__c = 'Licensed';
          acc1.Provider_Status__c = 'Current';
          acc1.Provider_Email__c ='test@incapsulate.com';
          acc1.RecordTypeId = [select Id from RecordType where Name = 'Family Child Care' and SobjectType = 'Account'].Id;
          acc1.Provider_Address_1__c = 'Test address';
          acc1.Provider_City__c = 'a0Ej0000002fMa2';
          acc1.Provider_Zip_Code__c = '99999';
          acc1.Language__c = 'English';
          acc1.Preferred_Language__c = 'English';
          acc1.Start_Renewal_Workflow__c = false;
          acc1.Provider_Status__c = 'Region Freeze Enrollment';
          acc1.Renewal_date__c = cdate -30; 
          insert acc1;       
          Account acc = new Account();
          acc = [Select Id,Start_Renewal_Workflow__c,Renewal_date__c,OwnerId,Provider_Status__c from Account  where id = :acc1.id];
          Test.startTest(); 
             EEC_BatchFCCLicenseRenewal sfbatchSync = new EEC_BatchFCCLicenseRenewal(query);
             ID batchprocessid = Database.executeBatch(sfbatchSync);
          Test.stopTest();
          AsyncApexJob job  = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                               FROM AsyncApexJob WHERE Id =:batchprocessid];
                //assert for total number of errors
          System.assertEquals(job.NumberOfErrors, 0);            
          Task task = new Task();
          Date tdate = Date.today().addDays(2);
          task = [select id ,Subject,ActivityDate from Task where WhatId = :acc.id limit 1];
          System.assertEquals(task.Subject,'Renewal Application Not Submitted - 30 days after expiration notice');
          System.assertEquals(task.ActivityDate,tdate);                   
      }
          
          
          
     
      //Scenario 3:Renewal Application Not Submitted - 30 days after expiration notice
       static testMethod void testscenario4() {
         String query ='Select Id,License_Status__c,Start_Renewal_Workflow__c,Renewal_date__c,OwnerId,Provider_Status__c from Account  where License_Status__c = \'Licensed\' ' +
                        ' and Recordtype.Name = \'Family Child Care\'  ';
          Account acc1 = new Account();          
          Date cDate =  System.today();  
       
          acc1.Name = 'Test account 4';
          acc1.License_Status__c = 'Licensed';
          acc1.Provider_Status__c = 'Current';
          acc1.Provider_Email__c ='test@incapsulate.com';
          acc1.RecordTypeId = [select Id from RecordType where Name = 'Family Child Care' and SobjectType = 'Account'].Id;
          acc1.Provider_Address_1__c = 'Test address';
          acc1.Provider_City__c = 'a0Ej0000002fMa2';
          acc1.Provider_Zip_Code__c = '99999';
          acc1.Language__c = 'English';
          acc1.Preferred_Language__c = 'English';
          acc1.Start_Renewal_Workflow__c = false;
          acc1.Provider_Status__c = 'Current';
          acc1.Renewal_date__c = cdate +10; 
          insert acc1;
          Test.startTest(); 
             EEC_BatchFCCLicenseRenewal sfbatchSync = new EEC_BatchFCCLicenseRenewal(query);
             ID batchprocessid = Database.executeBatch(sfbatchSync);
          Test.stopTest();         
          
          Account acc = new Account();
          acc = [Select Id,Start_Renewal_Workflow__c,Renewal_date__c,OwnerId,Provider_Status__c from Account  where id = :acc1.id];          
          AsyncApexJob job  = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                                    FROM AsyncApexJob WHERE Id =:batchprocessid];
                //assert for total number of errors
            System.assertEquals(job.NumberOfErrors, 0);            
                                 
      
    }
}