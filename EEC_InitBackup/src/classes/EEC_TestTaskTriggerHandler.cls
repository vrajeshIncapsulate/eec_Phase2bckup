/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class EEC_TestTaskTriggerHandler {

    static testMethod void testTaskTrigger() {
    	Lead l = EEC_TestUtil.mockLead();
    	System.assert(l.Status != 'Attended');
        Task t = EEC_TestUtil.mockTask('Mail merge document(s) generated: 75 - FCC PPM Meeting - Certificate of Attendance',l.Id);
        l = [select Id,status,PPM_Meeting_Attended_Date__c from Lead where Id =:l.Id];
        System.assertEquals(l.Status,'Attended');
        System.assert(l.PPM_Meeting_Attended_Date__c != null);
    }
}