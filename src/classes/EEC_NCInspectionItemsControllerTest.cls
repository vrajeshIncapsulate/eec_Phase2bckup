/**
 * EEC_NCInspectionItemsControllerTest
 * 
 */

@isTest
public class EEC_NCInspectionItemsControllerTest {
	    
    static testMethod void testEEC_NCInspection() {
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_NCInspectionItemsController ctrl = new EEC_NCInspectionItemsController(sc);
    }
    
    static testMethod void testgetNCInspItemList(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_NCInspectionItemsController ctrl = new EEC_NCInspectionItemsController(sc);
        
        List<Inspection_Item__c> inspItems = ctrl.getNCInspItemList();
    }

    static testMethod void testgetNonCompliantItemList(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_NCInspectionItemsController ctrl = new EEC_NCInspectionItemsController(sc);
        
        List<Non_Compliant__c> ncItems = ctrl.getNonCompliantItemList();
    }

    static testMethod void testgetAllNonCompliantCombinedList(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_NCInspectionItemsController ctrl = new EEC_NCInspectionItemsController(sc);
        
        List<EEC_NCInspectionItemsController.NCInspectionItemsWrapper> ncCombinedItems = ctrl.getAllNonCompliantItemsCombined();
    }

    static testMethod void testNCInspectionItemsWrapper(){
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        
        EEC_NCInspectionItemsController ctrl = new EEC_NCInspectionItemsController(sc);
        EEC_NCInspectionItemsController.NCInspectionItemsWrapper testCtrl = new EEC_NCInspectionItemsController.NCInspectionItemsWrapper(null, null);
        System.assertNotEquals(testCtrl, null);
    }
}