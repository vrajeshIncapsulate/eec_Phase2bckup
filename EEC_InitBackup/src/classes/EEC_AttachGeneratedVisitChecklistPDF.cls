public with sharing class EEC_AttachGeneratedVisitChecklistPDF extends EEC_BaseAttachPDF {

    public EEC_AttachGeneratedVisitChecklistPDF(ApexPages.StandardController stdController){
        super(stdController);
    }
      
    public override void updateObject(Inspection__c obj){
      obj.Checklist_Summary_issue_date__c = System.Today();
      update obj;
    }
      
    public override void updateChildObjects(List<Inspection__c> childVisits){
      for (Inspection__c obj : childVisits) {
        obj.Checklist_Summary_issue_date__c = System.Today();
      }
      update childVisits;
    }
    
    public override String pdfName(){
       //Mod by LD on 10/15/15 per Task#LEAD-2254
        //return 'CheckList-';
        return 'Visit Summary-';
    }
    
    public override PageReference pdfPageReference(){
        return Page.EEC_GenerateVisitChecklistPDF_v2;
    }
}