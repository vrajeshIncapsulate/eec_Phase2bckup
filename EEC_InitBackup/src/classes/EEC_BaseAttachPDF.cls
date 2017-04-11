public abstract with sharing class EEC_BaseAttachPDF {

    protected PageReference pageReference { get; set; }
    protected String id { get; set; }
    protected Inspection__c obj { get; set; }
    protected List<Inspection__c> childVisits {get;set;}
    private List<Attachment> attachmentsToInsert {get;set;}
    
    public EEC_BaseAttachPDF(ApexPages.StandardController stdController){
        this.id = stdController.getId();
        this.obj = [SELECT Name, Mater_Visit_for_Res_Cluster_of_Visits__c FROM Inspection__c WHERE Id = :id];
        this.childVisits = [Select Id, Mater_Visit_for_Res_Cluster_of_Visits__c, Name From Inspection__c Where Mater_Visit_for_Res_Cluster_of_Visits__c = :id];
        this.attachmentsToInsert = new List<Attachment>();
    }
    
    public pageReference savePDF(){
        // Create and insert the master attachment.
        createAndInsertAttachment(obj);
        // If there are child visits then generate and 
        if (childVisits != null && childVisits.size() > 0) {
            for (Inspection__c child : childVisits) {
                createAndInsertAttachment(child);
            }
        }
        insert attachmentsToInsert;
        // Update the object issue dates.
        updateObject(obj);
        // Update the object list issue dates. 
        updateChildObjects(childVisits);
        // Return the page reference.
        return new PageReference('/' + id);
    }
    
    private void createAndInsertAttachment(Inspection__c refObj) {
        PageReference pagePdf = pdfPageReference();
        Blob pdfPageBlob;
        Boolean isNarrativeChild = refObj.Mater_Visit_for_Res_Cluster_of_Visits__c != null && pdfName().contains('Narrative') ? true : false;
        
        pagePdf.getParameters().put('id', isNarrativeChild ? obj.Id : refObj.Id);
        pdfPageBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPDF();
             
        Attachment a = new Attachment();
        a.Body = pdfPageBlob;
        a.ParentID = refObj.Id;
        a.Name = pdfName() + refObj.Name + '.pdf';
        //insert a;
        attachmentsToInsert.add(a);
    }
    
    protected abstract PageReference pdfPageReference();
    protected abstract String pdfName();
    protected abstract void updateObject(Inspection__c obj);
    protected abstract void updateChildObjects(List<Inspection__c> childVisits);

}