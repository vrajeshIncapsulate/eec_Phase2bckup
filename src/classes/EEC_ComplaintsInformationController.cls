public without sharing class EEC_ComplaintsInformationController extends EEC_BaseComplaintsController { 
 
    public List<Involved_Persons__c> involvedPersons { get; set; }
    public Integer personToRemove { get; set; }
    
    public EEC_ComplaintsInformationController() {
        involvedPersons = [ 
            SELECT 
                Name, RecordType.Name, Child_birth_date__c, Parent_Guardian_Name__c, Parent_Guardian_Address__c, 
                Parent_Guardian_Telephone_Number__c, Role__c, Other_Role__c, Title__c, Description_of_involvement__c,Age__c 
            FROM 
                Involved_Persons__c
            WHERE 
                Involved_In__c = :complaint.Id
        ];
                
    } 
    private Id adultInvolvement = Schema.SObjectType.Involved_Persons__c.getRecordTypeInfosByName().get('Adult Involvement').getRecordTypeId();

    public void addInvolved() {   
        involvedPersons.add(new Involved_Persons__c(Involved_In__c = complaint.Id, Name = null)); 
    }

    public PageReference goToComplainerInfo() {
        upsert involvedPersons;
        upsertComplaint();
        return redirectWithId(Page.EEC_ComplaintReporterInfo);
    }

    public override PageReference backPage() {
        return Page.EEC_ComplaintsProviderInfo;
    }

    public void removeInvolved() {
        Involved_Persons__c ip = involvedPersons[personToRemove];
        
        if(ip.Id != NULL) {
            delete ip;
        }
        
        involvedPersons.remove(personToRemove);
    }

    public List<EEC_Question> getComplaintInformationQuestions() {
        return EEC_QuestionService.complaintInfoDescrQuestions;
    }

    public List<EEC_Question> getInvolvedQuestions() {
        return EEC_QuestionService.complaintInfoInvolvedQuestions(); 
    }

    public List<EEC_Question> getDCFFilingQuestions() {
        return EEC_QuestionService.complaintFilling; 
    }

    public List<EEC_Question> getSharedQuestions() {
        return EEC_QuestionService.complaintSharedProvider;  
    }

    public List<EEC_Question> getOtherInformationQuestions () {
        return EEC_QuestionService.complaintInformationOtherQuestions ;  
    }
}