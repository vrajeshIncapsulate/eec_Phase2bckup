public abstract with sharing class EEC_BaseInvAttachPDF {

    protected PageReference pageReference { get; set; }
    protected String id { get; set; }
    protected Investigation__c obj { get; set; }
    
    public EEC_BaseInvAttachPDF(ApexPages.StandardController stdController){
        this.id = stdController.getId();
        this.obj = [SELECT Name FROM Investigation__c WHERE Id = :id];
    }
    
    public pageReference savePDF(){
        PageReference pagePdf = pdfPageReference();
        pagePdf.getParameters().put('id', id);
        Blob pdfPageBlob;
        pdfPageBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPDF();
             
        Attachment a = new Attachment();
        a.Body = pdfPageBlob;
        a.ParentID = id;
        a.Name = pdfName() + obj.Name + '.pdf';
        insert a;
        
        updateObject(obj);
        
        return new PageReference('/' + id);
    }
    
    protected abstract PageReference pdfPageReference();
    protected abstract String pdfName();
    protected abstract void updateObject(Investigation__c obj);
}