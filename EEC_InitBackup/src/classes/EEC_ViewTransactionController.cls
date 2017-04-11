public without sharing class EEC_ViewTransactionController 
{
    public Id ltId {get;set;}
    public Account provider{get;set;}
    public Licensing_Transaction__c licenseTransation {get;set;}
    public String licenseRecordTypeName {get;set;}
    public String licenseRecordTypeLabel {get;set;}
    public List<Household_Member__c> ihmList {get;set;}
    public List<FCC_Assistant__c> faList {get;set;}
    public List<Employment_History__c> ehList {get;set;}
    public List<Room__c> roomList {get;set;}
    public List<Training_Experience__c> teList {get;set;}
    public Integer rowNum{get;set;}
    public List<String> selectedHestElems {get;set;}
    public String selectedHestStr {get;set;}
    public Map<String,PageReference> lastStepMap;
    public String memberId{ get; set; } 
    
    public List<S3_File__c> attachments {get;set;}
    
    public EEC_ViewTransactionController(){
        ltId = ApexPages.currentPage().getParameters().get('ltID');
        memberId = ApexPages.currentPage().getParameters().get('member'); 
        getLicenseTrans();
    }
    
    public void getLicenseTrans() {
        List<Licensing_Transaction__c> ltList = [Select l.Working_With_Assistant__c, l.Work_Phone_Number__c, l.Which_Food_Program__c, l.Well_Water_Test_Evidence__c,l.Use_of_Alcoholic_Bev_Narcotics_Drugs__c, l.Use_Family_Child_Care_System__c,l.Took_FCC_Orientation__c,  RecordType.DeveloperName,RecordType.Name,
                                                        l.Use_Family_Child_Care_System_Descrip__c, l.Upgrading_Capacity_Training_Cert__c, l.Under_Review_Start_Date__c,l.USDA_Nutrition_Training_Evidence__c, l.Transportation_Training_Cert__c, l.Training_Review__c, l.New_Phone_Number_Unlisted__c,
                                                        l.Total_Payment_Received__c, l.Took_Upgrading_Capacity_Training__c, l.Took_USDA_Nutrition_Training__c, l.New_City__c,l.Took_Transportation_Training__c, l.Took_SIDS_Training__c, l.Took_Medication_Administration_Training__c, l.New_State__c, 
                                                        l.To_Process_Flag__c, l.Technical_Assistance__c, l.Tax_Certification_Status__c, l.Submission_Date__c, l.Name, l.Approved_Foster_Care_Provider_Descrip__c,l.Tax_Certification_Statement_Request_Date__c, l.Tax_Cert_Statement_Signed_Date__c, l.Submitter__c, l.Submitter_Email_Address__c, 
                                                        l.Stove_Meets_Requirements_Evidence__c, l.Status__c, l.Source__c, l.Sex_Offender_Nature_of_Incident__c, l.SIDS_Training_Cert__c,l.Revocation_Suspension_Surrender_Reas__c, l.Restraining_Order_Issued__c, l.Restraining_Order_Description__c, l.Registering_as_Sex_Offender__c, 
                                                        l.RecordTypeId, l.Reason_for_Request__c, l.Reason_Closed_Cancelled__c, l.Ready_for_Closing__c, l.Provider__c, l.Previous_Involvement_with_EEC_for_Unlice__c,l.Previous_Application_Certif_with_EEC__c, l.Prev_App_Certif_with_EEC_Descrip__c, l.Prev_App_Certif_with_Another_State__c, 
                                                        l.Prev_App_Certif_with_Another_State_Desc__c, l.Outdoor_Space_Changes_Description__c, l.Outdoor_Space_Changed__c,l.Other_Person_BRC_Consent_Completed__c, l.Other_Info_Reviewed__c, l.Other_Condition__c, l.Observations_Comments__c, l.No_Condition_Flag__c, 
                                                        l.New_Zip_Code__c, l.New_Street_Address_2__c, l.New_Street_Address_1__c, l.New_Address_Phone_Number__c, l.Need_Assist_to_Barricade_Heating_Units__c,l.Moving_Date__c, l.Missing_Elements_For_Closing__c, l.Medication_Administration_Training_Cert__c, 
                                                        l.Live_at_New_Address__c, l.Licensee_BRC_Consent_Status__c, l.Licensee_BRC_Consent_Signed_Date__c, l.Licensee_BRC_Consent_Request_Date__c,Submitter__r.FirstName,Submitter__r.LastName,Assigned_To__r.FirstName,Assigned_To__r.LastName,Assigned_To__r.Phone,Assigned_To__r.Email,Assigned_To__r.For_Portal_Email__c,
                                                        l.License_Type__c, l.License_Requested__c, l.License_Issue_Date__c, l.License_Expiration_Date__c, l.Last_Reached_Step__c, l.Indoor_Outdoor_Space_Review__c, l.Id, l.Heating_Elements__c, l.Floors_Description__c, l.First_Aid_Certified__c, l.First_Aid_Certification_Issue_Date__c, 
                                                        l.First_Aid_Certificate__c, l.Fee_Paid__c, l.FCC_Residence_Description__c, l.FCC_Orientation_Module_II_Evidence__c, l.Experience_Caring_for_Children_QUalifica__c, 
                                                        l.Exits_Descriptions__c, l.Evening_Overnight_Weekend_Care__c, l.Drinking_Water_Source__c, l.Document_Information_Missing__c,l.Document_Info_Missing_Initial_Date__c, l.Dealings_with_Child_Prot_Child_Welfar__c, l.Dealing_with_Child_Prot_Welfar_Descri__c, 
                                                        l.Date_Upgrading_Capacity_Training_Taken__c, l.Date_USDA_Nutrition_Training_Taken__c, l.Date_Transportation_Training_Taken__c, l.Date_Med_Administration_Training_Taken__c, 
                                                        l.Date_Last_SIDS_Training_Taken__c, l.Date_FCC_Orientation_Taken__c, l.Date_Closed__c, l.Date_Care_Resumes__c, l.Date_Activity_Ends__c,l.Daily_Routine_and_Activities__c, l.Condition_Added__c, l.Children_Home_Schooled__c, l.Children_Home_Schooled_Description__c, l.Child_Emergency_Injury_Last_3_Years__c,
                                                        l.Child_Emerg_Injury_Last_3_Years_Descrip__c, l.Charges_Description__c, l.Charged_or_Arrested_for_Crime__c, l.Certificate_or_License_Surrendered__c,l.Certificate_of_License_Revoked_Suspend__c, l.Caring_For_Children_Not_Related__c, l.Capacity__c, l.CPR_Certified__c, l.CPR_Certification_Issue_Date__c, 
                                                        l.CPR_Certificate__c, l.Business_Operated_Out_of_Own_Home__c, l.Bus_Operated_Out_of_Own_Home_Descrip__c, l.Belong_to_Food_Program__c, l.Prior_First_Name__c,l.Prior_Last_Name__c,l.New_Last_Name__c,
                                                 		l.New_First_Name__c,l.Becoming_Foster_Care_Provider__c,l.Becoming_Foster_Care_Provider_Descrip__c, l.At_Least_2_Exits__c, l.Associated_Fee__c, l.Assigned_To__c, 
                                                 		l.Approved_by_Manager__c, l.Approved_Foster_Care_Provider__c, l.Abused_or_neglected_a_child__c, l.Abused_or_neglected_a_child_Description__c  
                                                        From Licensing_Transaction__c l where Id = :ltId];
        
        defineLastStepMap();
        if(ltList != null && ltList.size() > 0){
            licenseTransation = ltList.get(0);
            licenseRecordTypeName = licenseTransation.RecordType.DeveloperName;
            licenseRecordTypeLabel = licenseTransation.RecordType.Name;
            provider = [select Id,Recordtype.DeveloperName, RecordType.Name,License_Status__c,First_Issue_Date__c,Renewal_date__c,Provider_Status__c,capacity__c,
                           Accept_Referral__c,Can_Communicate_in_English__c,PPM_Meeting_Attended_Date__c,
                           ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode, Phone, Unlisted_Phone_Number__c, Alternate_Phone__c, Fax, Provider_Email__c,
                           Provider_Address_1__c,Provider_Address_2__c,Provider_City__c,Provider_Zip_Code__c,Live_at_this_address__c,Language__c,Preferred_Language__c
                        from Account where Id = :licenseTransation.Provider__c];
            
            ihmList = [Select Id, Provider__c, Licensing_Transactions__c, Current__c, First_Name__c, Last_Name__c, Date_of_Birth__c, Relationship_to_Provider__c, Occupation__c, Number_of_Hours_Home_During_Child_Care__c, Current_School_Grade__c, Email_Address__c From Household_Member__c where Licensing_Transactions__c = :licenseTransation.Id];
            faList = [Select Id, Name, First_Name__c, Last_Name__c, Mailing_Address__c, License_Number__c, License_Expiration_Date__c, Source_Transaction__c, Provider__c, Current__c From FCC_Assistant__c where Source_Transaction__c = :licenseTransation.Id];
            ehList = [Select Name, Contact__c, Licensing_Transaction__c, Position__c, Start_Date__c, End_Date__c, Reason_for_Leaving__c, Employer__c, Employer_Address__c, Employer_Phone__c From Employment_History__c where Licensing_Transaction__c = :licenseTransation.Id];
            roomList = [Select Id, Name, Source_Transaction__c, Current__c, Use__c, Dimension_Length_feet__c, Dimension_Width_feet__c, Dimension_Square_Feet__c, Floor_Level__c, Provider_Name__c From Room__c where Source_Transaction__c = :licenseTransation.Id];
            teList = [Select Id, Name, Contact__c, Licensing_Transactions__c, Topic__c, Date_of_the_Training__c, Number_of_Training_Hours__c From Training_Experience__c where Licensing_Transactions__c = :licenseTransation.Id];
            if(String.isNotEmpty(licenseTransation.Heating_Elements__c)){
                selectedHestElems = licenseTransation.Heating_Elements__c.split(';');
            }
            refreshAttachmentsList();
            //return licenseTransation;
        }
        else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Provide a valid Licensing Transaction Id');
            ApexPages.addMessage(msg);
            return;
        }
        
    }
    
    public Pagereference CancelTransaction(){
        licenseTransation.Status__c = 'Cancelled';
        licenseTransation.Reason_Closed_Cancelled__c = 'Cancelled by portal user';
        update licenseTransation;
        
        PageReference pPage = page.EEC_PortalProviderPage;
        if(memberId != null)  
           pPage.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
        return pPage;
    }
    
    public Pagereference backInstruction(){
        PageReference pPage = page.EEC_PortalProviderPage;
        if(memberId != null)  
           pPage.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
        return pPage;
    }
    
    public Pagereference editInstruction(){
        PageReference pPage = lastStepMap.get(licenseTransation.Last_Reached_Step__c);
        pPage.getParameters().put('ltId', licenseTransation.Id);
        pPage.getParameters().put('accountId', provider.Id);
        return pPage;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No')); 
        return options;
    }
    
    public List<SelectOption> getHeatingElements(){
        
        List<SelectOption> hElements = new List<SelectOption>();
        //selectedHestElems = new List<String>();
        Schema.DescribeFieldResult fieldResult = Licensing_Transaction__c.Heating_Elements__c.getDescribe();
        list<schema.picklistentry> values = fieldResult.getPickListValues();               
        for (Schema.PicklistEntry a : values) 
        {                  
            hElements.add(new SelectOption(a.getValue(), a.getLabel()));
        }           
        return hElements;
    }
    
    private void defineLastStepMap(){
        lastStepMap = new Map<String,PageReference>();
        lastStepMap.put('Transaction / Provider Information',Page.EEC_TransactionProvider);
        lastStepMap.put('Household Members',Page.EEC_HouseHoldMembers);
        lastStepMap.put('License Status and Capacity / Assistant Information',Page.EEC_LicenseStatusCapacityInfo);
        lastStepMap.put('EEC Involvement Experience & Professional Exp.',Page.EEC_InvolvementExperience);
        lastStepMap.put('Background Information',Page.EEC_BackgroundInformation);
        lastStepMap.put('Training Information',Page.EEC_TrainingInformation);
        lastStepMap.put('Indoor / Outdoor space information',Page.EEC_IndoorSpacePage);
        lastStepMap.put('Daily Routing Activities / Technical Assistance',Page.EEC_TechnicalAssistance);
        lastStepMap.put('Attachments',Page.EEC_ReviewSummarySubmission);
        lastStepMap.put('Review Summary and Submission',Page.EEC_ReviewSummarySubmission);
        //lastStepMap.put('Instructions',Page.);
    }
    
    /**
     * refreshAttachmentsList
     * 
     * This function will collect all the attachments for the transaction and store them into a list for use on the attachment page.
     * @author Darkis 
     */
    public List<S3_File__c> refreshAttachmentsList() {
      attachments = new List<S3_File__c>();
      List<FileMap__c> fileMappings = [Select Id, S3_File__r.Id, S3_File__r.CreatedDate, S3_File__r.Filename__c From FileMap__c Where Object_Id__c = :licenseTransation.Id];
      System.debug('----> Transaction ID: ' + licenseTransation.Id);  
      System.debug('----> File Mappings: ' + fileMappings);
      if (fileMappings.size() > 0) {
        Set<Id> fileIds = new Set<Id>();
          
        for (FileMap__c filemap : fileMappings) {
          fileIds.add(filemap.S3_File__r.Id);
        }
        attachments = [Select Id, Filename__c, Content_Type__c, CreatedDate From S3_File__c Where Id IN :fileIds];
        System.debug('----> All Files: ' + attachments);
        return attachments;
      }    
      return new List<S3_File__c>();
    }
}