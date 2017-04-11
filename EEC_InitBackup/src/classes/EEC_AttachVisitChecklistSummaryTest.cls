@isTest
public class EEC_AttachVisitChecklistSummaryTest {
    static testMethod void testSavePDF() {        
        // Setup basic defaults.
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        EEC_AttachVisitChecklistSummary ctrl = new EEC_AttachVisitChecklistSummary(sc); 
        ctrl.visitId = insp.Id;
        ctrl.visit = insp;
        // Call the controller method.
        ctrl.savePDF();
    }
}