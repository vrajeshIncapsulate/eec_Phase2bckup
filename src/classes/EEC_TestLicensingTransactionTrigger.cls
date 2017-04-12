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
private class EEC_TestLicensingTransactionTrigger {

    static testMethod void testLicensingTransactionTrigger() {
    	EEC_TestUtil.mockLeadConfig('Family Child Care', null);
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.MockCity());
        RecordType r = [select Id from RecordType where DeveloperName='FCC_Change_of_Household' and sobjecttype='Licensing_Transaction__c'];
        Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId=r.Id,Status__c='Submitted', Provider__c=accnt.Id,Submitter__c=Userinfo.getUserId());
        insert lic;
        EEC_TestUtil.mockHouseHold(lic, accnt);
    	
    }
   
   /*static testMethod void testLTRenewal() {
    	EEC_TestUtil.mockLeadConfig('Family Child Care', null);
        Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.MockCity());
        RecordType r = [select Id from RecordType where DeveloperName='FCC_Renewal' and sobjecttype='Licensing_Transaction__c'];
        Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId=r.Id,Status__c='Submitted', Provider__c=accnt.Id,Submitter__c=Userinfo.getUserId());
        insert lic;
        EEC_TestUtil.mockHouseHold(lic, accnt);
    	
    }
    
    static testMethod void testLTChangeOfHousehold() {
    	Account accnt = EEC_TestUtil.loadLicenseTransaction();
    	RecordType r = [select Id from RecordType where DeveloperName='FCC_Change_of_Household' and sobjecttype='Licensing_Transaction__c'];
        Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId=r.Id,Status__c='Submitted', Provider__c=accnt.Id,Submitter__c=Userinfo.getUserId());
        insert lic;
        EEC_TestUtil.mockHouseHold(lic, accnt);
    	
    }*/
    
}