public with sharing class EEC_AttachInvNarrative extends EEC_BaseInvAttachPDF {

    public EEC_AttachInvNarrative (ApexPages.StandardController stdController){
        super(stdController);
    }

    public override String pdfName(){
        return 'Narrative-';
    }
    
    public override PageReference pdfPageReference(){
        return Page.EEC_GenerateInvNarrative;
    }
    
    public override void updateObject(Investigation__c i){
        i.Report_Narrative_Issue_Date__c = System.Today(); 
        update i;
    }
}