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
private class EEC_TestCopyInspectionsItemsController {

    static testMethod void TestCopyStandardInspectionItems() {
    	
    	Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
    	insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Can_be_edited__c, Mater_Visit_for_Res_Cluster_of_Visits__c from Inspection__c where Id = :insp.Id];
    	ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        EEC_CopyInspectionsItemsController ciic = new EEC_CopyInspectionsItemsController(sc);
        ciic.populateLists();
        for(EEC_CopyInspectionsItemsController.SCRWrapper scrw : ciic.scrWrapperList){
        	scrw.selected = true;
        }
        ciic.copyInspectionItems();
    	
    	List<Inspection_Item__c> iiList = [select Id from Inspection_Item__c where Inspection_No__c = :insp.Id];
    	System.assertEquals(4, iiList.size());
    	
    }
    
    
}