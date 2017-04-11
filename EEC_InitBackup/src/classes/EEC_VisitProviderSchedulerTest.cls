/**
 * EEC_VisitProviderSchedulerTest
 * 
 * This class will contain all the test methods for the EEC_VisitProviderScheduler class.
 * 
 */

@isTest
public class EEC_VisitProviderSchedulerTest {
    
  public static String CRON_EXP = '0 0 0 1 1 ? 2025'; 
    
  static testMethod void test() {
      Test.startTest(); 
          String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new EEC_VisitProviderScheduler());
          // Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
          System.assertEquals(CRON_EXP, ct.CronExpression); 
          // Verify the job has not run
           System.assertEquals(0, ct.TimesTriggered);
          // Verify the next time the job will run
          System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
      Test.stopTest();
    }

}