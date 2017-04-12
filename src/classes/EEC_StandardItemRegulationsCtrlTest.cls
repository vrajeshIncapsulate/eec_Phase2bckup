/**
 * EEC_StandardItemRegulationsCtrlTest
 * 
 * This test class covers the unit test behaviours for the EEC_StandardItemRegulationsController class.
 * @author Darkis
 */

@isTest
private class EEC_StandardItemRegulationsCtrlTest {
	
    static testMethod void testGetRegulationNames() {
        Standard_Inspection_Item__c stdInspectItem = EEC_TestUtil.mockStdInspectionItem();
        Junction_InspReg__c mockJuncObj = EEC_TestUtil.mockRegStdInsp(EEC_TestUtil.mockRegulation(), stdInspectItem);
        
        EEC_StandardItemRegulationsController controller = new EEC_StandardItemRegulationsController();
        controller.itemId = stdInspectItem.Id;
        
        System.debug('Result of request: ' + controller.getRegulationNames());        
        
        Junction_InspReg__c inspReg = [SELECT Regulation__r.Name FROM Junction_InspReg__c WHERE Standard_Inspection_Item__c = :stdInspectItem.Id];
        System.assertEquals(inspReg.Regulation__r.Name, controller.getRegulationNames());
    }
}