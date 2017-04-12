public with sharing class EEC_AttachGeneratedCoverLetterPDF extends EEC_BaseAttachPDF {

    public EEC_AttachGeneratedCoverLetterPDF (ApexPages.StandardController stdController){
        super(stdController);
    }
       
    public override void updateObject(Inspection__c obj){
      obj.Cover_letter_issue_date__c = System.Today();
      obj.Status__c = 'Report Sent to Provider, Awaiting feedback';
      update obj;
    }
    
    public void updateObjectAfterCoverLetter(Inspection__c obj){
      obj.Cover_letter_issue_date__c = System.Today();
      obj.Sent_date__c = System.Today();  
      obj.Status__c = 'Report Sent to Provider, Awaiting feedback';
      update obj;
    }
    
    public override void updateChildObjects(List<Inspection__c> childVisits){
      for (Inspection__c obj : childVisits) {
        obj.Cover_letter_issue_date__c = System.Today();
        obj.Status__c = 'Report Sent to Provider, Awaiting feedback';
      }
      update childVisits;
    }
    
    public override String pdfName(){
        return 'CoverLetter-';
    }
    
    public override PageReference pdfPageReference(){
        return Page.EEC_GenerateVisitCoverLetter;
    }
       
}