public without sharing class EEC_ComplaintReporterInfoController extends EEC_BaseComplaintsController {

    public List<EEC_Question> getReporterInfoQuestions() {
        return EEC_QuestionService.complaintReporterInfoQuestion;
    }
    
    public override PageReference backPage() {
        return Page.EEC_ComplaintInformation;
    }
     
    public Boolean noPhoneNumberGiven() {
        return String.isBlank(complaint.Contact.HomePhone) && String.isBlank(complaint.Contact.MobilePhone) && String.isBlank(complaint.Contact.Phone);
    }

    public Boolean preferredSet() {
       if(complaint.Best_Phone_Number_to_use == 'Home' && String.isBlank(complaint.Contact.HomePhone) ||
          complaint.Best_Phone_Number_to_use == 'Work' && String.isBlank(complaint.Contact.Phone) ||
          complaint.Best_Phone_Number_to_use == 'Mobile' && String.isBlank(complaint.Contact.MobilePhone)) {
           return false;
       } 
       
       return true;
    }

    public PageReference goToSummary() {
        if(complaint.Preferred_Contact_Method == 'Phone' && !preferredSet()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'If Phone is your preferred method of contact, please include a number for your best phone number')); 
            return null;
        }
        
        complaint.Contact.Id = findDuplicateContact();
        Contact c = complaint.Contact.toContact(); 
        insert c;
        complaint.ContactId = c.Id;
        upsertComplaint();
        
        return redirectWithId(Page.eec_complaintssummary);
    }
    
    public Id findDuplicateContact() {
        if(complaint.Contact.Id != NULL) {
            return complaint.Contact.Id;
        }
        
        List<Contact> contacts = new List<Contact>();
        
        if(!String.isBlank(complaint.Contact.Email)) {
            contacts = [SELECT ID FROM Contact WHERE Email = :complaint.Contact.Email ORDER BY CreatedDate DESC LIMIT 1]; 
        }
        
        if(!String.isBlank(complaint.Contact.FirstName) && !String.isBlank(complaint.Contact.LastName) && !noPhoneNumberGiven()) {
            contacts.addAll([
                SELECT ID 
                FROM Contact 
                WHERE 
                    FirstName = :complaint.Contact.FirstName AND
                    LastName = :complaint.Contact.LastName AND
                    (HomePhone = :complaint.Contact.HomePhone OR MobilePhone = :complaint.Contact.MobilePhone OR Phone = :complaint.Contact.Phone)
                ORDER BY CreatedDate DESC
                LIMIT 1
            ]); 
        }
        
        return contacts.size() > 0 ? contacts[0].Id : null;
    }

    public List<EEC_Question> getReporterQuestions() {
        return EEC_QuestionService.complaintReporterInfoQuestion;
    }

    public List<EEC_Question> getAddressQuestions() {
        return EEC_QuestionService.complaintReporterAddressQuestion;
    }

    public List<EEC_Question> getContactQuestions() {
        return EEC_QuestionService.complaintReporterContactQuestion;
    } 
}