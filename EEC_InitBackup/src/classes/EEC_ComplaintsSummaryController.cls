public class EEC_ComplaintsSummaryController extends EEC_BaseComplaintsController {
    
    public List<Involved_Persons__c> adultInvolvedPersons { get; set; }
    public List<Involved_Persons__c> childInvolvedPersons { get; set; }
    public boolean displayAgeCol {get; set;}    
    public boolean displayDOBCol {get; set;}
    
    public EEC_ComplaintsSummaryController () {
        displayAgeCol = false;
        displayDOBCol = false;
        adultInvolvedPersons = [
            SELECT 
                Name, RecordType.Name, Child_birth_date__c, Parent_Guardian_Name__c, Parent_Guardian_Address__c, 
                Parent_Guardian_Telephone_Number__c, Role__c, Other_Role__c, Title__c, Description_of_involvement__c 
            FROM 
                Involved_Persons__c
            WHERE 
                Involved_In__c = :complaint.Id AND 
                RecordType.Name = 'Adult Involvement'
        ];
        
        childInvolvedPersons = [
            SELECT 
                Name, RecordType.Name, Child_birth_date__c, Parent_Guardian_Name__c, Parent_Guardian_Address__c, 
                Parent_Guardian_Telephone_Number__c, Role__c, Other_Role__c, Title__c, Description_of_involvement__c,Age__c 
            FROM   
                Involved_Persons__c 
            WHERE 
                Involved_In__c = :complaint.Id AND
                RecordType.Name = 'Child Involvement'
        ];
        
        for(Involved_Persons__c ci : childInvolvedPersons){
            if(ci.Age__c != null)
                displayAgeCol = true;
            if(ci.Child_birth_date__c != null)
                displayDOBCol = true;
        }        
    } 
     
    public PageReference submit() {
        if(complaint.Status == 'Not Submitted') {
            complaint.Status = 'New';
            upsertComplaint();
        }
        
        return redirectWithId(Page.EEC_ComplaintsConfirmation);
    }
     
    public List<EEC_Question> getProviderInformationQuestions(){
        return EEC_QuestionService.complaintSummaryProvider;
    } 

    public List<EEC_Question> getReporterQuestions() {
        List<EEC_Question> questions = EEC_QuestionService.complaintReporterInfoQuestion;
        questions.addAll(EEC_QuestionService.complaintReporterAddressQuestion);
        questions.addAll(EEC_QuestionService.complaintReporterContactQuestion);
        
        return questions;
    } 
    
    public override PageReference backPage() {
        return Page.EEC_ComplaintReporterInfo;
    }
      
    public List<EEC_Question> getComplaintFilling() { 
        return EEC_QuestionService.complaintFilling;
    }   
    
    public List<EEC_Question> getComplaintShared() {
        return EEC_QuestionService.complaintSharedProvider;
    } 
    
    public List<EEC_Question> getComplaintOther() {
        return EEC_QuestionService.complaintInformationOtherQuestions;
    }
    
    public List<EEC_Question> getComplaintQuestions() { 
        return EEC_QuestionService.complaintInfoDescrQuestions;
    }   
    
    public List<EEC_Question> getInvolvedQuestions() {
        return EEC_QuestionService.complaintInfoInvolvedQuestions(); 
    }
}