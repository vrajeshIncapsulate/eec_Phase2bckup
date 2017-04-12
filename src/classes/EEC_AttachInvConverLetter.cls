public with sharing class EEC_AttachInvConverLetter extends EEC_BaseInvAttachPDF {

    public EEC_AttachInvConverLetter (ApexPages.StandardController stdController){
        super(stdController);
    }

    public override String pdfName(){
        return 'CoverLetter-';
    }
    
    public override PageReference pdfPageReference(){
        return Page.EEC_GenerateInvestigationCoverLetter;
    }
    
    public override void updateObject(Investigation__c i){
        i.Cover_Letter_issue_date__c = System.Today();
        i.Sent_Date__c = System.Today();
        i.Investigation_Status__c = 'Ready to Publish/Send to Provider';
        update i;
    }
}