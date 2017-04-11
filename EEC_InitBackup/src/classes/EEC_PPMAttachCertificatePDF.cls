public class EEC_PPMAttachCertificatePDF {

     public Lead ld;
    
     public EEC_PPMAttachCertificatePDF(ApexPages.StandardController std){
        Id id = std.getId();
        ld = [SELECT Id,Name FROM Lead WHERE Id = :id]; 
    }
    
     public PageReference savePDF(){
        PageReference pagePdf = pdfPageReference();
        pagePdf.getParameters().put('id', ld.id); 
             
        
        Attachment a = new Attachment();
        a.Body = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPdf();
        a.ParentID = ld.ID;
        a.Name = 'Attendance Certificate-' + ld.Name + '.pdf';
        
        insert a;
                 
        return new PageReference('/' + ld.Id);
    }
    
     public PageReference pdfPageReference(){
        return Page.EEC_PPMAttendanceCertificatePDF;
    } 
}