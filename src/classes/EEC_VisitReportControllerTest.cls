/**
 * EEC_VisitReportControllerTest
 * 
 */

@isTest
public class EEC_VisitReportControllerTest {
    
    static testMethod void testInitializeVisitReportController() {
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.currentPage().getParameters().put('visitID',insp.Id);
        EEC_VisitReportController vr = new EEC_VisitReportController();
    }

}