public with sharing class EEC_AttachGeneratedNarrativePDF extends EEC_BaseAttachPDF {

    public EEC_AttachGeneratedNarrativePDF(ApexPages.StandardController stdController){
        super(stdController);
    }
      
    public override void updateObject(Inspection__c obj){
      obj.Visit_Narrative_Issue_Date__c = System.Today();
      update obj;
    }
    
    public override void updateChildObjects(List<Inspection__c> childVisits){
      for (Inspection__c obj : childVisits) {
        obj.Visit_Narrative_Issue_Date__c = System.Today();
      }
      System.debug('----> ChildVisits: ' + childVisits);
      update childVisits;
    }
    
    public override String pdfName(){
        return 'Narrative-';
    }
    
    public override PageReference pdfPageReference(){
        return Page.EEC_GenerateVisitNarrativePDF;
    }
       
}