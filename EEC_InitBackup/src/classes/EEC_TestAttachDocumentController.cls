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
private class EEC_TestAttachDocumentController {

    static testMethod void attachDocumentControllerTest() {
    	
    	Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
    	RecordType rType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Additional_Inspection_Item'];
    	List<Inspection_Item__c> iItemList = [select Id from Inspection_Item__c where Inspection_no__c = :insp.Id and RecordTypeId = :rType.Id];
    	Inspection_Item__c iItem = iItemList.get(0);
    	//insert iItem;
    	
    	
		
    	ApexPages.currentPage().getParameters().put('iiId',iItem.Id);
    	EEC_AttachDocumentController rvc = new EEC_AttachDocumentController();
    	
    	Attachment attach=rvc.attachment;    
    	attach.Name='Inspection Item Attachment';
		Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
		attach.body=bodyBlob;
    	rvc.upload();
    }
}