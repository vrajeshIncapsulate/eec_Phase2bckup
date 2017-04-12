public with sharing class EEC_AttachVisitChecklistSummary {

    public String visitId { get;set; }
    public Inspection__c visit;

    public EEC_AttachVisitChecklistSummary(ApexPages.StandardController stdController){
    }
     
    public pageReference savePDF(){
         
      PageReference pagePdf = Page.EEC_GenerateVisitChecklistPDF; 
      pagePdf.getParameters().put('id', visitId);
      
      Blob pdfPageBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPDF();
      
      Attachment a = new Attachment();
      a.Body = pdfPageBlob;
      a.ParentID = visitId;
      a.Name = visitId + '-checklist' + '.pdf';
      insert a;
      
      return new PageReference('/' + visitId);
    }
}