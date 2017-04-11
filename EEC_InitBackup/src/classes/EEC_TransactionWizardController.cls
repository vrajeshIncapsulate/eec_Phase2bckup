public with sharing class EEC_TransactionWizardController {
    
    public Account provider{get;set;}
    public LEAD_Configuration__c leadConfiguration{get;set;}
    public String licenseInstructionMessage {get;set;}
    public Licensing_Transaction__c licenseTransation {get;set;} 
    public String licenseRecordTypeName {get;set;} 
    public String licenseRecordTypeLabel {get;set;}
    public String formattedLicenseRecordTypeLabel {get;set;}
    public List<Household_Member__c> ihmList {get;set;}
    public List<FCC_Assistant__c> faList {get;set;}
    public List<Employment_History__c> ehList {get;set;}
    public List<Room__c> roomList {get;set;}
    public List<Training_Experience__c> teList {get;set;}
    public Integer rowNum{get;set;}
    public Contact cntct{get;set;} 
    public String selectPreviousInv {get;set;}
    public List<String> selectedHestElems {get;set;}
    public String selectedHestStr {get;set;}
    public String selectedWaterStr {get;set;}
    String providerRecordType;
    Map<String,String> recordTypeMap = new Map<String,String>();
    List<Household_Member__c> removeHMList {get;set;}
    List<FCC_Assistant__c> removeFAList {get;set;}
    List<Employment_History__c> removeEHList {get;set;}
    List<Room__c> removeRoomList {get;set;}
    List<Training_Experience__c> removeTeList {get;set;}
    List<FileMap__c> transactionAttachments {get;set;}
    public Map<String, Map<String, String>> transactionAttachmentsMap {get;set;}
    public Map<Id, String> transactionAttachmentsUrlMap {get;set;}
    public String fileToDelete {get;set;}
    User loggedUser;
    Boolean initHH = false;
    Boolean initLS = false;
    Boolean initIndoor = false;
    Boolean initTraining = false;
    //      Position__c,End_Date__c,Start_Date__c,Reason_for_Leaving__c,Employer__c
          
    // AWS Variables
    private AWSKeys credentials {get;set;}
    private String AWSCredentialName = 'eec';
    public String accessKey {get;set;}
    public String bucketItemAccess {get;set;}
    public String bucketName {get;set;}
    public String portalUrl {get;set;}  
          
    // Household Member Table Variables
    public String MembersJson {get;set;}
    public String MembersToDeleteJson {get;set;}
    public String ihmListJson {get;set;}
    // Attachment variables.
    public List<S3_File__c> attachments {get;set;}
    public List<S3_File__c> additionalTrainingAttachments {get;set;}
    public String indoorAttachmentsJson {get;set;}
    public String attachmentsJson {get;set;}
    public String trainingAttachmentsJson {get;set;}
    public String transCertCheckboxFieldname {get;set;}
    public String memberId{ get; set; } 
    
    // Attachment edit variables.
    public String fileToEditId {get;set;}
    public String fileToEditDescription {get;set;}
    
    public EEC_TransactionWizardController(){
        String ltId = ApexPages.currentPage().getParameters().get('ltId');
        memberId = ApexPages.currentPage().getParameters().get('member'); 
        //ltId = EEC_Util.decryptGetParam(EncodingUtil.urlDecode(ltId,'UTF-8'));
        String accountId = '';
        
        if(String.isNotBlank(memberId)){
            accountId = memberId;
        }
        else{
            List<Account> tempAccount = [Select Id From Account Where ID in (Select Accountid From User Where id = :Userinfo.getUserId()) Limit 1];
            if (tempAccount != null && tempAccount.size() == 1) {
              accountId = tempAccount.get(0).Id;    
            }
        }
        if(accountId == '')
            accountId = ApexPages.currentPage().getParameters().get('accountId');
        System.debug('ACCOUNTID----->' + accountId);
        provider = [SELECT Id,Recordtype.DeveloperName, RecordType.Name,License_Status__c,First_Issue_Date__c,Renewal_date__c,Provider_Status__c,
                           Accept_Referral__c,Can_Communicate_in_English__c,PPM_Meeting_Attended_Date__c,capacity__c,
                           ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode, Phone, Unlisted_Phone_Number__c, Alternate_Phone__c, Fax, Provider_Email__c,
                           Provider_Address_1__c,Provider_Address_2__c,Provider_City__c, Provider_City__r.Name, Provider_Zip_Code__c,Live_at_this_address__c,Language__c,Preferred_Language__c,
                           (SELECT Id,Status__c,RecordType.DeveloperName FROM Licensing_Transactions__r order BY CreatedDate DESC) FROM Account WHERE Id = :accountId];
        providerRecordType = provider.RecordType.Name;
        List<Contact> conList = [select FirstName, LastName, BirthDate,MobilePhone,Prof_Qualification_Reg_Number__c from Contact 
                                 where AccountId = :provider.Id and Role__c like 'Main Contact%' ORDER BY CreatedDate DESC LIMIT 1];
        if(conList != null && conList.size() > 0){
            cntct = conList.get(0);
        }
        leadConfiguration = [Select Visit_Narrative_Summary_Default__c, SystemModstamp, Re_issuance_of_License_Cert_Instruction__c, Portal_Transaction_Introduction__c, 
                                    Number_of_days_for_Investigation_Visit__c, No_of_Days_Prior_Corr_Action_Deadline__c, No_of_Days_For_Investigation_Due_Date__c, Name, 
                                    Large_Group_Instruction__c, Investigation__c, Investig_Non_comp_Default_if_Any__c, Follow_up_Visit_Estimated_Deadline__c, FCC_Renewal_Instruction__c, 
                                    FCC_Re_Active_Instruction__c, FCC_New_License_Instruction__c, FCC_License_Upgrade_Instruction__c, FCC_Inactivate_Instruction__c, 
                                    FCC_Change_of_Household_Instruction__c, FCC_Change_Room_Floor_Level_Instruction__c, Close_Prior_Expiration_Instruction__c,
                                    Change_of_Address_Instruction__c, Transaction_Attachments_New__c, Transaction_Attachments_Renewal__c, Transaction_Attachments_Upgrade__c from LEAD_Configuration__c where Name = :providerRecordType];
        loggedUser = [select Id, Name,contactId from User where Id = :UserInfo.getUserId()];
        
        if(String.isNotBlank(ltId)){
            getLicenseTrans(ltId);
        }
        else{
            licenseTransation = new Licensing_Transaction__c();
            initializeController();
        }
        credentials = new AWSKeys(AWSCredentialName);
        accessKey = credentials.key;
        bucketName = 'eec-lead';
        bucketItemAccess = 'authenticated-read';
        // Get the page url for form submit.
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm(); // it will return: < https://cs14.salesforce.com >
        String PageURL = ApexPages.currentPage().getUrl();   // it will return: < /apex/myVFpage?id=906F00000008w9wIAA >
        portalUrl = baseURL + PageURL;
        generateAttachmentMappings();
        refreshAttachmentsList();
        retrieveAddtionalTrainingAttachmentsList();
        
        /*EEC_Session__c transactionSession = EEC_Session__c.getValues('License_Transaction_Session');
        if (transactionSession != null) {
          if (!String.isBlank(transactionSession.Transaction_Active_Button_Label__c)) {
            LicenseRecordTypeName = recordTypeMap.get(licenseRecordTypeLabel);
            formattedLicenseRecordTypeLabel = LicenseRecordTypeName.replaceAll('_',' ');
            licenseInstructionMessage = (String)leadConfiguration.get(LicenseRecordTypeName+'_Instruction__c');
          }    
        } else {
            EEC_Session__c transactionSession = new EEC_Session__c
        }*/
    }
    
    public void generateAttachmentMappings() {
      try {
          // Get all attachments for the transaction.
          transactionAttachments = [Select Id, CreatedDate, S3_File__r.Id, S3_File__r.Filename__c, S3_File__r.Bucket__c, S3_File__r.Content_Type__c, S3_File__r.Prefix__c From FileMap__c Where Object_Id__c = :licenseTransation.Id ORDER BY CreatedDate DESC];
          // Initialize the Mapping.
          transactionAttachmentsMap = new Map<String, Map<String, String>>();
          transactionAttachmentsUrlMap = new Map<Id, String>();
          Set<Id> transactionFileIds = new Set<Id>();
          // Loop through the file maps and creating a mapping based on filename.
          for (FileMap__c fileMap : transactionAttachments) {
            System.debug('----> FileMap: ' + fileMap);
            // Get the full filename including prefix if necessary for urls.
            String filename = (!String.isBlank(fileMap.S3_File__r.Prefix__c) ? fileMap.S3_File__r.Prefix__c + '/' + fileMap.S3_File__r.Filename__c : fileMap.S3_File__r.Filename__c);  
            String[] filenameSplit = (fileMap.S3_File__r.Filename__c).split('\\.');
            // Generate an attribute map for the page.
            Map<String, String> fileAttributeMap = new Map<String,String>{
              'FileMap_Id' => fileMap.Id,
              'File_Id' => fileMap.S3_File__r.Id,
              'Bucket__c' => fileMap.S3_File__r.Bucket__c,
              'Content_Type__c' => fileMap.S3_File__r.Content_Type__c,
              'Prefix__c' => fileMap.S3_File__r.Prefix__c,
              'Filename__c' => fileMap.S3_File__r.Filename__c
            };  
            transactionAttachmentsMap.put(filenameSplit[0], fileAttributeMap);
            // Map the FileMap's temp urls for use on the page. 
            transactionAttachmentsUrlMap.put(fileMap.Id, EEC_S3ComponentCtrl.generateTempS3Url(fileMap.S3_File__r.Bucket__c, filename));
            // Add the file id to the ids list. 
            transactionFileIds.add(fileMap.S3_File__r.Id);
          }
          // Create a list of S3_File__c objects from the FileMap.
          List<S3_File__c> transactionFiles = [Select Id, Filename__c From S3_File__c Where Id IN :transactionFileIds];
          indoorAttachmentsJson = JSON.serialize(transactionFiles); 
          System.debug('----> Indoor Attachment Json: ' + indoorAttachmentsJson);
          System.debug('----> transactionAttachmentsMap: ' + transactionAttachmentsMap);
        } catch (Exception e) {
          System.debug('----> Error getting attachments: ' + e.getMessage());
        }
    }
    
    public String getRecordTypeJson() {
        return JSON.serialize(recordTypeMap);
    }
    
    public List<String> getButtonList(){
        List<String> ibwList = new List<String>();
        Boolean hasNewLicense = false;
        Boolean hasRenewal = false;
        Boolean hasLicenseUpgrade = false;
        Boolean hasChangeOfAddress = false;
        Boolean hasChangeOfHousehold = false;
        Boolean hasReActivate = false;
        Boolean hasInActivate = false;
        Boolean hasClosePrior = false;
        String ltRecordTypeName;
        
        if(provider.Licensing_Transactions__r != null){
            for(Licensing_Transaction__c lt : provider.Licensing_Transactions__r){
                ltRecordTypeName = lt.RecordType.DeveloperName;
                if(ltRecordTypeName == 'FCC_New_License' && isStatusClosed(lt.Status__c)){
                    hasNewLicense = true;
                }
                else if(ltRecordTypeName == 'FCC_Renewal' && isStatusClosed(lt.Status__c)){
                    hasRenewal = true;
                }
                else if(ltRecordTypeName == 'FCC_License_Upgrade' && isStatusClosed(lt.Status__c)){
                    hasLicenseUpgrade = true;
                }
                else if(ltRecordTypeName == 'Change_of_Address' && isStatusClosed(lt.Status__c)){
                    hasChangeOfAddress = true;
                }
                else if(ltRecordTypeName == 'FCC_Change_of_Household' && isStatusClosed(lt.Status__c)){
                    hasChangeOfHousehold = true;                }
                else if(ltRecordTypeName == 'FCC_Re_Active' && isStatusClosed(lt.Status__c)){
                    hasReActivate = true;
                }
                else if(ltRecordTypeName == 'FCC_Inactivate' && isStatusClosed(lt.Status__c)){
                    hasInActivate = true;
                }
                else if(ltRecordTypeName == 'Close_Prior_Expiration' && isStatusClosed(lt.Status__c)){
                    hasClosePrior = true;
                }
            }
        }
        
        System.debug('*********** -- '+hasRenewal+' -- '+hasLicenseUpgrade);
        /*Only if Provider.Record_Type = "Family Child Care" and (First Issue Date is NULL OR Expiration Date + 120 days <= Today) and 
            there is no other New License Transaction "Non Submitted", "Submitted" or "Under Review" (=> not Cancelled)*/       
            System.debug('************ - '+hasNewLicense);  
        if(providerRecordType == 'Family Child Care' && (provider.First_Issue_Date__c == null || (provider.renewal_date__c != null && provider.renewal_date__c < Date.Today().addDays(-120))) && !hasNewLicense){
            ibwList.add('Apply for a New License');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and (Today - 120 days <= Expiration Date <= Today + 120 days) and 
        there is no other Renewal License Transaction with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)*/
        
        if(providerRecordType == 'Family Child Care' && (provider.renewal_date__c != null && provider.renewal_date__c >= Date.Today().addDays(-120) && provider.renewal_date__c <= Date.Today().addDays(120)) && !hasRenewal){
            ibwList.add('Apply for License Renewal');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
        there is no other Renewal License Transaction / License Upgrade Transaction with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)*/           
        if(providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && (!hasRenewal || !hasLicenseUpgrade)){
            ibwList.add('Apply for an License Upgrade');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
        there is no other Renewal License Transaction / License Upgrade / Change of Address Transaction with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)*/       
        if(providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && (!hasRenewal || !hasLicenseUpgrade || !hasChangeOfAddress)){
            ibwList.add('Apply for a Change of Address');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
        there is no other Renewal License Transaction / License Upgrade / Change of Address Transaction with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled) */      
        if(providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && (!hasRenewal || !hasLicenseUpgrade || !hasChangeOfAddress)){
            ibwList.add('Notify Change of Room usage');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
        there is no other Renewal License Transaction / License Upgrade / Change in Household with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)           
        */
        if(providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && (!hasRenewal || !hasLicenseUpgrade || !hasChangeOfHousehold)){
            ibwList.add('Notify Change in Household / Individuals Regularly on the Premises');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed*/
        if(providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed'){
            ibwList.add('Request Re-issuance of License Certificate');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
        Provider Status = Inactive  and there is no other Re-Activate License transactions with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)*/            
        if(providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && provider.Provider_Status__c == 'Inactive' && !hasReActivate){
            ibwList.add('Re-Activate License');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
        there is no other De-Activate License transactions with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)  */      
        if(providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && !hasInActivate){
            ibwList.add('De-Activate License');
        }
        
        /*Only if Provider.Record_Type = "Family Child Care" and License Status = Licensed, and 
        there is no other Close Prior Expiration transactions with status "Non Submitted" or "Submitted" or "Under Review" (=> not Cancelled)*/     
        if(providerRecordType == 'Family Child Care' && provider.License_Status__c == 'Licensed' && !hasClosePrior){
            ibwList.add('Close Prior Expiration');
        }
        
        ibwList.add('Cancel');
        return ibwList;
    }
    
    public PageReference callTransaction(){
        licenseRecordTypeLabel = ApexPages.currentPage().getParameters().get('buttonLabel');
        if(licenseRecordTypeLabel == 'cancel'){
            PageReference pPage = page.EEC_PortalProviderPage;
            return pPage;
        }
        LicenseRecordTypeName = recordTypeMap.get(licenseRecordTypeLabel);
        
        if(String.isblank(licenseTransation.Provider__c)){
            licenseTransation.Provider__c = provider.Id;
        }
        licenseTransation.Last_Reached_Step__c = 'Instructions';
        licenseTransation.Status__c = 'To Submit';
        licenseTransation.RecordTypeId = EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.'+LicenseRecordTypeName).Id;
        upsert licenseTransation;
        
        PageReference pPage = Page.EEC_TransactionInstructions;
        //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
        pPage.getParameters().put('ltId', licenseTransation.Id);
        if(String.isNotBlank(memberId))
        	pPage.getParameters().put('member',memberId);
        pPage.setRedirect(true);
        return pPage;
    }
    
    public Pagereference cancelInstruction(){
        PageReference pPage = page.EEC_PortalProviderPage;
        if(String.isNotBlank(memberId))
        	pPage.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
        return pPage;
    }
    public Pagereference previousInstruction(){
        return Page.EEC_TransactionIntroduction;
    }
    Public void addMemberIDPageParameter(PageReference pPage, Boolean encrypt){
        if(String.isNotBlank(memberId)){
            if(encrypt)
                pPage.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
            else
            	pPage.getParameters().put('member',memberId);
        }
    }
    public Pagereference submitInstruction(){
        
        licenseTransation.Provider__c = provider.Id;
        licenseTransation.Submitter__c = Userinfo.getUserId();
        licenseTransation.Status__c = 'Submitted';
        licenseTransation.Last_Reached_Step__c = '';
        licenseTransation.RecordTypeId = EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.'+LicenseRecordTypeName).Id;
        insert licenseTransation;
        PageReference pPage = page.EEC_PortalProviderPage;
        addMemberIDPageParameter(pPage,false);
        return pPage;
    }
    
    public Pagereference nextInstruction(){
        if(String.isblank(licenseTransation.Provider__c)){
            licenseTransation.Provider__c = provider.Id;
        }
        licenseTransation.Last_Reached_Step__c = 'Transaction / Provider Information';
        licenseTransation.Status__c = 'To Submit';
        System.debug('*********** -- '+LicenseRecordTypeLabel + ' --- '+LicenseRecordTypeName);
        licenseTransation.RecordTypeId = EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.'+LicenseRecordTypeName).Id;
        upsert licenseTransation;
        
        licenseTransation = [select Id,name,Last_Reached_Step__c,RecordTypeId,Provider__c,License_Requested__c,New_Street_Address_1__c,New_Street_Address_2__c,
                                    New_City__c,New_Zip_Code__c,Live_at_New_Address__c,Moving_Date__c,Date_Care_Resumes__c,New_Address_Phone_Number__c,
                                    Work_Phone_Number__c, New_Phone_Number_Unlisted__c,Caring_For_Children_Not_Related__c,Evening_Overnight_Weekend_Care__c,Children_Home_Schooled__c,Children_Home_Schooled_Description__c,
                Approved_Foster_Care_Provider__c,Approved_Foster_Care_Provider_Descrip__c,Becoming_Foster_Care_Provider__c,Becoming_Foster_Care_Provider_Descrip__c,
                Business_Operated_Out_of_Own_Home__c,Bus_Operated_Out_of_Own_Home_Descrip__c,Use_Family_Child_Care_System__c,Use_Family_Child_Care_System_Descrip__c,
                Previous_Involvement_with_EEC_for_Unlice__c,Previous_Application_Certif_with_EEC__c,Prev_App_Certif_with_EEC_Descrip__c,Prev_App_Certif_with_Another_State__c,
                Prev_App_Certif_with_Another_State_Desc__c,Certificate_of_License_Revoked_Suspend__c,Certificate_or_License_Surrendered__c,Revocation_Suspension_Surrender_Reas__c,
                Child_Emergency_Injury_Last_3_Years__c,Child_Emerg_Injury_Last_3_Years_Descrip__c,Charged_or_Arrested_for_Crime__c,Charges_Description__c,Dealings_with_Child_Prot_Child_Welfar__c,
                Dealing_with_Child_Prot_Welfar_Descri__c,Registering_as_Sex_Offender__c,Sex_Offender_Nature_of_Incident__c,Restraining_Order_Issued__c,Use_of_Alcoholic_Bev_Narcotics_Drugs__c,
                Experience_Caring_for_Children_QUalifica__c,Alcoholic_Bev_Narcotics_Drugs_Desc__c,Abused_or_neglected_a_child__c,Abused_or_neglected_a_child_Description__c  from Licensing_Transaction__c where Id = :licenseTransation.Id];
        PageReference pPage = Page.EEC_TransactionProvider;
        //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage,false);
        pPage.setRedirect(true);
        return pPage;
    }
    
    public Pagereference saveAndNextTransactionProvider(){
        ihmList = new List<Household_Member__c>();
        removeHMList = new List<Household_Member__c>();
        Set<Id> recordTypeIdSet = new Set<Id>();

        if(LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'Change_of_Address' || 
                LicenseRecordTypeName == 'FCC_License_Upgrade' || LicenseRecordTypeName == 'FCC_Change_of_Household'){
            licenseTransation.Last_Reached_Step__c = 'Household Members';   
        }
        else{
            licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
        }
        update licenseTransation;
        update provider;
        if(cntct != null){
            update cntct;
        }
        
        recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_New_License').Id);
        recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_Renewal').Id);
        recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.Change_of_Address').Id);
        recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_License_Upgrade').Id);
        recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_Change_of_Household').Id);
        licenseTransation = [select Id,name,Last_Reached_Step__c,Drinking_Water_Source__c,Exits_Descriptions__c,RecordTypeId,Provider__c,Technical_Assistance__c ,Caring_For_Children_Not_Related__c,
                                    Evening_Overnight_Weekend_Care__c,Children_Home_Schooled__c,Children_Home_Schooled_Description__c,New_Street_Address_1__c,
                                    New_Street_Address_2__c,New_City__c,New_Zip_Code__c,Live_at_New_Address__c,Moving_Date__c,Date_Care_Resumes__c,New_Address_Phone_Number__c,
                                    Work_Phone_Number__c, New_Phone_Number_Unlisted__c,Approved_Foster_Care_Provider__c,Approved_Foster_Care_Provider_Descrip__c,
                                    Becoming_Foster_Care_Provider__c,Becoming_Foster_Care_Provider_Descrip__c,License_Requested__c,Business_Operated_Out_of_Own_Home__c,Abused_or_neglected_a_child__c,Abused_or_neglected_a_child_Description__c,
                                    Bus_Operated_Out_of_Own_Home_Descrip__c, Alcoholic_Bev_Narcotics_Drugs_Desc__c, Use_Family_Child_Care_System__c,Use_Family_Child_Care_System_Descrip__c,Working_With_Assistant__c 
                               from Licensing_Transaction__c where Id = :licenseTransation.Id];
        
        List<Household_Member__c> tempHMList = [select relationship_to_Provider__c, Provider__c, Occupation__c, Name, Licensing_Transactions__c,Last_Name__c, Id,Number_of_Hours_Home_During_Child_Care__c, 
                                                           First_Name__c, Email_Address__c, Date_of_Birth__c, Current__c, Current_School_Grade__c,CreatedDate from Household_Member__c where Licensing_Transactions__c = :licenseTransation.Id];
        if(LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'Change_of_Address' || 
                LicenseRecordTypeName == 'FCC_License_Upgrade' || LicenseRecordTypeName == 'FCC_Change_of_Household'){
                    
            if(tempHMList == null || tempHMList.size() ==0){
                List<Household_Member__c> thmList = [select Id, Licensing_Transactions__c from Household_Member__c where Provider__c = :provider.Id and 
                                                                licensing_transactions__R.Status__c != 'Cancelled' and 
                                                                licensing_transactions__r.RecordTypeId in :recordTypeIdSet order by Licensing_Transactions__r.CreatedDate desc];
                if(thmList != null && thmList.size() > 0){
                    Household_Member__c thm = thmList.get(0);
                    List<Household_Member__c> hmList = [select Relationship_to_Provider__c, Provider__c, Occupation__c, Name, Licensing_Transactions__c,Last_Name__c, Id,Number_of_Hours_Home_During_Child_Care__c, 
                                                                   First_Name__c, Email_Address__c, Date_of_Birth__c, Current__c, Current_School_Grade__c,CreatedDate 
                                                              From Household_Member__c where Licensing_Transactions__c = :thm.Licensing_Transactions__c];
                    Household_Member__c iHm;
                    for(Household_Member__c hm : hmList){
                        iHm = new Household_Member__c();
                        iHm.Relationship_to_Provider__c = hm.Relationship_to_Provider__c;
                        iHm.Provider__c = hm.provider__c;
                        iHm.Occupation__c = hm.Occupation__c;
                        iHm.Licensing_Transactions__c = licenseTransation.Id;
                        iHm.Last_Name__c = hm.Last_Name__c;
                        iHm.First_Name__c = hm.First_Name__c;
                        iHm.Email_Address__c = hm.Email_Address__c;
                        iHm.Date_of_Birth__c = hm.Date_of_Birth__c;
                        iHm.Current__c = hm.Current__c;
                        iHm.Current_School_Grade__c = hm.Current_School_Grade__c;
                        iHm.Number_of_Hours_Home_During_Child_Care__c = hm.Number_of_Hours_Home_During_Child_Care__c;
                        ihmList.add(iHm);
                    }
                  insert ihmList;
                }
            }
            else{
                // Household_Member is a child of License_Transaction__c. Therefore you cannot get the relation without doing a sub query on the data set. 
                //   Using the temp list is perfectly acceptable as it is a proper representation of the data for the transaction.
                //ihmList = licenseTransation.Household_Member__r;
                ihmList = tempHMList;
            }
            ihmListJson = JSON.serialize(ihmList);      
            PageReference pPage = Page.EEC_HouseholdMembers;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);        
            pPage.setRedirect(true);
            return pPage;
        }   
        else{
            if(!initIndoor){
                initializeIndoor();
            }
            PageReference pPage = Page.EEC_IndoorSpacePage;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);
            pPage.setRedirect(true);
            return pPage;
        }
    }
    
    public Pagereference saveAndPreviousTransactionProvider(){
        
        if(LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'Change_of_Address' || 
                LicenseRecordTypeName == 'FCC_License_Upgrade' || LicenseRecordTypeName == 'FCC_Change_of_Household'){
            licenseTransation.Last_Reached_Step__c = 'Household Members';   
        }
        else{
            licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
        }
        update licenseTransation;
        update provider;
        if(cntct != null){
            update cntct;
        }
        PageReference pPage = Page.EEC_TransactionIntroduction;
        //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage,false);
        pPage.setRedirect(true);
        return pPage;
    }
    
    public Pagereference saveAndReturnTransactionProvider(){
        /*if(licenseTransation.Can_Communicate_in_English__c == 'No'){
            
        }*/
        
        if(LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'Change_of_Address' || 
                LicenseRecordTypeName == 'FCC_License_Upgrade' || LicenseRecordTypeName == 'FCC_Change_of_Household'){
            licenseTransation.Last_Reached_Step__c = 'Household Members';   
        }
        else{
            licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
        }
        update licenseTransation;
        update provider;
        if(cntct != null){
            update cntct;
        }
        PageReference pPage = page.EEC_PortalProviderPage;
        addMemberIDPageParameter(pPage,true);
        return pPage;
    }
    
    public void AddRow()
    {
        ihmList.add(new Household_Member__c());
    }
   
    public void delRow()
    {
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        Household_Member__c tHM = ihmList.get(rowNum);
        if(String.isNotBlank(tHM.Id)){
            removeHMList.add(ihmList.get(rowNum));
        }
        ihmList.remove(rowNum);  
    }
    
    public void AddRowLS()
    {
        if(faList == null){
            faList = new List<FCC_Assistant__c>();
        }
        faList.add(new FCC_Assistant__c());
    }
   
    public void delRowLS()
    {
        if(removeFAList == null){
            removeFAList = new List<FCC_Assistant__c>();
        }
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        if(faList != null && faList.size () > 0){
            FCC_Assistant__c tFA = faList.get(rowNum);
            if(String.isNotBlank(tFA.Id)){
                removeFAList.add(faList.get(rowNum));
            }
            faList.remove(rowNum);
        }
    }
    
    public void AddRowEH()
    {
        if(ehList == null){
            ehList = new List<Employment_History__c>();
        }
        ehList.add(new Employment_History__c());
    }
   
    public void delRowEH()
    {
        if(removeEHList == null){
            removeEHList = new List<Employment_History__c>();
        }
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        Employment_History__c tEH = ehList.get(rowNum);
        if(String.isNotBlank(tEH.Id)){
            removeEHList.add(ehList.get(rowNum));
        }
        ehList.remove(rowNum);
    }
    
    public void delRowRoom()
    {
        if(removeRoomList == null){
            removeRoomList = new List<Room__c>();
        }
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        Room__c rm = roomList.get(rowNum);
        if(String.isNotBlank(rm.Id)){
            removeRoomList.add(roomList.get(rowNum));
        }
        roomList.remove(rowNum);
    }
     
    public void AddRowRoom()
    {
        if(roomList == null){
            roomList = new List<Room__c>(); 
        }
        roomList.add(new Room__c());
    }
    
    public void delRowTE()
    {
        if(removeTEList == null){
            removeTEList = new List<Training_Experience__c>();
        }
        rowNum = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));
        Training_Experience__c rm = teList.get(rowNum);
        if(String.isNotBlank(rm.Id)){
            removeTEList.add(teList.get(rowNum));
        }
        teList.remove(rowNum);
    }
     
    public void AddRowTE()
    {
        if(teList == null){
            teList = new List<Training_Experience__c>(); 
        }
        teList.add(new Training_Experience__c());
    }
    
    public Pagereference CancelTransaction(){
        Licensing_Transaction__c lt = new Licensing_Transaction__c(id=licenseTransation.id);
        lt.Status__c = 'Cancelled';
        lt.Reason_Closed_Cancelled__c = 'Cancelled by portal user';
        update lt;
        
        PageReference pPage = page.EEC_PortalProviderPage;
        addMemberIDPageParameter(pPage,true);
        return pPage;
    }
    
    public Pagereference SaveAndNextHH(){
        try{
            saveHH();
            initHH = true;
            //Licensing_Transaction__c lt = new Licensing_Transaction__c(id=licenseTransation.id);
            if(LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade'){
                rowNum = 0;
                licenseTransation.Last_Reached_Step__c = 'License Status and Capacity / Assistant Information';
                update licenseTransation;
                if(!initLS){
                    initializeLS();
                }
                PageReference pPage = Page.EEC_LicenseStatusCapacityInfo;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                pPage.setRedirect(true);
                return pPage;
            }
            else if(LicenseRecordTypeName == 'Change_of_Address' ){
                licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
                update licenseTransation;
                if(!initIndoor){
                    initializeIndoor();
                }
                PageReference pPage = Page.EEC_IndoorSpacePage;
        		//pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
        		pPage.setRedirect(true);
        		return pPage;
            }
            else if(LicenseRecordTypeName == 'FCC_Change_of_Household' ){
                licenseTransation.Last_Reached_Step__c = 'Daily Routing Activities / Technical Assistance';
                update licenseTransation;
                
                PageReference pPage = Page.EEC_TechnicalAssistance;
        		//pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
        		pPage.setRedirect(true);
        		return pPage;
            }
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage,true);
            return pPage;
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousHH(){
        try{
            saveHH();
            //Licensing_Transaction__c lt = new Licensing_Transaction__c(id=licenseTransation.id,Last_Reached_Step__c = 'Household Members');
            licenseTransation.Last_Reached_Step__c = 'Household Members';
            update licenseTransation;
            
            PageReference pPage = Page.EEC_TransactionProvider;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);
            pPage.setRedirect(true);
            return pPage;
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnHH(){
        try{
            saveHH();
            licenseTransation.Last_Reached_Step__c = 'Household Members';
            update licenseTransation;
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage,true);
            return pPage;
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    private void saveHH(){  
      if(ihmList != null && ihmList.size() > 0){
        for(Household_Member__c thm : ihmList){
          if(thm.Id == null){
            thm.Current__c = false;
            thm.Provider__c = provider.Id;
            thm.Licensing_Transactions__c = licenseTransation.Id;
            //System.debuthm.Number_of_Hours_Home_During_Child_Care__c
          }
        }
        upsert ihmList;
        ihmListJson = JSON.serialize(ihmList);
      }
            
      if(removeHMList != null && removeHMList.size() > 0){
        delete removeHMList;
      }       
    }
    
    public Pagereference SaveAndNextTA(){
        try{
            if(LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade'){
                //Licensing_Transaction__c lt = new Licensing_Transaction__c(id=licenseTransation.id,Last_Reached_Step__c = 'Attachments');
                licenseTransation.Last_Reached_Step__c = 'Attachments';
                update licenseTransation;
                if(!initLS){
                    initializeLS();
                }
                refreshAttachmentsList();
                
                PageReference pPage = Page.EEC_LicenseTransactionAttachments;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
                pPage.setRedirect(true);
                return pPage;
            }
            else if(LicenseRecordTypeName == 'Change_of_Address' || LicenseRecordTypeName == 'FCC_Change_of_Household' || LicenseRecordTypeName == 'FCC_Change_Room_Floor_Level'){
                licenseTransation.Last_Reached_Step__c = 'Review Summary and Submission';
                update licenseTransation;
                //return Page.EEC_LicenseStatusCapacityInfo;
            }
            
            PageReference pPage = Page.EEC_ReviewSummarySubmission;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);
            pPage.setRedirect(true);
            return pPage;
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousTA(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Daily Routing Activities / Technical Assistance';
            update licenseTransation;
            System.debug('-----> ihmList' + ihmList);
            if(LicenseRecordTypeName == 'FCC_Change_of_Household'){
                PageReference pPage = Page.EEC_HouseholdMembers;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
                pPage.setRedirect(true);
                return pPage;
            }
            else{
                //initializeIndoor();
                PageReference pPage = Page.EEC_IndoorSpacePage;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
                pPage.setRedirect(true);
                return pPage;
            }
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnTA(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Daily Routing Activities / Technical Assistance';
            update licenseTransation;
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage,true);
            return pPage;
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndNextLS(){
        try{
            if(LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade'){
                licenseTransation.Last_Reached_Step__c = 'Background Information';
                update licenseTransation;
                saveLS();
                
                PageReference pPage = Page.EEC_BackgroundInformation;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
                pPage.setRedirect(true);
                return pPage;
            }
            else{
                licenseTransation.Last_Reached_Step__c = 'EEC Involvement Experience & Professional Exp.';
                update licenseTransation;
                saveLS();
                PageReference pPage = Page.EEC_InvolvementExperience;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
                pPage.setRedirect(true);
                return pPage;
            }
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousLS(){
        try{
            licenseTransation.Last_Reached_Step__c = 'License Status and Capacity / Assistant Information';
            update licenseTransation;
            saveLS();
            
            PageReference pPage = Page.EEC_HouseholdMembers;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);
            pPage.setRedirect(true);
            return pPage;
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnLS(){
        try{
            licenseTransation.Last_Reached_Step__c = 'License Status and Capacity / Assistant Information';
            update licenseTransation;
            saveLS();
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage,true);
            return pPage;
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    } 
    
    public Pagereference showLSDesc(){
        return null;
    }
    
    public Pagereference showAddAssistanceDesc(){
        AddRowLS();
        return null;
    }
    
    public Pagereference showCBDesc(){
        selectedHestStr = '';
        if(selectedHestElems != null){
            for(String tstr :selectedHestElems){
                selectedHestStr = selectedHestStr + tStr + ',';
            }
        }
        else{
            selectedHestElems = new List<String>();
        }
        // Re-map the mappings to remove the attachment.
        generateAttachmentMappings();
        refreshAttachmentsList();
        return null;
    }
    
    public PageReference showWaterUpload() {
      System.debug('----> [showWaterUpload]selectedWaterStr: ' + selectedWaterStr);  
      if (String.isBlank(selectedWaterStr)) {
        //selectedWaterStr = licenseTransation.Drinking_Water_Source__c.equalsIgnoreCase('Town Water Supply') ? 'Private Water Supply' : 'Town Water Supply';      
        selectedWaterStr = '';
      } else {
        selectedWaterStr = selectedWaterStr.equalsIgnoreCase('Town Water Supply') ? 'Private Water Supply' : 'Town Water Supply';
      }
      // Re-map the mappings to remove the attachment.
      generateAttachmentMappings();
      refreshAttachmentsList();
      return null;
    }
    
    public Pagereference SaveAndNextEH(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Background Information';
            update licenseTransation;
            saveEH();
            
            PageReference pPage = Page.EEC_BackgroundInformation;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);
            pPage.setRedirect(true);
            return pPage;
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousEH(){
        try{
            licenseTransation.Last_Reached_Step__c = 'EEC Involvement Experience & Professional Exp.';
            update licenseTransation;
            saveEH();
            
            PageReference pPage = Page.EEC_LicenseStatusCapacityInfo;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);
            pPage.setRedirect(true);
            return pPage;
            }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnEH(){
        try{
            licenseTransation.Last_Reached_Step__c = 'EEC Involvement Experience & Professional Exp.';
            update licenseTransation;
            saveEH();
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage,true);
            return pPage;
         }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndNextBI(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Training Information';
            update licenseTransation;
            if(!initTraining){
                initializeTraining();
            }
            generateAttachmentMappings();
            retrieveAddtionalTrainingAttachmentsList();
            
            PageReference pPage = Page.EEC_TrainingInformation;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);
            pPage.setRedirect(true);
            return pPage;
         }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousBI(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Background Information';
            update licenseTransation;
            if(LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade'){
                PageReference pPage = Page.EEC_LicenseStatusCapacityInfo;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
                pPage.setRedirect(true);
                return pPage;
            }
            else{
                PageReference pPage = Page.EEC_InvolvementExperience;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
                pPage.setRedirect(true);
                return pPage;
            }
         }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnBI(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Background Information';
            update licenseTransation;
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage,true);
            return pPage;
         }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
     public Pagereference SaveAndNextRoom(){
        //try{
            licenseTransation.Last_Reached_Step__c = 'Daily Routing Activities / Technical Assistance';
            saveRoom();
         
            PageReference pPage = Page.EEC_TechnicalAssistance;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false); 
            pPage.setRedirect(true);
            return pPage;
        /*}catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;*/
        
    }
    
    public Pagereference SaveAndPreviousRoom(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
            saveRoom();
            if(LicenseRecordTypeName == 'FCC_Change_Room_Floor_Level'){
                PageReference pPage = Page.EEC_TransactionProvider;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
                pPage.setRedirect(true);
                return pPage;
            }
            else if(LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade'){
                //initializeTraining();
                generateAttachmentMappings();
                retrieveAddtionalTrainingAttachmentsList();
                
                PageReference pPage = Page.EEC_TrainingInformation;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
                pPage.setRedirect(true);
                return pPage;
            }
            else{
                System.debug('-----> ihmList: ' + ihmList);
                PageReference pPage = Page.EEC_HouseholdMembers;
                //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
                pPage.getParameters().put('ltId', licenseTransation.Id);
                addMemberIDPageParameter(pPage,false);
                pPage.setRedirect(true);
                return pPage;
            }
         }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnRoom(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
            saveRoom();
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage,true);
            return pPage;
         }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndNextTE(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Indoor / Outdoor space information';
            saveTE();
            if(!initIndoor){
                initializeIndoor();
            }
            PageReference pPage = Page.EEC_IndoorSpacePage;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);
            pPage.setRedirect(true);
            return pPage;
         }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndPreviousTE(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Training Information';
            saveTE();
            
            PageReference pPage = Page.EEC_BackgroundInformation;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);
            pPage.setRedirect(true);
            return pPage;
        }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public Pagereference SaveAndReturnTE(){
        try{
            licenseTransation.Last_Reached_Step__c = 'Training Information';
            saveTE();
            PageReference pPage = page.EEC_PortalProviderPage;
            addMemberIDPageParameter(pPage,true);
            return pPage;
         }catch(Exception e){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
            ApexPages.addMessage(errMsg);
        }
        return null;
    }
    
    public PageReference SaveAndNextAttachment() {
      try {
        licenseTransation.Last_Reached_Step__c = 'Attachments';
        update licenseTransation;  
        refreshAttachmentsList();
          
        PageReference pPage = Page.EEC_ReviewSummarySubmission;
        //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage,false);
        pPage.setRedirect(true);
        return pPage;
      } catch (Exception e) {
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
        ApexPages.addMessage(errMsg);
      }
      return null;
    }
    
    public PageReference SaveAndPreviousAttachment() {
      try {
        licenseTransation.Last_Reached_Step__c = 'Attachments';
        update licenseTransation;
        refreshAttachmentsList();
        PageReference pPage = Page.EEC_TechnicalAssistance;
        //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
        pPage.getParameters().put('ltId', licenseTransation.Id);
        addMemberIDPageParameter(pPage,false);  
        pPage.setRedirect(true);
        return pPage;
      } catch (Exception e) {
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
        ApexPages.addMessage(errMsg);
      }
      return null;
    }
    
    public PageReference SaveAndReturnAttachment() {
      try {
        licenseTransation.Last_Reached_Step__c = 'Attachments';
        update licenseTransation;
        PageReference pPage = page.EEC_PortalProviderPage;
        addMemberIDPageParameter(pPage,true);  
        return pPage;
      } catch (Exception e) {
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
        ApexPages.addMessage(errMsg);
      }
      return null;  
    }
    
    public Pagereference previousRS(){
        try{
          // Update the last step.
          licenseTransation.Last_Reached_Step__c = 'Review Summary and Submission';
          update licenseTransation;
          // If New, Renewal, or Upgrade then back to attachments. Else go to TA.  
          if(LicenseRecordTypeName == 'FCC_New_License' || LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade'){
            refreshAttachmentsList();
              
            PageReference pPage = Page.EEC_LicenseTransactionAttachments;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);  
            pPage.setRedirect(true);
            return pPage;
          }
            PageReference pPage = Page.EEC_TechnicalAssistance;
            //pPage.getParameters().put('ltId', EEC_Util.encryptGetParam(licenseTransation.Id));
            pPage.getParameters().put('ltId', licenseTransation.Id);
            addMemberIDPageParameter(pPage,false);
            pPage.setRedirect(true);
            return pPage;
        }catch(Exception e){
          ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
          ApexPages.addMessage(errMsg);
        }
        return null;
    }
    public Pagereference submitRS(){
        licenseTransation.Submitter__c = Userinfo.getUserId();
        licenseTransation.Status__c = 'Submitted';
        licenseTransation.Submission_Date__c = Date.today();
        licenseTransation.Source__c = 'Provider Portal';
        update licenseTransation;
        PageReference pPage = page.EEC_PortalProviderPage;
        addMemberIDPageParameter(pPage,true);
        return pPage;
    }
    public Pagereference SaveAndReturnRS(){
        licenseTransation.Last_Reached_Step__c = 'Review Summary and Submission';
        update licenseTransation;
        PageReference pPage = page.EEC_PortalProviderPage;
        addMemberIDPageParameter(pPage,true);
        return pPage;
    } 
    
    private void saveLS(){
        if(faList != null ){
            for(FCC_Assistant__c tfa : faList){
                tfa.Current__c = false;
                if(tfa.Id == null){
                    tfa.Provider__c = provider.Id;
                    tfa.Source_Transaction__c = licenseTransation.Id;
                }
            }
            upsert faList;
        }
        
        if(removeFAList != null && removeFAList.size() > 0){
            delete removeFAList;
        }
    }
     
    private void saveEH(){
        
        if(ehList != null ){
            for(Employment_History__c eh : ehList){
                if(loggedUser.contactId != null){
                    eh.Contact__c = loggedUser.contactId;
                }
                eh.Licensing_Transaction__c = licenseTransation.Id;
            }
            upsert ehList;
        }
        
        if(removeEHList != null && removeEHList.size() > 0){
            delete removeEHList;
        }
    } 
    
     private void saveRoom(){
        String selectedHest = '';
        Boolean Start = true;
        if(!selectedHestElems.isEmpty()) {          
            for(String Str : selectedHestElems) {
                if(Start) {
                    selectedHest = Str;
                    Start = false;
                } else {              
                    selectedHest = selectedHest + ';' + Str;
                }
            }
        }
        licenseTransation.Heating_Elements__c = selectedHest;
        update licenseTransation;
        
        if(roomList != null ){
            for(Room__c rm : roomList){
                rm.Current__c = false;
                if(rm.Id == null){
                    rm.Source_Transaction__c = licenseTransation.Id;
                    //rm.Provider_Name__c = provider.Id;
                }
            }
            upsert roomList;
        }
        
        if(removeRoomList != null && removeRoomList.size() > 0){
            delete removeRoomList;
        }
    } 
    
    private void saveTE(){
        update licenseTransation;
        
        if(teList != null ){
            for(Training_Experience__c tfa : teList){
                if(tfa.Id == null){
                    if(loggedUser.contactId != null){
                        tfa.Contact__c = loggedUser.contactId;
                    }
                }
                tfa.Licensing_Transactions__c = licenseTransation.Id;
            }
            upsert teList;
        }
        
        if(removeTEList != null && removeTEList.size() > 0){
            delete removeTEList;
        }
    }
    
    
    private Boolean isStatusClosed(String status){
        return (status == 'Submitted' || status == 'To Submit' || status == 'Under Review');
    }   
    
    private void initializeLS(){
        initLS = true;
        Set<Id> recordTypeIdSet = new Set<Id>();
        faList = new List<FCC_Assistant__c>();
        if(LicenseRecordTypeName == 'FCC_Renewal' || LicenseRecordTypeName == 'FCC_License_Upgrade'){
            recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_New_License').Id);
            recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_Renewal').Id);
            recordTypeIdSet.add(EEC_RecordTypeUtil.findByName('Licensing_Transaction__c.FCC_License_Upgrade').Id);
            
            List<Licensing_Transaction__c> tltList = [select Id,Caring_For_Children_Not_Related__c,Evening_Overnight_Weekend_Care__c,Children_Home_Schooled__c,Working_With_Assistant__c,
                                                             Children_Home_Schooled_Description__c,Approved_Foster_Care_Provider__c,Approved_Foster_Care_Provider_Descrip__c,
                                                             Becoming_Foster_Care_Provider_Descrip__c,Business_Operated_Out_of_Own_Home__c,Bus_Operated_Out_of_Own_Home_Descrip__c,
                                                             Use_Family_Child_Care_System__c,Use_Family_Child_Care_System_Descrip__c,Becoming_Foster_Care_Provider__c,
                                                             Previous_Involvement_with_EEC_for_Unlice__c,Previous_Application_Certif_with_EEC__c,Prev_App_Certif_with_EEC_Descrip__c,Prev_App_Certif_with_Another_State__c,
                                                             Prev_App_Certif_with_Another_State_Desc__c,Abused_or_neglected_a_child__c,Abused_or_neglected_a_child_Description__c, Certificate_of_License_Revoked_Suspend__c,Certificate_or_License_Surrendered__c,Revocation_Suspension_Surrender_Reas__c,
                                                             Experience_Caring_for_Children_QUalifica__c,Child_Emergency_Injury_Last_3_Years__c,Child_Emerg_Injury_Last_3_Years_Descrip__c,Charged_or_Arrested_for_Crime__c,
                                                             Charges_Description__c,Dealings_with_Child_Prot_Child_Welfar__c,Dealing_with_Child_Prot_Welfar_Descri__c,Registering_as_Sex_Offender__c,Sex_Offender_Nature_of_Incident__c,
                                                             Restraining_Order_Issued__c,Alcoholic_Bev_Narcotics_Drugs_Desc__c ,Use_of_Alcoholic_Bev_Narcotics_Drugs__c,Work_Phone_Number__c,
                                                             (select Id,First_Name__c,Last_Name__c,Mailing_Address__c,License_Number__c,License_Expiration_Date__c from FCC_Assistants__r)  
                                                             from Licensing_Transaction__c where provider__c = :provider.Id and Id != :licenseTransation.Id and Status__c != 'Cancelled' order by createddate desc limit 1];
            if(tltList != null && tltList.size() > 0){
                Licensing_Transaction__c lt = tltList.get(0);
                licenseTransation.Caring_For_Children_Not_Related__c = lt.Caring_For_Children_Not_Related__c;
                licenseTransation.Evening_Overnight_Weekend_Care__c = lt.Evening_Overnight_Weekend_Care__c;
                licenseTransation.Children_Home_Schooled__c = lt.Children_Home_Schooled__c;
                licenseTransation.Children_Home_Schooled_Description__c = lt.Children_Home_Schooled_Description__c;
                licenseTransation.Approved_Foster_Care_Provider__c = lt.Approved_Foster_Care_Provider__c;
                licenseTransation.Approved_Foster_Care_Provider_Descrip__c = lt.Approved_Foster_Care_Provider_Descrip__c;
                licenseTransation.Becoming_Foster_Care_Provider__c = lt.Becoming_Foster_Care_Provider__c;
                licenseTransation.Becoming_Foster_Care_Provider_Descrip__c = lt.Becoming_Foster_Care_Provider_Descrip__c;
                licenseTransation.Business_Operated_Out_of_Own_Home__c = lt.Business_Operated_Out_of_Own_Home__c;
                licenseTransation.Bus_Operated_Out_of_Own_Home_Descrip__c = lt.Bus_Operated_Out_of_Own_Home_Descrip__c;
                licenseTransation.Use_Family_Child_Care_System__c = lt.Use_Family_Child_Care_System__c;
                licenseTransation.Use_Family_Child_Care_System_Descrip__c = lt.Use_Family_Child_Care_System_Descrip__c;
                licenseTransation.Working_With_Assistant__c = lt.Working_With_Assistant__c;
                
                FCC_Assistant__c fa;
                if(lt.FCC_Assistants__r != null && lt.FCC_Assistants__r.size() > 0){
                    for(FCC_Assistant__c ta : lt.FCC_Assistants__r){
                        fa = new FCC_Assistant__c();
                        fa.First_Name__c = ta.First_Name__c;
                        fa.Last_Name__c = ta.Last_Name__c;
                        fa.Mailing_Address__c = ta.Mailing_Address__c;
                        fa.License_Number__c = ta.License_Number__c;
                        fa.License_Expiration_Date__c = ta.License_Expiration_Date__c;
                        fa.Provider__c = Provider.Id;
                        fa.Source_Transaction__c = licenseTransation.Id;
                        faList.add(fa);
                    }
                }
                insert faList;
            }
            
        
        }
    }
    
    private void initializeIndoor(){
        selectedHestElems = new List<String>();
        initIndoor = true;
        List<Licensing_Transaction__c> tltList = [select Id, FCC_Residence_Description__c, At_Least_2_Exits__c,Exits_Descriptions__c,Heating_Elements__c,
                                                                 (select Id, Name, Use__c,Dimension_Length_feet__c,Dimension_Width_feet__c,Floor_Level__c From Rooms__r),
                                                                 Need_Assist_to_Barricade_Heating_Units__c,Drinking_Water_Source__c,Outdoor_Space_Changed__c,Outdoor_Space_Changes_Description__c
                                                            from Licensing_Transaction__c where provider__c = :provider.Id and Id != :licenseTransation.Id and Status__c != 'Cancelled' and 
                                                             RecordType.DeveloperName in ('FCC_New_License', 'FCC_License_Upgrade','FCC_Renewal','FCC_Change_Room_Floor_Level','Change_of_Address') order by createddate desc limit 1];
        Licensing_Transaction__c lt;
        roomList = new List<Room__c>();
        if(tltList != null && tltList.size() > 0 && LicenseRecordTypeName != 'FCC_New_License'){
            lt = tltList.get(0);
            licenseTransation.FCC_Residence_Description__c = lt.FCC_Residence_Description__c;
            licenseTransation.At_Least_2_Exits__c = lt.At_Least_2_Exits__c;
            licenseTransation.Exits_Descriptions__c = lt.Exits_Descriptions__c;
            licenseTransation.Heating_Elements__c = lt.Heating_Elements__c;
            licenseTransation.Need_Assist_to_Barricade_Heating_Units__c = lt.Need_Assist_to_Barricade_Heating_Units__c;
            licenseTransation.Drinking_Water_Source__c = lt.Drinking_Water_Source__c;
            licenseTransation.Outdoor_Space_Changed__c = lt.Outdoor_Space_Changed__c;
            licenseTransation.Outdoor_Space_Changes_Description__c = lt.Outdoor_Space_Changes_Description__c;
            if(String.isNotEmpty(lt.Heating_Elements__c)){
                selectedHestElems = lt.Heating_Elements__c.split(';');
            }
            Room__c tRoom;  
            if(lt.Rooms__r != null && lt.Rooms__R.size() > 0){
                for(Room__c rm : lt.Rooms__r){
                //roomList = lt.Rooms__r;
                    tRoom = new Room__c();
                    tRoom.Name = rm.Name;
                    tRoom.Use__c = rm.Use__c;
                    tRoom.Dimension_Length_feet__c = rm.Dimension_Length_feet__c;
                    tRoom.Dimension_Width_feet__c = rm.Dimension_Width_feet__c;
                    tRoom.Floor_Level__c = rm.Floor_Level__c;
                    tRoom.Source_Transaction__c = licenseTransation.Id;
                    roomList.add(tRoom);
                }
                insert roomList;
            }
        }
        System.debug('*******1 -- '+licenseTransation.Heating_Elements__c);
    }
    
    public void initializeTraining(){
        initTraining = true;
        List<Licensing_Transaction__c> tltList = [select Id, Belong_to_Food_Program__c,Which_Food_Program__c,Took_Medication_Administration_Training__c,RecordType.DeveloperName,
                                                         Date_Med_Administration_Training_Taken__c,Took_Transportation_Training__c,
                                                         Date_Transportation_Training_Taken__c,Took_SIDS_Training__c,Date_Last_SIDS_Training_Taken__c,Took_USDA_Nutrition_Training__c,
                                                         Date_USDA_Nutrition_Training_Taken__c,Took_Upgrading_Capacity_Training__c,Date_Upgrading_Capacity_Training_Taken__c,
                                                         Took_FCC_Orientation__c,Date_FCC_Orientation_Taken__c,CPR_Certified__c,CPR_Certification_Issue_Date__c,First_Aid_Certified__c,
                                                         First_Aid_Certification_Issue_Date__c,Took_FCC_Orientation_Module_1__c,Date_FCC_Orientation_Mod_1_Taken__c, 
                                                  		(select Id,Name,Topic__c,Number_of_Training_Hours__c,Date_of_the_Training__c from Training_Experience__r) from
                                                         Licensing_Transaction__c where provider__c = :provider.Id and Id != :licenseTransation.Id and Status__c != 'Cancelled' and 
                                                         RecordType.DeveloperName in ('FCC_New_License', 'FCC_License_Upgrade','FCC_Renewal') order by createddate desc limit 1];
        Licensing_Transaction__c lt;
        Licensing_Transaction__c rlt;
        teList = new List<Training_Experience__c>();
        if(tltList != null && tltList.size() > 0){
            lt = tltList.get(0);
            licenseTransation.Belong_to_Food_Program__c = lt.Belong_to_Food_Program__c;
            licenseTransation.Which_Food_Program__c = lt.Which_Food_Program__c;
            licenseTransation.Took_Medication_Administration_Training__c = lt.Took_Medication_Administration_Training__c;
            licenseTransation.Date_Med_Administration_Training_Taken__c = lt.Date_Med_Administration_Training_Taken__c;
            licenseTransation.Took_Transportation_Training__c = lt.Took_Transportation_Training__c;
            licenseTransation.Date_Transportation_Training_Taken__c = lt.Date_Transportation_Training_Taken__c;
            licenseTransation.Took_USDA_Nutrition_Training__c = lt.Took_USDA_Nutrition_Training__c;
            licenseTransation.Date_USDA_Nutrition_Training_Taken__c = lt.Date_USDA_Nutrition_Training_Taken__c;
            licenseTransation.Took_Upgrading_Capacity_Training__c = lt.Took_Upgrading_Capacity_Training__c;
            licenseTransation.Date_Upgrading_Capacity_Training_Taken__c = lt.Date_Upgrading_Capacity_Training_Taken__c;
            licenseTransation.Took_FCC_Orientation__c = lt.Took_FCC_Orientation__c;
            licenseTransation.Date_FCC_Orientation_Taken__c = lt.Date_FCC_Orientation_Taken__c;
            licenseTransation.Took_FCC_Orientation_Module_1__c = lt.Took_FCC_Orientation_Module_1__c;
            licenseTransation.Date_FCC_Orientation_Mod_1_Taken__c = lt.Date_FCC_Orientation_Mod_1_Taken__c;
            
            for(Licensing_Transaction__c lt1 : tltList){
                if(lt.RecordType.DeveloperName == 'FCC_Renewal'){
                    rlt = lt1;
                    Training_Experience__c te;  
                    if(rlt.Training_Experience__r != null && rlt.Training_Experience__r.size() > 0){
                        for(Training_Experience__c rm : lt.Training_Experience__r){
                            te = new Training_Experience__c();
                            te.Topic__c = rm.Topic__c;
                            te.Date_of_the_Training__c = rm.Date_of_the_Training__c;
                            te.Number_of_Training_Hours__c = rm.Number_of_Training_Hours__c;
                            te.Licensing_Transactions__c = licenseTransation.Id;
                            if(loggedUser.contactId != null){
                                te.Contact__c = loggedUser.contactId;
                            }
                            teList.add(te);
                        }
                        insert teList;
                    }
                    break;
                }
            }
            
        }
    }
    
    private void initializeController(){
        recordTypeMap.put('Apply for a New License','FCC_New_License');
        recordTypeMap.put('Apply for License Renewal','FCC_Renewal');
        recordTypeMap.put('Apply for an License Upgrade','FCC_License_Upgrade');
        recordTypeMap.put('Apply for a Change of Address','Change_of_Address');
        recordTypeMap.put('Notify Change of Room usage','FCC_Change_Room_Floor_Level');
        recordTypeMap.put('Notify Change in Household / Individuals Regularly on the Premises','FCC_Change_of_Household');
        recordTypeMap.put('Request Re-issuance of License Certificate','Re_issuance_of_License_Cert');
        recordTypeMap.put('Re-Activate License','FCC_Re_Active');
        recordTypeMap.put('De-Activate License','FCC_Inactivate');
        recordTypeMap.put('Close Prior Expiration','Close_Prior_Expiration');
        
        
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
    
    public void getLicenseTrans(String ltId) {
        System.debug('**********getLicenseTrans*******');
        selectedHestElems = new List<String>();
        List<Licensing_Transaction__c> ltList = [Select l.Working_With_Assistant__c, l.Work_Phone_Number__c, l.Which_Food_Program__c, l.Well_Water_Test_Evidence__c,l.Use_of_Alcoholic_Bev_Narcotics_Drugs__c, l.Use_Family_Child_Care_System__c,l.Took_FCC_Orientation__c,  RecordType.DeveloperName,RecordType.Name,
                                                        l.Use_Family_Child_Care_System_Descrip__c, l.Upgrading_Capacity_Training_Cert__c, l.Under_Review_Start_Date__c,l.USDA_Nutrition_Training_Evidence__c, l.Transportation_Training_Cert__c, l.Training_Review__c, l.New_Phone_Number_Unlisted__c,
                                                        l.Total_Payment_Received__c, l.Took_Upgrading_Capacity_Training__c, l.Took_USDA_Nutrition_Training__c, l.New_City__c,l.Took_Transportation_Training__c, l.Took_SIDS_Training__c, l.Took_Medication_Administration_Training__c, l.New_State__c, 
                                                        l.To_Process_Flag__c, l.Technical_Assistance__c, l.Tax_Certification_Status__c, l.Submission_Date__c, l.Name, l.Approved_Foster_Care_Provider_Descrip__c,l.Tax_Certification_Statement_Request_Date__c, l.Tax_Cert_Statement_Signed_Date__c, l.Submitter__c, l.Submitter_Email_Address__c, 
                                                        l.Stove_Meets_Requirements_Evidence__c, l.Status__c, l.Source__c, l.Sex_Offender_Nature_of_Incident__c, l.SIDS_Training_Cert__c,l.Revocation_Suspension_Surrender_Reas__c, l.Restraining_Order_Issued__c, l.Restraining_Order_Description__c, l.Registering_as_Sex_Offender__c, 
                                                        l.RecordTypeId,l.Alcoholic_Bev_Narcotics_Drugs_Desc__c,  l.Reason_for_Request__c, l.Reason_Closed_Cancelled__c, l.Ready_for_Closing__c, l.Provider__c, l.Previous_Involvement_with_EEC_for_Unlice__c,l.Previous_Application_Certif_with_EEC__c, l.Prev_App_Certif_with_EEC_Descrip__c, l.Prev_App_Certif_with_Another_State__c, 
                                                        l.Prev_App_Certif_with_Another_State_Desc__c, l.Outdoor_Space_Changes_Description__c, l.Outdoor_Space_Changed__c,l.Other_Person_BRC_Consent_Completed__c, l.Other_Info_Reviewed__c, l.Other_Condition__c, l.Observations_Comments__c, l.No_Condition_Flag__c, 
                                                        l.New_Zip_Code__c, l.New_Street_Address_2__c, l.New_Street_Address_1__c, l.New_Address_Phone_Number__c, l.Need_Assist_to_Barricade_Heating_Units__c,l.Moving_Date__c, l.Missing_Elements_For_Closing__c, l.Medication_Administration_Training_Cert__c, 
                                                        l.Live_at_New_Address__c, l.Licensee_BRC_Consent_Status__c, l.Licensee_BRC_Consent_Signed_Date__c, l.Licensee_BRC_Consent_Request_Date__c,Submitter__r.FirstName,Submitter__r.LastName,Assigned_To__r.FirstName,Assigned_To__r.LastName,Assigned_To__r.Phone,Assigned_To__r.Email,
                                                        l.License_Type__c, l.License_Requested__c, l.License_Issue_Date__c, l.License_Expiration_Date__c, l.Last_Reached_Step__c, l.Indoor_Outdoor_Space_Review__c, l.Id, l.Heating_Elements__c, l.Floors_Description__c, l.First_Aid_Certified__c, l.First_Aid_Certification_Issue_Date__c, 
                                                        l.First_Aid_Certificate__c, l.Fee_Paid__c, l.FCC_Residence_Description__c, l.FCC_Orientation_Module_II_Evidence__c, FCC_Orientation_Module_I_Evidence__c, l.Experience_Caring_for_Children_QUalifica__c, 
                                                        l.Exits_Descriptions__c, l.Evening_Overnight_Weekend_Care__c, l.Drinking_Water_Source__c, l.Document_Information_Missing__c,l.Document_Info_Missing_Initial_Date__c, l.Dealings_with_Child_Prot_Child_Welfar__c, l.Dealing_with_Child_Prot_Welfar_Descri__c, 
                                                        l.Date_Upgrading_Capacity_Training_Taken__c, l.Date_USDA_Nutrition_Training_Taken__c, l.Date_Transportation_Training_Taken__c, l.Date_Med_Administration_Training_Taken__c, 
                                                        l.Date_Last_SIDS_Training_Taken__c, l.Date_FCC_Orientation_Taken__c, l.Date_Closed__c, l.Date_Care_Resumes__c, l.Date_Activity_Ends__c,l.Daily_Routine_and_Activities__c, l.Condition_Added__c, l.Children_Home_Schooled__c, l.Children_Home_Schooled_Description__c, l.Child_Emergency_Injury_Last_3_Years__c,
                                                        l.Child_Emerg_Injury_Last_3_Years_Descrip__c, l.Charges_Description__c, l.Charged_or_Arrested_for_Crime__c, l.Certificate_or_License_Surrendered__c,l.Certificate_of_License_Revoked_Suspend__c, l.Caring_For_Children_Not_Related__c, l.Capacity__c, l.CPR_Certified__c, l.CPR_Certification_Issue_Date__c, 
                                                        l.CPR_Certificate__c, l.Business_Operated_Out_of_Own_Home__c, l.Bus_Operated_Out_of_Own_Home_Descrip__c, l.Belong_to_Food_Program__c, l.Becoming_Foster_Care_Provider__c,l.Becoming_Foster_Care_Provider_Descrip__c, l.At_Least_2_Exits__c, l.Associated_Fee__c, l.Assigned_To__c, l.Approved_by_Manager__c, l.Approved_Foster_Care_Provider__c,
                                                        l.Date_FCC_Orientation_Mod_1_Taken__c, l.Took_FCC_Orientation_Module_1__c, l.Abused_or_neglected_a_child__c, l.Abused_or_neglected_a_child_Description__c
                                                        From Licensing_Transaction__c l where Id = :ltId];
        
        if(ltList != null && ltList.size() > 0){
            System.debug('********IN********');
            licenseTransation = ltList.get(0);
            licenseRecordTypeName = licenseTransation.RecordType.DeveloperName;
            licenseRecordTypeLabel = licenseTransation.RecordType.Name;
            formattedLicenseRecordTypeLabel = licenseRecordTypeName.replaceAll('_',' ');
            System.debug('----> LicenseRecordTypeName: ' + licenseRecordTypeName);
            System.debug('----> licenseRecordTypeLabel: ' + licenseRecordTypeLabel);
            //LicenseRecordTypeName = recordTypeMap.get(licenseRecordTypeLabel);
            licenseInstructionMessage = (String)leadConfiguration.get(LicenseRecordTypeName+'_Instruction__c');
            provider = [select Id,Recordtype.DeveloperName, RecordType.Name,License_Status__c,First_Issue_Date__c,Renewal_date__c,Provider_Status__c,
                           Accept_Referral__c,Can_Communicate_in_English__c,PPM_Meeting_Attended_Date__c,capacity__c,
                           ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode, Phone, Unlisted_Phone_Number__c, Alternate_Phone__c, Fax, Provider_Email__c,
                           Provider_Address_1__c,Provider_Address_2__c,Provider_City__c, Provider_City__r.Name, Provider_Zip_Code__c,Live_at_this_address__c,Language__c,Preferred_Language__c
                        from Account where Id = :licenseTransation.Provider__c];
            System.debug('********licenseRecordTypeName******** '+licenseRecordTypeName);                                       
            ihmList = [Select Id, Provider__c, Licensing_Transactions__c, Current__c, First_Name__c, Last_Name__c, Date_of_Birth__c, Relationship_to_Provider__c, Occupation__c, Number_of_Hours_Home_During_Child_Care__c, Current_School_Grade__c, Email_Address__c From Household_Member__c where Licensing_Transactions__c = :licenseTransation.Id];
            ihmListJson = JSON.serialize(ihmList); 
            faList = [Select Id, Name, First_Name__c, Last_Name__c, Mailing_Address__c, License_Number__c, License_Expiration_Date__c, Source_Transaction__c, Provider__c, Current__c From FCC_Assistant__c where Source_Transaction__c = :licenseTransation.Id];
            ehList = [Select Name, Contact__c, Licensing_Transaction__c, Position__c, Start_Date__c, End_Date__c, Reason_for_Leaving__c, Employer__c, Employer_Address__c, Employer_Phone__c From Employment_History__c where Licensing_Transaction__c = :licenseTransation.Id];
            roomList = [Select Id, Name, Source_Transaction__c, Current__c, Use__c, Dimension_Length_feet__c, Dimension_Width_feet__c, Dimension_Square_Feet__c, Floor_Level__c, Provider_Name__c From Room__c where Source_Transaction__c = :licenseTransation.Id];
            teList = [Select Id, Name, Contact__c, Licensing_Transactions__c, Topic__c, Date_of_the_Training__c, Number_of_Training_Hours__c From Training_Experience__c where Licensing_Transactions__c = :licenseTransation.Id];
            initHH = true;
            initLS = true;
            initIndoor = true;
            initTraining = true;
            if(String.isNotEmpty(licenseTransation.Heating_Elements__c)){
                selectedHestElems = licenseTransation.Heating_Elements__c.split(';');
            }
        }   
    }
    
    /**
     * UpdateMembersList
     * 
     * This function will process two JSON strings and put them into the overall Household_Member List.
     * @author Darkis
     * @param MembersJson String The json containing all the members currently or newly added to the table.
     * @param MembersToDeleteJson String The json containing all the members that are to be deleted from the transaction.
     */
    public void UpdateMembersList() {
      try {
        List<Household_Member_Json_Wrapper> memberWrapperList;
        List<Household_Member__c> memberList = new List<Household_Member__c>(); 
          
        if (!String.isBlank(MembersJson)) {
          memberWrapperList = (List<Household_Member_Json_Wrapper>) JSON.deserialize(MembersJson, List<Household_Member_Json_Wrapper>.class);
           
          
          for (Household_Member_Json_Wrapper memberWrapper : memberWrapperList) {
            memberList.add(memberWrapper.convertToHouseholdMember());      
          }
          ihmList = memberList;
          ihmListJson = JSON.serialize(ihmList); 
        }
          
        if (!String.isBlank(MembersToDeleteJson)) {
          memberWrapperList = (List<Household_Member_Json_Wrapper>) JSON.deserialize(MembersToDeleteJson, List<Household_Member_Json_Wrapper>.class);
          memberList = new List<Household_Member__c>();  
          
          for (Household_Member_Json_Wrapper mw : memberWrapperList) {
            memberList.add(mw.convertToHouseholdMember());      
          }
          removeHMList = memberList;
        }  
      } catch (Exception e) {
        System.debug('-----> Error: ' + e.getMessage());
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
        ApexPages.addMessage(errMsg);
      }
    }    
    
    /**
     * Household_Member_Json_Wrapper
     * 
     * This wrapper class is used to process Household Member Json strings into usable Household_Member__c objects.
     * @author Darkis
     */
    public class Household_Member_Json_Wrapper {
      // Variables here
      public String Id {get;set;}
      public String First_Name {get;set;} 
      public String Last_Name {get;set;}
      public String Date_of_Birth {get;set;}
      public String Relationship_to_Provider {get;set;}
      public String Occupation {get;set;}
      public String Number_of_Hours_Home_During_Child_Care {get;set;}
      public String Current_School_Grade {get;set;}
      public String Email_Address {get;set;}
         
      /**
       * convertToHouseholdMember
       * 
       * This function will take the processed Json and convert it into a usable Household_Member__c object for saving.
       * @author Darkis
       */
      public Household_Member__c convertToHouseholdMember() {
        Household_Member__c member = new Household_Member__c(
          First_Name__c = this.First_Name,
          Last_Name__c = this.Last_Name,
          Date_of_Birth__c = Date.valueOf(this.Date_of_Birth),
          Relationship_to_Provider__c = this.Relationship_to_Provider,
          Occupation__c = this.Occupation,
          Number_of_Hours_Home_During_Child_Care__c = Decimal.valueOf(this.Number_of_Hours_Home_During_Child_Care),
          Current_School_Grade__c = this.Current_School_Grade,
          Email_Address__c = this.Email_Address
        );
        // If the ID is not null/empty/blank then set it for updating.  
        if (String.isNotBlank(this.Id)) {
          member.Id = this.Id;      
        }
        return member; 
      }
    }
    
    /**
     * processAttachmentJson
     * 
     * This function will accept a json parameter of files decriptions to save to the transaction object.
     * @author Darkis
     */
    public void processAttachmentJson(String jsonStr) {
      try {
        // List of S3Objects. 
        if (!String.isBlank(jsonStr)) {
          // Convert the json into S3_Files.
          List<S3_File__c> s3FilesList = (List<S3_File__c>) JSON.deserialize(jsonStr, List<S3_File__c>.class); 
          upsert s3FilesList;
          // Get all the current FileMap records for the object and ensure we don't create any duplicates.  
          Set<Id> fileMappingIds = (new Map<Id, FileMap__c>([Select S3_File__c From FileMap__c Where Object_Id__c = :licenseTransation.Id])).keySet();
          List<FileMap__c> filesToMap = new List<FileMap__c>();
          // Loop through all the files in the list and verify any that are new to be added. 
          for (S3_File__c file : s3FilesList) {
            if (!fileMappingIds.contains(file.Id)) {
              filesToMap.add(new FileMap__c(
                Object_Name__c = String.valueOf(licenseTransation.getSObjectType()),
                Object_Id__c = licenseTransation.Id,
                S3_File__c = file.Id
              ));      
            }
          }System.debug('----> Json String: ' + jsonStr);
          // Insert the new files that need to be mapped.   
          insert filesToMap;           
        }
      } catch (Exception e) {
        System.debug('-----> Error: ' + e.getMessage());
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
        ApexPages.addMessage(errMsg);
      }  
    }
    
    /**
     * saveAttachmentsFromJson
     * 
     * This function will send both the indoor json and full attachment json string to be processed.
     * @author Darkis
     */
    public void saveAttachmentsFromJson() {
      try {
        // List of S3Objects. 
        if (!String.isBlank(indoorAttachmentsJson)) {
          processAttachmentJson(indoorAttachmentsJson);           
        }
      } catch (Exception e) {
        System.debug('-----> Error: ' + e.getMessage());
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
        ApexPages.addMessage(errMsg);
      }  
    }
    
    public void saveAllAttachmentsFromJson() {
      try {
        if (!String.isBlank(attachmentsJson)) {
          processAttachmentJson(attachmentsJson);    
        }
      } catch (Exception e) {
        System.debug('-----> Error: ' + e.getMessage());
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
        ApexPages.addMessage(errMsg);
      }  
    }
    
    public void saveTrainingAttachmentsFromJson() {
      try {
        if (!String.isBlank(trainingAttachmentsJson)) {
          processAttachmentJson(trainingAttachmentsJson);    
        }
      } catch (Exception e) {
        System.debug('-----> Error: ' + e.getMessage());
        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - '+e.getMessage());
        ApexPages.addMessage(errMsg);
      }  
    }
    
    /**
     * renderExisitingElements 
     * 
     * These functions will verify that certain files have been mapped correctly.
     * @author Darkis
     */
    public Boolean getRenderExistingHeatingAttachment() {
      return transactionAttachmentsMap.containsKey('evidence_stove_meets_requirements');  
    }
    
    public Boolean getRenderExistingWaterAttachment() {
      return transactionAttachmentsMap.containsKey('evidence_of_well_water_test');  
    }
    
    public Boolean getRenderExistingMedicationAttachment() {
      return transactionAttachmentsMap.containsKey('med_administration_training_evidence');  
    }
    
    public Boolean getRenderExistingTransportationAttachment() {
      return transactionAttachmentsMap.containsKey('transportation_training_evidence');  
    }
    
    public Boolean getRenderExistingSidsAttachment() {
      return transactionAttachmentsMap.containsKey('sids_training_evidence');  
    }
    
    public Boolean getRenderExistingUsdaAttachment() {
      return transactionAttachmentsMap.containsKey('usda_nutrition_training_evidence');  
    }
    
    public Boolean getRenderExistingUpgradeAttachment() {
      return transactionAttachmentsMap.containsKey('upgrade_capacity_training_evidence');  
    }
    
    public Boolean getRenderExistingOrientationAttachment() {
      return transactionAttachmentsMap.containsKey('fcc_orientation_mod_II_training_evidence');  
    }
    
    public Boolean getRenderExistingCprAttachment() {
      return transactionAttachmentsMap.containsKey('cpr_certification_evidence');  
    }
    
    public Boolean getRenderExistingFirstAidAttachment() {
      return transactionAttachmentsMap.containsKey('first_aid_certification_evidence');  
    }
    
    public Boolean getRenderExistingOrientationModuleAttachment() {
      return transactionAttachmentsMap.containsKey('fcc_orientation_module_1_evidence');    
    }
    
    /**
     * deleteAttachment
     * 
     * This function will delete the FileMap__c and S3_File__c record for a specified file along with trigger an async function to delete the file from S3.
     * @author Darkis
     * @param String fileToDelete The name of the file to delete from the UI.
     */
    public PageReference deleteAttachment() { 
      // Delete the FileMap and S3_File Records.
      FileMap__c fileMap = [Select Id, S3_File__r.Filename__c From FileMap__c Where Object_Id__c = :licenseTransation.Id AND S3_File__r.Filename__c = :fileToDelete LIMIT 1];
      delete fileMap;
      // Delete the S3_File reference in Sforce.
      S3_File__c file = [Select Id From S3_File__c Where Id = :fileMap.S3_File__c LIMIT 1];
      delete file;  
      // Invoke the future method to delete the object in S3 using the SOAP API.
      if (!Test.isRunningTest()) {
        deleteS3FileReference(bucketName, licenseTransation.Id + '/' + fileToDelete);
      }
      // Check for the transaction certification field name. If it exists then uncheck the field 
      if (!String.isBlank(transCertCheckboxFieldname)) {
        licenseTransation.put(transCertCheckboxFieldname, false);
      }  
       
      // Re-map the mappings to remove the attachment.
      generateAttachmentMappings();
      refreshAttachmentsList();
      retrieveAddtionalTrainingAttachmentsList();
      return null;
    }
    
    /**
     * @future
     * deleteS3FileReference
     * 
     * This future function will do a SOAP callout to S3 to delete the file reference provided. 
     * @author Darkis
     * @param String bucketName The name of the bucket the file resides in.
     * @param String filename The name of the file along with any prefixs necessary.
     */
    @future(callout=true)
    public static void deleteS3FileReference(String bucketName, String filename) {
      // Delete the file from S3 using the SOAP API.  
      EEC_S3ComponentCtrl.deleteFile(bucketName, filename);
    }
    
    /**
     * generateMultiplePolicySignature
     * 
     * This function will call the S3ComponentCtrl to generate multiple or single policy and signature combos for specified files to upload to S3.
     * @author Darkis
     * @param String bucket The name of the bucket to save to.
     * @param String acl The permission level of the file. Typically this would be 'authenticated-read' for our purposes. 
     * @param String fileJson A JSON string of all the files to be uploaded from the Angular Controller.
     */
    @RemoteAction
    public static List<Map<String,String>> generateMultiplePolicySignature(String bucket, String acl, String fileJson) {
      List<Map<String,String>> returnJson = new List<Map<String,String>>();  
      List<EEC_S3ComponentCtrl.FileTypeJsonWrapper> fileTypeWrapperList = (List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>) JSON.deserialize(fileJson, List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>.class);  
      // Loop through the files given and get all the necessary policy/sig combos.
      for (EEC_S3ComponentCtrl.FileTypeJsonWrapper wrapper : fileTypeWrapperList) {
        returnJson.add(EEC_S3ComponentCtrl.generatePolicySignature(bucket, acl, wrapper.filename, wrapper.type, null)); 
      }    
      return returnJson;
    }  
    
    /**
     * getRoomTableVisibility
     * 
     * This function will check the room list size and inform the UI of the result.
     * @author Darkis
     */
    public Boolean getRoomTableVisibility() {
      return roomList.size() == 0 ? false : true;  
    }
    
    /**
     * getHeatingEvidenceRequired
     * 
     * This function will verify the existance of the heating evidence requirement for file uploads.
     * @author Darkis
     */
    public Boolean getHeatingEvidenceRequired() {
      if (selectedHestStr != null) {
        return selectedHestStr.contains('Coal / Pellet / Wood Burning Stove');
      }
      return false;
    }
    
    /**
     * getHeatingIsBarricaded
     * 
     * This function will determine if the heating parameters require a 2nd question.
     * @author Darkis
     */
    public Boolean getHeatingIsBarricaded() {
      showCBDesc();
        
        if (String.isBlank(selectedHestStr)) {
          return false;  
        }
      
      if (selectedHestStr != null && ((selectedHestStr =='Baseboards,') || (selectedHestStr == 'Vents / Grates,') || (selectedHestStr == 'Baseboards,Vents / Grates,'))) {
        return false;  
      }
      return true;
    }
    
    /**
     * getWaterIsPrivate
     * 
     * This function will determine if the water selection is private or Town. If the value has not been initialized it will be here.
     * @author Darkis
     */
    public Boolean getWaterIsPrivate() {
      if (String.isBlank(selectedWaterStr) && licenseTransation.Drinking_Water_Source__c != null) {
        selectedWaterStr = licenseTransation.Drinking_Water_Source__c;  
      }
      if (String.isBlank(selectedWaterStr)) {
        licenseTransation.Well_Water_Test_Evidence__c = false;
        return false;
      } 
      if (selectedWaterStr != null && !selectedWaterStr.equalsIgnoreCase('private water supply')) {
        licenseTransation.Well_Water_Test_Evidence__c = true;
        return true;  
      }
      licenseTransation.Well_Water_Test_Evidence__c = false;
      return false;
    }
    
    /**
     * Change the lookup for city into select option
     * @author Bemnet
     * 
     */ 
     
    public SelectOption[] getCityOptions() {  
        SelectOption[] cities = new SelectOption[]{};  
        cities.add(new SelectOption('','--None--'));  
        for (City__c c : [select id, Name from City__c where isdeleted = false order by Name]) {  
            cities.add(new SelectOption(c.id, c.name + ' (' + c.Name + ')'));  
        }  
        return cities;  
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
      System.debug('----> File Mappings: ' + fileMappings);
      if (fileMappings.size() > 0) {
        Set<Id> fileIds = new Set<Id>();
          
        for (FileMap__c filemap : fileMappings) {
          fileIds.add(filemap.S3_File__r.Id);
        }
        attachments = [Select Id, Filename__c, Content_Type__c, Description__c, CreatedDate From S3_File__c Where Id IN :fileIds];
        attachmentsJson = JSON.serialize(attachments);
        System.debug('----> All Files: ' + attachments);
        return attachments;
      } else {
        attachmentsJson = '';
      }          
      return new List<S3_File__c>();
    }
    
    public List<S3_File__c> retrieveAddtionalTrainingAttachmentsList() {
      additionalTrainingAttachments = new List<S3_File__c>();
      
      List<FileMap__c> fileMappings = [Select Id, S3_File__r.Id From FileMap__c Where S3_File__r.Filename__c Like 'additional_training_%'];
      
      if (fileMappings.size() > 0) {
        Set<Id> fileIds = new Set<Id>();
        
        for (FileMap__c filemap : fileMappings) {
          fileIds.add(fileMap.S3_File__r.Id);
        }
          
        additionalTrainingAttachments = [Select Id, Filename__c, CreatedDate From S3_File__c Where Id IN :fileIds];
        attachmentsJson = JSON.serialize(additionalTrainingAttachments);
        return additionalTrainingAttachments;
      } else {
        attachmentsJson = '';
      }
      return new List<S3_File__c>();
    }
    
    /**
     * getAttachmentSpotlightText
     * 
     * This function will determine the type of license record and provide the correct description text needed for attachments.
     * @author Darkis
     */
    public String getAttachmentSpotlightText() {
      String text = '';
        
      if (LicenseRecordTypeName.equalsIgnoreCase('FCC_New_License')) {
        text = leadConfiguration.Transaction_Attachments_New__c;    
      } else if (LicenseRecordTypeName.equalsIgnoreCase('FCC_Renewal')) {
        text = leadConfiguration.Transaction_Attachments_Renewal__c; 
      } else if (LicenseRecordTypeName.equalsIgnoreCase('FCC_License_Upgrade')) {
        text = leadConfiguration.Transaction_Attachments_Upgrade__c;  
      }
      return text;
    }
    
    /**
     * saveFileDescription
     * 
     * This function will save the new description for a specified file. 
     * @author Darkis
     * @param String fileToEditId The id of the file.
     * @param String fileToEditDescription The new file description entered by the client.
     */
    public void saveFileDescription() {
      if (!String.isBlank(fileToEditId)) {
        S3_File__c file = [Select Id, Description__c From S3_File__c Where Id = :fileToEditId];
        file.Description__c = fileToEditDescription;
        update file;
      }  
    }
 }