/**
 * EEC_BatchRestraintReportTest
 * 
 * This class will contain all the test methods for the EEC_BatchRestraintReport class.
 * @author Madhav Kuchimanchi
 */

@isTest
private class EEC_BatchRestraintReportTest {   
   
   
  static testMethod void testscenario1() {
         String query ='Select Id,Restraint_Report_Automation__c from Account  where Use_Physical_Restraints__c = true' +
                        ' and Recordtype.Name in (\'Temporary Shelter\' ,\'Group Care\')';                    

          Account acc1 = new Account();          
          Date cDate =  System.today();  
          // Scenario 1 : Renewal Application Not Submitted - 30 days prior to  expiration notice
          acc1.Name = 'Test account 1 ';
          acc1.License_Status__c = 'Licensed';
          acc1.Provider_Status__c = 'Current';
          acc1.Provider_Email__c ='test@incapsulate.com';
          acc1.RecordTypeId = [select Id from RecordType where Name = 'Temporary Shelter' and SobjectType = 'Account'].Id;
          acc1.Provider_Address_1__c = 'Test address';
          acc1.Provider_City__c = 'a0Ej0000002fMa2';
          acc1.Provider_Zip_Code__c = '99999';
          acc1.Language__c = 'English';
          acc1.Preferred_Language__c = 'English';
          acc1.Use_Physical_Restraints__c = true;
          acc1.Restraint_Method__c = 'TCI';
          acc1.Renewal_date__c = cdate +30; 
          //acclist.add(acc1);
          insert acc1;               
                                
          Test.startTest(); 
             EEC_BatchRestraintReport sfbatchSync = new EEC_BatchRestraintReport(query);
             ID batchprocessid = Database.executeBatch(sfbatchSync);
          Test.stopTest();
          Account acc = new Account();
          acc = [Select Id,Restraint_Report_Automation__c from Account  where id = :acc1.id];
          AsyncApexJob job  = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                                    FROM AsyncApexJob WHERE Id =:batchprocessid];
                //assert for total number of errors
          System.assertEquals(job.NumberOfErrors, 0);            
          System.assertEquals(acc.Restraint_Report_Automation__c,true);                   
            
   }   
}