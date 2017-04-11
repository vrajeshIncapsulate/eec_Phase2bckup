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
private class EEC_TestUserTriggerHandler {

    static testMethod void testActiveAccount() {
    	Account accnt = createAccount();
    	System.assertEquals(accnt.Electronic_Communication__c,false);
    	System.assertEquals(accnt.Provider_Email__c,null);
    	Contact cntct = EEC_TestUtil.mockDirectorContact(accnt);
    	User usr = EEC_TestUtil.mockPortalUser(cntct);
    	accnt = [select Id,Electronic_Communication__c,Provider_Email__c from Account where Id = :accnt.Id];
    	System.assertEquals(accnt.Electronic_Communication__c,true);
    	System.assertEquals(accnt.Provider_Email__c,usr.Email);
    }
    static testMethod void testInActiveAccount() {
    	Account accnt = createAccount();
    	List<Task> tskList = [select Id from Task where WhatId = :accnt.Id];
    	Contact cntct = EEC_TestUtil.mockDirectorContact(accnt);
    	User usr = EEC_TestUtil.mockPortalUser(cntct);
        System.runAs(new User(Id = UserInfo.getUserId())) {
          usr.isportalenabled=false;
		  database.update(usr);    
        }
		Map<Id,Id> accntIdMap = new Map<Id,Id>();
		accntIdMap.put(accnt.Id,usr.Id);
		EEC_UserTriggerHandler.createTasks(accntIdMap);
	}
    
   private static Account createAccount(){
   		RecordType r = [select Id from RecordType where DeveloperName='FCC' and sobjecttype='Account'];
        Account pAccount = new Account(name='TestProvider1',RecordTypeId=r.Id);
        pAccount.Provider_City__c = EEC_TestUtil.mockCity().Id;
        pAccount.Name = 'Test User';
        pAccount.Provider_Address_1__c = 'Fake Adres 123';
        pAccount.Provider_Zip_Code__c = '12345';
        pAccount.Renewal_date__c = Date.today();
        pAccount.license_status__c = 'Licensed';
        pAccount.Region__c = EEC_TestUtil.mockRegion().Id;
        pAccount.Electronic_Communication__c = false;
        insert pAccount;
        return pAccount;
   }
}