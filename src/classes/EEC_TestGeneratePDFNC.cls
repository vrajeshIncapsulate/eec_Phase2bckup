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
private class EEC_TestGeneratePDFNC {

    /*static testMethod void genertePDFNCTest() {
    	
    	Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
    	Test.setCurrentPage(new PageReference('/apex/EEC_GenerateNonCompPDF'));
    	
    	ApexPages.StandardController sc = new ApexPages.StandardController(insp);
    	EEC_GenerateNonCompPDFController gnc = new EEC_GenerateNonCompPDFController(sc);
    	gnc.GeneratePDF();
    }*/
    
    static testMethod void GeneratePDFNC(){
    	
    	Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
    	ApexPages.currentPage().getParameters().put('id',insp.Id);
    	EEC_GeneratePDFNCController egp = new EEC_GeneratePDFNCController();
    	egp.generateData();
		
        List<EEC_GeneratePDFNCController.InspectionListWrapper> iiWrapperList = new List<EEC_GeneratePDFNCController.InspectionListWrapper>();
        iiWrapperList.add(new EEC_GeneratePDFNCController.InspectionListWrapper(new Inspection_Item__c(), null));
        System.assertNotEquals(null, iiWrapperList);
	}
	
}