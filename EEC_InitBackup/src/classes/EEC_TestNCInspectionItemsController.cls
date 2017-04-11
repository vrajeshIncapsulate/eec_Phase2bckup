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
private class EEC_TestNCInspectionItemsController {

    static testMethod void NCInspectionItemsControllerTest() {
    	Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
    	Account accnt = [select Id, Name from Account where Id =:insp.Provider_No__c];
    	Inspection__c insp1 = EEC_TestUtil.mockInspection(accnt);
    	insp.Original_Visit__c = insp1.Id;
    	update insp;
    	Inspection__c inspRecord = [select id,Date_of_Visit__c,name,createddate,Provider_No__c,Provider_No__r.recordtypeid,Original_Visit__c from inspection__c where id = :insp.id];
    	ApexPages.StandardController sc = new ApexPages.StandardController(inspRecord);
        EEC_NCInspectionItemsController nci = new EEC_NCInspectionItemsController(sc);
        nci.getNCInspItemList();
    }
}