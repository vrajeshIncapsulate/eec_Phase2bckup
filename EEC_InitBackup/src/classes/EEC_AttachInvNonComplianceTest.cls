/**
 * EEC_AttachInvNonComplianceTest
 * 
 * This class contains all the unit test behaviours for the EEC_AttachInvNarrative class.
 * @author Darkis
 */

@isTest
private class EEC_AttachInvNonComplianceTest {
    
    static EEC_AttachInvNonCompliance setup() {
        Investigation__c invest = EEC_TestUtil.loadInvestigationSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(invest);
        // Call constructor.
        EEC_AttachInvNonCompliance ctrl = new EEC_AttachInvNonCompliance(sc);   
        return ctrl;
    }
    
    static testMethod void testEEC_AttachInvNarrative() {
        EEC_AttachInvNonComplianceTest.setup();
    }
    
    static testMethod void testPdfName() {
        EEC_AttachInvNonCompliance ctrl = EEC_AttachInvNonComplianceTest.setup();
        System.assertEquals('NonCompliance-', ctrl.pdfName());
    }
    
    static testMethod void testPdfPageReference() {
        EEC_AttachInvNonCompliance ctrl = EEC_AttachInvNonComplianceTest.setup();
        System.assertEquals(Page.EEC_GenerateInvestigationNCLetter.getUrl(), (ctrl.pdfPageReference()).getUrl());
    }
    
    static testMethod void testUpdateObject() {
        Investigation__c invest = EEC_TestUtil.loadInvestigationSetup();
        Date orgDate = invest.Statement_of_non_compliance_Issue_Date__c;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(invest);
        EEC_AttachInvNonCompliance ctrl = new EEC_AttachInvNonCompliance(sc);   
        
        ctrl.updateObject(invest);
        System.assertNotEquals([SELECT Statement_of_non_compliance_Issue_Date__c FROM Investigation__c WHERE Id = :invest.Id].Statement_of_non_compliance_Issue_Date__c, orgDate);
    }
    
    static testMethod void testSavePdf() {
        EEC_AttachInvNonCompliance ctrl = EEC_AttachInvNonComplianceTest.setup();
        ctrl.savePdf();
    }
}