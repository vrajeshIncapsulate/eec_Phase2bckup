public class EEC_Complaint {
    public Id id { get; set; }
    public String Subject { get; set; }
    public String Description {get; set; }
    public String Date_Event_Occured {get; set; }
    public String Time_Event_Occured {get; set; }
    public String Event_Location {get; set; }
    public String Reason_Issue_Known {get; set; }
    public String Reason_to_Report_Now {get; set; }
    public String Shared_with_Provider {get; set; }
    public String If_yes_what_happened {get; set; }
    public String If_not_why_not {get; set; }
    public String Filed_with_DCF {get; set; }
    public String DCF_Filer {get; set; }
    public String DCF_File_Submission_Date {get; set; } 
    public String Unlicensed_Provider_Name { get; set; } 
    public String Unlicensed_Provider_Street { get; set; }
    public String Unlicensed_Provider_City { get; set; }
    public String Unlicensed_Provider_City_Text { get; set; }
    public String Unlicensed_Provider_Zip_Code { get; set; }
    public String Unlicensed_Provider_Phone { get; set; }
    public String Unlicensed_Provider_Email { get; set; }
    public String Status { get; set; }
    public String Origin { get; Set; }
    public String Nature_of_complaint { get; set; }
    public Id contactId { get; set; }
    public EEC_ComplaintContact contact { get; set; }
    public String Relationship_to_provider {get; set;}
    public String Other_Relationship { get; set; }
    public String Preferred_Contact_Method { get; set; }
    public String Best_Phone_Number_to_use { get; set; }
    public String Best_time_to_contact { get; set; }
    public String Who_Shared_with_Provider {get; set; }
    public String When_Shared_with_Provider {get; set; }
    
	public Account Account { get {
		return [SELECT Name, Account.Owner.ManagerId, Provider_Address_1__c,Region__r.SGLSA_New_Case_Default_Assignee__c,
                Region__r.FCC_New_Case_Default_Assignee__c, Provider_City__r.Name,Account.Owner.IsActive,  
                OwnerId,RecordType.Name,Record_Type_Name__c  FROM Account WHERE Id = :AccountId];
	}}
    
    public Id RecordTypeId { get; set; }
    public Id AccountId { get; set; } 

    public Case toCase() {
        Case c = new Case();
        c.Id = this.Id;
        c.subject = this.Subject;
        c.Description = this.Description;
        c.Date_Event_Occured__c = this.Date_Event_Occured == NULL ? NULL : Date.parse(this.Date_Event_Occured);
        c.Time_Event_Occured__c = this.Time_Event_Occured;
        c.Event_Location__c = this.Event_Location;
        c.Reason_Issue_Known__c = this.Reason_Issue_Known;
        c.Reason_to_Report_Now__c = this.Reason_to_Report_Now;
        c.Shared_with_Provider__c = this.Shared_with_Provider;
        c.If_yes_what_happened__c = this.If_yes_what_happened;
        c.If_not_why_not__c = this.If_not_why_not;
        c.Filed_with_DCF__c = this.Filed_with_DCF;
        c.DCF_Filer__c = this.DCF_Filer;
        c.DCF_File_Submission_Date__c = this.DCF_File_Submission_Date == NULL ? NULL : Date.parse(this.DCF_File_Submission_Date); 
        c.Unlicensed_Provider_Name__c =  this.Unlicensed_Provider_Name; 
        c.Unlicensed_Provider_Street__c = this.Unlicensed_Provider_Street;
        c.Unlicensed_Provider_City__c = this.Unlicensed_Provider_City;
        c.Unlicensed_Provider_Zip_Code__c = this.Unlicensed_Provider_Zip_Code;
        c.Unlicensed_Provider_Phone__c = this.Unlicensed_Provider_Phone;
        c.Unlicensed_Provider_Email__c = this.Unlicensed_Provider_Email;
        c.AccountId = this.AccountId;
        c.Status = this.Status;
        c.Origin = this.Origin; 
        c.RecordTypeId = this.RecordTypeId; 
        c.Nature_of_complaint__c = this.Nature_of_complaint;
        c.ContactId = this.ContactId;
        c.Relationship_to_provider__c = this.Relationship_to_provider;
        c.Other_Relationship__c = this.Other_Relationship;
        c.Preferred_Contact_Method__c = this.Preferred_Contact_Method;
        c.Best_Phone_Number_to_use__c = this.Best_Phone_Number_to_use;
        c.Best_time_to_contact__c = this.Best_time_to_contact;
        c.Who_Shared_with_Provider__c = this.Who_Shared_with_Provider;
    	c.When_Shared_with_Provider__c = this.When_Shared_with_Provider == NULL ? NULL : Date.parse(this.When_Shared_with_Provider);

        if(AccountId != null){
            if(Account.OwnerId != null && Account.Owner.IsActive){
                c.OwnerId = Account.OwnerId;
            }
            else {
                if(Account.RecordType.Name == 'Small Group' || Account.RecordType.Name == 'Large Group')
                    c.OwnerId = Account.Region__r.SGLSA_New_Case_Default_Assignee__c;
                else if(Account.RecordType.Name == 'Family Child Care' || Account.RecordType.Name == 'FCC Assistant')
                    c.OwnerId = Account.Region__r.FCC_New_Case_Default_Assignee__c;
                else 
                    c.OwnerId = Account.Owner.ManagerId;
            }
        }
        else{
            City_Assignment__c[] ca = [SELECT Id,Name,City__c,Region__c,Region__r.Name,Region__r.FCC_New_Case_Default_Assignee__c 
                           			FROM City_Assignment__c  WHERE Applicable_To__c includes ('Family Child Care') AND
                           			City__c =: this.Unlicensed_Provider_City LIMIT 1];
            System.debug('Unlicensed_Provider_City_Name' + this.Unlicensed_Provider_City);
            if(ca.size() > 0){
                System.debug('City_Assignment' + ca[0].Region__r.Name);
            	System.debug('City_Assignment' + ca[0].Region__c);
            	c.OwnerId = ca[0].Region__r.FCC_New_Case_Default_Assignee__c;
            	c.Unlicensed_Provider_Region__c = ca[0].Region__c;
            }
        } 
        return c;
    } 
    
    private static EEC_Complaint initComplaint() {
        Id complaintId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();

        EEC_Complaint complaint = new EEC_Complaint();
        complaint.Status = 'Not Submitted';
        complaint.Origin = 'Web';
        complaint.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
        
        return complaint;
    }
    
    public Date getDateEventOccuredAsDate() { 
        try {
            return String.isBlank(this.Date_Event_Occured) ? NULL : Date.parse(this.Date_Event_Occured);
        } catch (Exception e) {
            return NULL;
        }
    }
    public Date getDateWhenSharedWithProvider() { 
        try {
            return String.isBlank(this.When_Shared_with_Provider) ? NULL : Date.parse(this.When_Shared_with_Provider);
        } catch (Exception e) {
            return NULL;
        } 
    }
    
    public static EEC_Complaint fromCase(Id caseId) {
        if(caseId == NULL) {
            return initComplaint();
        }
    
        Case c = [
            SELECT 
                Id, Subject, Description, Date_Event_Occured__c, Time_Event_Occured__c, AccountId, ContactId,
                Event_Location__c, Reason_Issue_Known__c, Reason_to_Report_Now__c, Shared_with_Provider__c,
                If_yes_what_happened__c, If_not_why_not__c, Filed_with_DCF__c, DCF_Filer__c, DCF_File_Submission_Date__c,
                Unlicensed_Provider_Name__c, Unlicensed_Provider_City__r.Name, Unlicensed_Provider_Street__c, Unlicensed_Provider_City__c, Unlicensed_Provider_Zip_Code__c,
                Unlicensed_Provider_Phone__c, Unlicensed_Provider_Email__c,Unlicensed_Provider_Region__c, Status, Origin, RecordTypeId, Nature_of_complaint__c,
                Relationship_to_provider__c, Other_Relationship__c, Best_Phone_Number_to_use__c, Preferred_Contact_Method__c, 
            	Best_time_to_contact__c,Who_Shared_with_Provider__c,When_Shared_with_Provider__c
            FROM Case 
            WHERE ID = :caseId
        ];
        
        EEC_Complaint complaint = new EEC_Complaint();
        complaint.Id = c.Id;
        complaint.subject = c.Subject;
        complaint.Description = c.Description;
        complaint.Date_Event_Occured = c.Date_Event_Occured__c == NULL ? NULL : c.Date_Event_Occured__c.format();
        complaint.Time_Event_Occured = c.Time_Event_Occured__c;
        complaint.Event_Location = c.Event_Location__c;
        complaint.Reason_Issue_Known = c.Reason_Issue_Known__c;
        complaint.Reason_to_Report_Now = c.Reason_to_Report_Now__c;
        complaint.Shared_with_Provider = c.Shared_with_Provider__c;
        complaint.If_yes_what_happened = c.If_yes_what_happened__c;
        complaint.If_not_why_not = c.If_not_why_not__c;
        complaint.Filed_with_DCF = c.Filed_with_DCF__c;
        complaint.DCF_Filer = c.DCF_Filer__c; 
        complaint.DCF_File_Submission_Date = c.DCF_File_Submission_Date__c == NULL ? NULL : c.DCF_File_Submission_Date__c.format();
        complaint.Unlicensed_Provider_Name =  c.Unlicensed_Provider_Name__c; 
        complaint.Unlicensed_Provider_Street = c.Unlicensed_Provider_Street__c;
        complaint.Unlicensed_Provider_City = c.Unlicensed_Provider_City__c;
        complaint.Unlicensed_Provider_City_Text = c.Unlicensed_Provider_City__r.Name;
        complaint.Unlicensed_Provider_Zip_Code = c.Unlicensed_Provider_Zip_Code__c;
        complaint.Unlicensed_Provider_Phone = c.Unlicensed_Provider_Phone__c;
        complaint.Unlicensed_Provider_Email = c.Unlicensed_Provider_Email__c;
        complaint.AccountId = c.AccountId;
        complaint.Status = c.Status;
        complaint.Origin = c.Origin; 
        complaint.RecordTypeId = c.RecordTypeId; 
        complaint.Nature_of_complaint = c.Nature_of_complaint__c;
        complaint.Relationship_to_provider = c.Relationship_to_provider__c;
        complaint.Other_Relationship = c.Other_Relationship__c;
        complaint.Preferred_Contact_Method = c.Preferred_Contact_Method__c;
        complaint.Best_Phone_Number_to_use = c.Best_Phone_Number_to_use__c;
        complaint.Best_time_to_contact = c.Best_time_to_contact__c;
        complaint.When_Shared_with_Provider = c.When_Shared_with_Provider__c == NULL ? NULL : c.When_Shared_with_Provider__c.format();
        complaint.Who_Shared_with_Provider = c.Who_Shared_with_Provider__c;
        complaint.ContactId = c.ContactId;
        complaint.Contact = EEC_ComplaintContact.fromContact(complaint.ContactId);
        return complaint;
        
    }
}