/**
 * EEC_AttachInvConverLetterTest
 * 
 * This class will contain all the unit test behaviours for the EEC_AttachInvConverLetter class.
 * @author Darkis
 */

@isTest
private class EEC_AttachInvConverLetterTest {
	
    static EEC_AttachInvConverLetter setup() {
        Investigation__c invest = EEC_TestUtil.loadInvestigationSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(invest);
        // Call constructor.
        EEC_AttachInvConverLetter ctrl = new EEC_AttachInvConverLetter(sc);   
        return ctrl;
    }
    
    static testMethod void testEEC_AttachInvNarrative() {
        EEC_AttachInvConverLetterTest.setup();
    }
    
    static testMethod void testPdfName() {
        EEC_AttachInvConverLetter ctrl = EEC_AttachInvConverLetterTest.setup();
        System.assertEquals('CoverLetter-', ctrl.pdfName());
    }
    
    static testMethod void testPdfPageReference() {
        EEC_AttachInvConverLetter ctrl = EEC_AttachInvConverLetterTest.setup();
        System.assertEquals(Page.EEC_GenerateInvestigationCoverLetter.getUrl(), (ctrl.pdfPageReference()).getUrl());
    }
    
    static testMethod void testUpdateObject() {
        Investigation__c invest = EEC_TestUtil.loadInvestigationSetup();
		invest.Cover_Letter_Issue_Date__c = Date.today().addDays(-15);        
        invest.Sent_Date__c = Date.today().addDays(-15);
        update invest;
        // Original dates.
        Date orgCoverIssueDate = invest.Cover_Letter_Issue_Date__c;
        Date orgSentDate = invest.Sent_Date__c;
                
        ApexPages.StandardController sc = new ApexPages.StandardController(invest);
        EEC_AttachInvConverLetter ctrl = new EEC_AttachInvConverLetter(sc);   
        ctrl.updateObject(invest);
        // Assert the dates are different from the updated dates. 
        System.assertNotEquals(invest.Cover_Letter_issue_date__c, orgCoverIssueDate);
        System.assertNotEquals(invest.Sent_Date__c, orgSentDate);
        System.assertEquals('Ready to Publish/Send to Provider', invest.Investigation_Status__c);
    }
}