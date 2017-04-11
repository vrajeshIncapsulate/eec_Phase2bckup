/**
 * EEC_CorrectiveActionReviewControllerTest 
 * 
 * This class contains all the unit test behaviour for the EEC_CorrectiveActionReviewController class.
 * @author Darkis
 */

@isTest
private class EEC_CorrectiveActionReviewControllerTest {
    
    static ApexPages.StandardController setupTest() {
        // Setup basic defaults.
        ApexPages.StandardController sc = new ApexPages.StandardController(EEC_TestUtil.loadInspectionSetup());
        return sc;
    }

/*    static testMethod void testGetInspectionItemData() {
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        // Call constructor
        new EEC_CorrectiveActionReviewController(sc);
        // Check apex messages for failed message.
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
		System.assertNotEquals(0, pageMessages.size());
		// Check that the error message you are expecting is in pageMessages
		Boolean messageFound = false;
		// Loop through the page messages to assert the one we are looking for is found.
		for(ApexPages.Message message : pageMessages) {
    		if(message.getSummary() == 'This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director.' 
               && message.getSeverity() == ApexPages.Severity.ERROR) {
        		messageFound = true;        
    		}
		}	
        // Assert the message.
		//System.assert(messageFound);
    }*/
    
    static testMethod void testGetInspectionItemData(){
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        PageReference p = ctrl.getInspectionItemData();
    }

    static testMethod void testSortExpression() {
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        // Test setting and getting sortExpression.
        ctrl.sortExpression = 'ASC';
        System.assertEquals('ASC', ctrl.getSortDirection());
        // Check alternate flow for identical values.
        ctrl.sortExpression = 'ASC';
        System.assertEquals('DESC', ctrl.getSortDirection());
    }
    
    static testMethod void testSortDirection() {
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        // Test the sort direction default when no expression is present.
        ctrl.sortExpression = null;
        System.assertEquals(ctrl.getSortDirection(), 'ASC');
        // Set direction to DESC but expression is still null forcing ASC.
        ctrl.setSortDirection('DESC');
        System.assertEquals('ASC', ctrl.getSortDirection());
        // Set the sort expression to allow direction to proceed without being defaulted to ASC.
        ctrl.sortExpression = 'DESC';
        ctrl.setSortDirection('DESC');
        System.assertEquals('DESC', ctrl.getSortDirection());
    }
    

    static testMethod void testSave() {
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        // Call the save method.
        ctrl.Save();
    }
    
    static testMethod void testSaveAndCloseVisitMode() {
        ApexPages.StandardController sc = EEC_CorrectiveActionReviewControllerTest.setupTest();
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        // Call the save and close visit method.
        ctrl.SaveAndCloseVisitMode();
    }
    
    static testMethod void testSaveInspectionItems() {
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        Inspection_Item__c inspItem = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        Inspection_Item__c inspItemDeleted = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');
        List<EEC_CorrectiveActionReviewController.InspectionListWrapper> iiWrapperList = new List<EEC_CorrectiveActionReviewController.InspectionListWrapper>();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        EEC_CorrectiveActionReviewController ctrl = new EEC_CorrectiveActionReviewController(sc);
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<EEC_CorrectiveActionReviewController.InspectionListWrapper>();
        // Create and add a new InspectionListWrapper.
        EEC_CorrectiveActionReviewController.InspectionListWrapper ilw = new EEC_CorrectiveActionReviewController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        // Create and add a new InspectionListWrapper that is expected to be deleted.
        EEC_CorrectiveActionReviewController.InspectionListWrapper ilwDeleted = new EEC_CorrectiveActionReviewController.InspectionListWrapper(0, inspItemDeleted, null);
        ilwDeleted.isDeleted = true;
        iiWrapperList.add(ilwDeleted);
        // Set the wrapper list in the controller.
        ctrl.iiWrapperList = iiWrapperList;
        // Attempt to update and save the items.
        ctrl.Save();
    }
    
    static testMethod void testInspectionListWrapper() {
        new EEC_CorrectiveActionReviewController.InspectionListWrapper(0, new Inspection_Item__c(), null);
    }
}