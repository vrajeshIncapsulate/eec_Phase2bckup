public class EEC_LicenseCertificatePDF {

     public Licensing_Transaction__c ld;
    
     public EEC_LicenseCertificatePDF(ApexPages.StandardController std){
        Id id = std.getId();
        ld = [SELECT Id,Name FROM Licensing_Transaction__c WHERE Id = :id]; 
   	 }
     
     public PageReference savePDF(){
        PageReference pagePdf = pdfPageReference();
        pagePdf.getParameters().put('id', ld.id); 
             
        
        Attachment a = new Attachment();
        a.Body = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPdf();
        a.ParentID = ld.ID;
        a.Name = 'License Certificate-' + ld.Name + '.pdf';
        
        insert a;
                 
        return new PageReference('/' + ld.Id);
    }
    
     public PageReference pdfPageReference(){
        return Page.EEC_LicenseCertificatePDF;
    } 
}