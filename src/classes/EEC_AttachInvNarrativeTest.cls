/**
 * EEC_AttachInvNarrativeTest
 * 
 * This class contains all the unit test behaviours for the EEC_AttachInvNarrative class.
 * @author Darkis
 */

@isTest
private class EEC_AttachInvNarrativeTest {
    
    static EEC_AttachInvNarrative setup() {
        Investigation__c invest = EEC_TestUtil.loadInvestigationSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(invest);
        // Call constructor.
        EEC_AttachInvNarrative ctrl = new EEC_AttachInvNarrative(sc);   
        return ctrl;
    }
    
    static testMethod void testEEC_AttachInvNarrative() {
        EEC_AttachInvNarrativeTest.setup();
    }
    
    static testMethod void testPdfName() {
        EEC_AttachInvNarrative ctrl = EEC_AttachInvNarrativeTest.setup();
        System.assertEquals('Narrative-', ctrl.pdfName());
    }
    
    static testMethod void testPdfPageReference() {
        EEC_AttachInvNarrative ctrl = EEC_AttachInvNarrativeTest.setup();
        System.assertEquals(Page.EEC_GenerateInvNarrative.getUrl(), (ctrl.pdfPageReference()).getUrl());
    }
    
    static testMethod void testUpdateObject() {
        Investigation__c invest = EEC_TestUtil.loadInvestigationSetup();
        Date orgDate = invest.Report_Narrative_Issue_Date__c;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(invest);
        EEC_AttachInvNarrative ctrl = new EEC_AttachInvNarrative(sc);   
        
        ctrl.updateObject(invest);
        System.assertNotEquals([SELECT Report_Narrative_Issue_Date__c FROM Investigation__c WHERE Id = :invest.Id].Report_Narrative_Issue_Date__c, orgDate);
    }
    
    static testMethod void testSavePdf() {
        EEC_AttachInvNarrative ctrl = EEC_AttachInvNarrativeTest.setup();
        ctrl.savePdf();
    }
}