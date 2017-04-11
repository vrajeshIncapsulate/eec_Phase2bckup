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
private class TestInspectVisitModeController {

    static testMethod void testVisitModeController() {
        // Setup test defaults.
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c from Inspection__c where Id = :insp.Id];
        Inspection_Item__c inspItem = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        Inspection_Item__c inspItemDeleted = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        Test.startTest();
        // Test the sort direction default when no expression is present.
        ivm.sortExpression = null;
        System.assertEquals(ivm.getSortDirection(), 'ASC');
       
        ivm.selectedCategoryFilter = 'NS';
        ivm.selectedResultFilter = 'NoneSelected';
        ivm.setSortDirection('ASC');
        ivm.sortExpression = 'name';
        // Call a 2nd time to hit alternate flow.
        ivm.sortExpression = 'name';
        ivm.getSortDirection();
        ivm.getCatFilterOptions();
        ivm.getFilterOptions();
        ivm.getInspectionItemData();
        ivm.lockVisitMode();
        ivm.Save();
        ivm.SaveAndCloseVisitMode();
        ivm.NewVisitItemTabletView();
        ivm.SaveItems();
        Test.stopTest();
        //ivm.MarkCompliantTabletView();
        
        System.assertNotEquals(null, ivm.SaveAndAddNewVisitItem());
        System.assertEquals(null, ivm.MarkCompliant());
        
        
    }
    static testMethod void testDeleteVisitMode(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c from Inspection__c where Id = :insp.Id];
        Inspection_Item__c inspItem = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        Inspection_Item__c inspItemDeleted = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        PageReference pageRef = Page.InspectVisitMode;
        pageRef.getParameters().put('itemId',inspItem.Id);
        Test.startTest();
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

        // Add a simple list to the controller.
        ivm.lockVisitMode();
        iiWrapperList.add(new InspectVisitModeController.InspectionListWrapper(0, new Inspection_Item__c(), null));
        ivm.iiWrapperList = iiWrapperList;
        // Test the marking of a compliant. 
        ivm.MarkCompliant();
        // Assert that the wrapper list has at least one element.
        System.assert(ivm.iiWrapperList.size() > 0 ? true : false);
        for(InspectVisitModeController.InspectionListWrapper iiw : ivm.iiWrapperList) {
            System.assertEquals('Compliant', iiw.result);
            break;
        }
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        InspectVisitModeController.InspectionListWrapper ilw = new InspectVisitModeController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        InspectVisitModeController.InspectionListWrapper ilwDeleted = new InspectVisitModeController.InspectionListWrapper(0, inspItemDeleted, null);
        ilwDeleted.isDeleted = true;
        iiWrapperList.add(ilwDeleted);
        // Set the wrapper list in the controller.
        ivm.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        ivm.Save();
        
        // Set a null deleteIndex for false path.
        ApexPages.currentPage().getParameters().put('deleteIndex','');
        System.assertEquals(null, ivm.DeleteInspectionItem());
        
        // Setup the positive path for DeleteInspectionItem().
    }
    static testMethod void testVisitMode() {
		List<InspectVisitModeController.InspectionListWrapper> iiWrapperList = new List<InspectVisitModeController.InspectionListWrapper>();

		Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        insp = [select Id, Provider_No__c,Provider_No__r.RecordType.Name, Name,Can_be_edited__c from Inspection__c where Id = :insp.Id];
		ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        InspectVisitModeController ivm = new InspectVisitModeController(sc);
        
		List<Inspection_Item__c> iiList = [SELECT Id from Inspection_Item__c where Inspection_no__c = :insp.Id];
        ApexPages.currentPage().getParameters().put('deleteIndex','0');
        ApexPages.currentPage().getParameters().put('deleteId',iiList.get(0).Id);
        //ivm.iiWrapperList = iiWrapperList;
        ivm.DeleteInspectionItem();


    }
}