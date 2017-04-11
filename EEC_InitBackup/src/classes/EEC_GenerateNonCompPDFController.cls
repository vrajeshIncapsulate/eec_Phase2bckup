public with sharing class EEC_GenerateNonCompPDFController {
    
    private final Inspection__c inspectionRecord;
    private List<Inspection__c> childVisits {get;set;}
    private List<Attachment> attachmentsToInsert {get;set;}
    
    public EEC_GenerateNonCompPDFController(ApexPages.StandardController controller) {
        this.inspectionRecord = (Inspection__c) controller.getRecord();
        this.attachmentsToInsert = new List<Attachment>();
        this.childVisits = [Select Id, Name From Inspection__c Where Mater_Visit_for_Res_Cluster_of_Visits__c = :inspectionRecord.Id];
    }
    
    public pagereference GeneratePDF(){
        createAndInsertAttachment(inspectionRecord);
        // Update the date on the exisiting object.  
        Inspection__c insp = new Inspection__c(id=inspectionRecord.Id,Statement_of_non_compliance__c=Date.today());
        update insp;
        // Loop through all child visits if they exist.
        if (childVisits != null && childVisits.size() > 0) {
            for (Inspection__c child : childVisits) {
                createAndInsertAttachment(child);
                // Update the issue date on the child dates. 
                child.Statement_of_non_compliance__c = Date.today();
            }
            update childVisits;
        }
        insert attachmentsToInsert;
        // Return the page reference.  
        return new PageReference('/' + inspectionRecord.Id);
    }
    
    private void createAndInsertAttachment(Inspection__c refObj) {
        PageReference pagePdf = new PageReference('/apex/EEC_GeneratePDFNC');
        pagePdf.getParameters().put('id', refObj.Id);
        Blob pdfPageBlob;
        pdfPageBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPDF();
             
        Attachment a = new Attachment();
        a.Body = pdfPageBlob;
        a.ParentID = refObj.Id;
        Boolean cB = false; 
        if(ApexPages.currentPage().getParameters().get('Corrective_Action_Plan_Report')!=null){
        cB = Boolean.valueof(ApexPages.currentPage().getParameters().get('Corrective_Action_Plan_Report'));
        }
        if(cB){
            a.Name = 'CorrectiveActionPlanReport-'+refObj.name+'.pdf';
        }else{
            a.Name = 'StatementNonCompliance-'+refObj.name+'.pdf';
        }
        a.Description = 'Statement of Non Compliance';
        //insert a;
        attachmentsToInsert.add(a);
    }
}