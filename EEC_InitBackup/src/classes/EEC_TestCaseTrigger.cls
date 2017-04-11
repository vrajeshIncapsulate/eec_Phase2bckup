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
private class EEC_TestCaseTrigger {

    /*static testMethod void myUnitTest() {
        Account mockProvider = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    	Investigation__c i = EEC_TestUtil.mockInvestigation(mockProvider);
        Case c = EEC_TestUtil.mockCase(mockProvider, EEC_TestUtil.mockContact(), i);
        c.SendCaseTriageEmail__c = 'Recalled';
        c.TriggerTriageEscalationApproval__C = true;
        update c;
        c.SendCaseTriageEmail__c = 'Approved';
        update c;
        c.SendCaseTriageEmail__c = 'Rejected';
        update c;
    }*/

    static testMethod void testCaseTriggerHandlerEmail() {
        Test.startTest();
        EEC_CaseTriggerHandler.sendIEmail('test@test.com', 'Test', UserInfo.getUserId(), 'TestCaseEmail', 'investId', 'TestSubject', 'AccountName');
        Test.stopTest();
    }

    static testMethod void testEventTrigger() {
        RecordType r = [select Id from RecordType where DeveloperName='FCC' and sobjecttype='Account'];
        Account pAccount = new Account(
          name='TestProvider1',
          RecordTypeId=r.Id,
          Provider_Email__c='test@test.com',
          Provider_Address_1__c='123 Test St.',
          Provider_City__c=EEC_TestUtil.mockCity().Id,
          Provider_Zip_Code__c='B3H0A2');
        insert pAccount;
        // Use a visit obj.

        //Inspection_Item__c item = EEC_TestUtil.mockInspectionItem(EEC_TestUtil.mockInspection(pAccount), EEC_TestUtil.mockStdInspectionItem(), 'Test', true, 'Test');
        Inspection__c item = EEC_TestUtil.mockInspection(pAccount);
        System.debug('*****Item Id: ' + item.Id);

        Event event = new Event(
            DurationInMinutes = 14400,
            ActivityDateTime = DateTime.now(),
            WhatId = item.Id,
            EndDateTime = DateTime.now().addDays(10)
        );
        insert event;
        event.Description = 'Testing!';
        update event;
    }
    static testMethod void testUpdateEventTrigger() {
        Inspection__c[] item = [SELECT ID, Name,Announced__c FROM Inspection__c LIMIT 1];
		if (item.size() > 0)
        	item[0].Announced__c = true;
        update item;
    }
}