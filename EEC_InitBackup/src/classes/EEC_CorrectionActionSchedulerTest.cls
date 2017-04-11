/**
 * EEC_CorrectionActionSchedulerTest
 * 
 * This class will contain all the test methods for the EEC_CorrectionActionScheduler class.
 * @author Darkis
 */

@isTest
private class EEC_CorrectionActionSchedulerTest {
    
    public static String CRON_EXP = '0 0 0 1 1 ? 2025'; 
    
	static testMethod void testScheduler() {
    	Test.startTest(); 
            // Schedule the test job.
            String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new EEC_CorrectionActionScheduler());
        	// Get the information from the CronTrigger API object
      		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
			// Verify the expressions are the same
        	System.assertEquals(CRON_EXP, ct.CronExpression); 
        	// Verify the job has not run
       		System.assertEquals(0, ct.TimesTriggered);
        	// Verify the next time the job will run
        	System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
    
    static testMethod void testBatch() {
    	Test.startTest();
    	Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
    	
        EEC_CorrectionAction ca = new EEC_CorrectionAction('Select Id,Provider_No__r.OwnerId,Inspector_del__c,Number_of_non_compliant_items__c,Number_of_Items_with_Corrective_Actions__c from Inspection__c');
        Database.executeBatch(ca);
        Test.stopTest();
        
    }
}