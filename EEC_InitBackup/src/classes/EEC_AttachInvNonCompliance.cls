public with sharing class EEC_AttachInvNonCompliance extends EEC_BaseInvAttachPDF {

    public EEC_AttachInvNonCompliance(ApexPages.StandardController stdController){
        super(stdController);
    }

    public override String pdfName(){
        Boolean cB = false; 
        if(ApexPages.currentPage().getParameters().get('Corrective_Action_Plan_Report')!=null){
        cB = Boolean.valueof(ApexPages.currentPage().getParameters().get('Corrective_Action_Plan_Report'));
        }
        if(cB){
            return 'CorrectiveActionPlanReport-';
        }else{
            return 'NonCompliance-';    
        }
        
    }
    
    public override PageReference pdfPageReference(){
        return Page.EEC_GenerateInvestigationNCLetter;
    }
    
    public override void updateObject(Investigation__c i){
        i.Statement_of_non_compliance_Issue_Date__c = System.today();
        update i;
    }
}