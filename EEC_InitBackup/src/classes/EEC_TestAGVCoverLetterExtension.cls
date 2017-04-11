@isTest
public with sharing class EEC_TestAGVCoverLetterExtension {
    
    @isTest static void testSavePDF(){
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c sii1 = EEC_TestUtil.mockStdInspectionItem();
        Regulation__c reg1 = EEC_TestUtil.mockRegulation();
        Regulation__c reg2 = EEC_TestUtil.mockRegulation();
        EEC_TestUtil.mockRegStdInsp(reg1, sii1);
        EEC_TestUtil.mockRegStdInsp(reg2, sii1);
        Inspection_Item__c ii1 = EEC_TestUtil.mockInspectionItem(i, sii1 , 'Non-Compliant', false, null);
        Inspection_Item__c ii2 = EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation() , 'Non-Compliant', false, null);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(i);
        EEC_AttachGeneratedCoverLetterPDF ext = new EEC_AttachGeneratedCoverLetterPDF(stdController);
        PageReference pr = ext.savePDF();
        
        List<Attachment> attachments = [SELECT Name FROM Attachment WHERE ParentID = :i.Id];
        i = [SELECT Cover_letter_issue_date__c, Status__c, Name  FROM Inspection__c WHERE ID = :i.Id];
        
        System.assertEquals(new PageReference('/' + stdController.getId()).getUrl(), pr.getUrl()); 
        System.assertEquals('Report Sent to Provider, Awaiting feedback', i.Status__c);
        System.assertEquals(System.Today(), i.Cover_letter_issue_date__c);
        System.assertEquals(1, attachments.size());
        System.assertEquals(ext.pdfName() + i.Name + '.pdf', attachments.get(0).Name);
        
    }
}