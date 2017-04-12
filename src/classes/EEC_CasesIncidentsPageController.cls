public with sharing class EEC_CasesIncidentsPageController {

  public Case c { get; set; }
  public Account a { get; private set; }
  public Contact ct { get; set; }
  public User licensor { get; set; }
  private List<Attachment> attachmentsToInsert {get;set;}

  public Boolean blnCalled911 { get { if (c.X911_Called__c != NULL && c.X911_Called__c == 'Yes') { return true; } else { return false; } } }
  public Boolean blnFirstAidCPR { get { if (c.First_Aid_or_CPR_Provided__c != NULL && c.First_Aid_or_CPR_Provided__c == 'Yes') { return true; } else { return false; } } }
  public Boolean blnCPR { get { if (c.CPR_Provided__c != NULL && c.CPR_Provided__c == 'Yes') { return true; } else { return false; } } }
  public Boolean blnChildTransport { get { if (c.Child_Transported_for_Medical_Attention__c != NULL && c.Child_Transported_for_Medical_Attention__c == 'Yes') { return true; } else { return false; } } }
  public Boolean blnChildReturned { get { if (c.Child_return_to_Program__c != NULL && c.Child_return_to_Program__c == 'Yes') { return true; } else { return false; } } }
  public Boolean blnSharedParents { get { if (c.Shared_with_Parents__c != NULL && c.Shared_with_Parents__c == 'Yes') { return true; } else { return false; } } }
  public Boolean blnOtherParents { get { if (c.Other_Person_Notified__c  != NULL && c.Other_Person_Notified__c  == 'Yes') { return true; } else { return false; } } }
  public Boolean blnFiledDCF { get { if (c.Filed_with_DCF__c != NULL && c.Filed_with_DCF__c == 'Yes') { return true; } else { return false; } } }
  public Boolean blnFiledDPPC { get { if (c.Filed_with_DPPC__c != NULL && c.Filed_with_DPPC__c == 'Yes') { return true; } else { return false; } } }
  public Boolean blnLegal { get { if (c.Incident_involves_legal_proceedings__c != NULL && c.Incident_involves_legal_proceedings__c == 'Yes') { return true; } else { return false; } } }

  private Integer thisStage;
  public List<Boolean> currentStage { get; private set; }
  //public List<Involved_Persons__c> InvolvedPersons;
  public List<Portal_Util.InvolvedPerson_Wrapper> InvolvedPersons;
  public List<Portal_Util.InvolvedPerson_Wrapper> deleteInvolvedPersons;
  public List<Involved_Persons__c> personsList;
  public List<Attachment> CaseAttachments { get; private set; }
  public LEAD_Configuration__c config { get;set; }
  public String introText { get;set; }
  public String incidentIntroText { get;set; }  
  public String injuryIntroText { get;set; }    

  public String FileName { get; set; }
  private List<String> lstRecordTypes;
  private List<Involved_Persons__c> lstPersonRoles;
  private Map<String, Id> RecordTypeIds; // To convert into ID values before saving 
  private Map<Id, String> RecordTypeNames; // To convert into ID values before saving 
  public List<S3_File__c> attachments { get; set; }

  public String saveButtonType { get; set; }
  public Boolean editViewMode { get; set; }
  public Boolean editMode { get; set; }
  public String caseType { get; set; }
  public String caseTypeLabel { get; set; }
  public Boolean accountTypeBool{get;set;}

  public String attachmentsJson { get; set; }
  public String fileToDelete { get; set; }
  public String bucketName { get; set; }
  public String bucketItemAccess { get; set; }
  public String accessKey { get; set; }

  private AWSKeys credentials { get; set; }
  private String AWSCredentialName = 'eec';
    
  public String memberId{ get; set; } 

  // Constructor
  public EEC_CasesIncidentsPageController() {
    memberId = ApexPages.currentPage().getParameters().get('member'); 
    //memberId = EEC_Util.encryptGetParam(memberId);  
    credentials = new AWSKeys(AWSCredentialName);
    accessKey = credentials.key;
    bucketName = 'eec-lead';
    bucketItemAccess = 'authenticated-read';
    
    
    c = new Case();
    a = new Account();
    ct = new Contact();
    licensor = new User();
    editMode = false;

    FileName = '';

    CaseAttachments = new List<Attachment> ();

    Id UserId = UserInfo.getUserId();
    InvolvedPersons = new List<Portal_Util.InvolvedPerson_Wrapper> ();
    deleteInvolvedPersons = new List<Portal_Util.InvolvedPerson_Wrapper> (); // to hold persons that were deleted
    Portal_Util.InvolvedPerson_Wrapper p = new Portal_Util.InvolvedPerson_Wrapper();

    // Fetch list of RecordTypes for Involved Persons
    lstRecordTypes = new List<String> ();
    RecordTypeIds = new Map<String, Id> ();
    RecordTypeNames = new Map<Id, String> ();
    for (RecordType rt :[SELECT Id, Name FROM RecordType WHERE sObjectType = 'Involved_Persons__c' ORDER BY Name ASC]) {
      lstRecordTypes.add(rt.Name);
      RecordTypeIds.put(rt.Name, rt.Id);
      RecordTypeNames.put(rt.Id, rt.Name);
    }

    // Load existing Case details
    if (ApexPages.currentPage().getParameters().get('id') != NULL) {
      Id LoadCaseId = ApexPages.currentPage().getParameters().get('id');
      c = retrieveBaseCase(LoadCaseId);
      a = [SELECT Id, Name, Recordtype.Name, OwnerId, Licensor_Full_Name__c, Licensor_Phone__c, Phone, Region_Phone__c, Is_R_P__c, Is_GSA__c FROM Account WHERE Id = :c.AccountId LIMIT 1];
      //Mod by LD - fix for BMMS-148
      if(c.ContactId != null){
          ct = [SELECT Id, Name, Phone, Email FROM Contact WHERE Id = :c.ContactId LIMIT 1];
      }
      InvolvedPersons = Portal_Util.fetchInvolvedPersons(c.Id, RecordTypeNames);
      CaseAttachments = [SELECT Id, Name, CreatedDate FROM Attachment WHERE ParentId = :c.Id];
      
      caseType = c.RecordType.Name;
      caseTypeLabel = c.RecordType.Name;
      if(a.RecordType.Name=='Foster_Care_Agency'){
        accountTypeBool = false;  
      }else{
        accountTypeBool = true;
        system.debug('value in the first loop :'+accountTypeBool);
      }
      
      
      if (!caseType.equalsIgnoreCase('Incident')) {
        caseTypeLabel = 'Injury';      
      }
    } else {
        System.debug('memberId--->' + memberId);
        if(memberId != null){
            a = Portal_Util.fetchAccountByAccID(memberId);
            ct = Portal_Util.fetchContactByAccID(memberId);
        }
         else { 
            System.debug('memberId--->' + UserId);
            System.debug('memberId--->' + Portal_Util.fetchContact(UserId)); 
            a = Portal_Util.fetchAccount(UserId);  
            ct = Portal_Util.fetchContact(UserId);
         }
         system.debug('value of account recordtype'+a.RecordType.Name);
         system.debug('value of case recordtype'+c.RecordType.Name);
         if(a.RecordType.Name=='Foster Care Agency'){
            accountTypeBool = false;  
          }else{
            accountTypeBool = true;
            system.debug('value in the second loop :'+accountTypeBool);
          }
    }
       
    LEAD_Configuration__c[] config = [SELECT Id, Incidents_Intro__c, Injury_Involved_Person_Intro__c, Incident_Involved_Person_Intro__c 
                                      FROM LEAD_Configuration__c WHERE Name = :a.Recordtype.Name];  
    if(config.size() > 0){
        introText = config[0].Incidents_Intro__c;
        introText = introText.replace('#Provider.Licensor.First Name#', a.Licensor_Full_Name__c != null ? a.Licensor_Full_Name__c : '');
        introText = introText.replace('#Provider.Licensor.Last Name#', '');
        introText = introText.replace('#Provider.Licensor.Phone Number#', a.Licensor_Phone__c != null ? (' - ' + a.Licensor_Phone__c) : '');  
        introText = introText.replace('#Provider.Region.Phone#', a.Region_Phone__c != null ? a.Region_Phone__c : ''); 
        
        incidentIntroText = config[0].Incident_Involved_Person_Intro__c;
        injuryIntroText = config[0].Injury_Involved_Person_Intro__c;
    }    

    currentStage = new Boolean[] { false, false, false, false };

    // Check for the mode flag. If we have edit then send the users to the summary page with the option to edit.  
    String mode = ApexPages.currentPage().getParameters().get('mode');
    editViewMode = mode != null && mode.equalsIgnoreCase('edit') ? true : false;
    // Get the current stage from the get params.    
    String stageQS = ApexPages.currentPage().getParameters().get('stage');
    // If it's currently null then set it to 0. 
    if (stageQS == NULL) {
      stageQS = '0';
    }
    // If in Edit mode then we need to start on the summary page. 
    if (editViewMode) {
      stageQS = '3';
    }
    // Get the current stage value and set the page accordingly.
    thisStage = Integer.valueOf(stageQS);
    stageChange(thisStage);
      
    if (String.isBlank(caseTypeLabel)) {
      caseTypeLabel = 'Incident/Injury';
    }
  }

  /**
   * editIncident
   * 
   * This function will set the page into edit mode. Essentially it just changes the cancel button to back and allows
   *   the user to continue editing as normal. 
   * @author Darkis
   */
  public PageReference editIncident() {
    editViewMode = false;
    editMode = true;
    // Set the view mode to no longer be edit. 
    thisStage = 0;
    stageChange(thisStage);
    return null;
  }

  /**
   * viewIncident
   * 
   * This function will allow the user to view their case using the final summary page. It also replaces the buttons with a cancel and edit.
   * @author Darkis
   */
  public PageReference viewIncident() {
    editViewMode = true;
    editMode = false;
    // Go to the summary stage. 
    thisStage = 3;
    stageChange(thisStage);
    return null;
  }

  /**
   * addPerson
   * 
   * This function will add a new person to the Involved Person wrapper and to the page.
   * @author Chris
   */
  public PageReference addPerson() {
    Portal_Util.InvolvedPerson_Wrapper p = new Portal_Util.InvolvedPerson_Wrapper();
    p.Type = 'Child Involvement'; // Default value
    //p.Age = null;
    InvolvedPersons.add(p);
    System.debug('-----> Involved People: ' + InvolvedPersons);
    return NULL;
  }

  /**
   * delPerson
   * 
   * This function will remove an Involved Person from the wrapper.
   * @author Chris
   */
  public PageReference delPerson() {
    String passedVal = Apexpages.currentPage().getParameters().get('index');
    System.debug('----> Index: ' + passedVal);
    Integer i = Integer.valueOf(passedVal);
    System.debug('----> i: ' + i);
    Portal_Util.InvolvedPerson_Wrapper p = InvolvedPersons.remove(i);
    System.debug('----> PortalUtil.InvolvedPerson_Wrapper: ' + p);
    System.debug('----> InvolvedPersons: ' + InvolvedPersons);
    if (p.PersonId != NULL) { deleteInvolvedPersons.add(p); }
    System.debug('----> deleteInvolvedPersons: ' + deleteInvolvedPersons);
    return NULL;
  }

  /**
   * getPersonTypes
   * 
   * This function will get all the person types available and put them into a select option list.
   * @author Darkis
   */
  public List<SelectOption> getPersonTypes() {
    List<SelectOption> output = new List<SelectOption> ();
    for (String s : lstRecordTypes) { output.add(new SelectOption(s, s)); }
    return output;
  }

  /**
   * getPersonRoles
   * 
   * This function will get all the roles from the Involved_Persons__c object and add it to the select box.
   * @author Darkis
   */
  public List<SelectOption> getPersonRoles() {
    return Portal_Util.getPicklistValues(new Involved_Persons__c(), 'Role__c');
  }

  /**
   * save
   * 
   * This function will save the new case and send the user to a new location 
   *   depending on the button type clicked.
   * @author Darkis
   */
  public PageReference save() {
    System.debug('-----> [Save] saveButtonType: ' + saveButtonType);
    // If the save button type has been returned to the function.
    if (String.isNotBlank(saveButtonType)) {
      // Save the case.
      if (saveCase()) {
        if (saveButtonType.equalsIgnoreCase('previous')) {
          return prevStage();
        } else if (saveButtonType.equalsIgnoreCase('next')) {
          return nextStage();
        } else if (saveButtonType.equalsIgnoreCase('return')) {
          return returnProvider();
        }
      }
    }
    return null;
  }

  /**
   * submitReturn
   * 
   * This function will submit the case setting it to new and return the user to the provider page.
   * @author Chris
   */
  public PageReference submitReturn() {
    submitCase();
    createAndInsertAttachment(c);
    return returnProvider();
  }
  
  private void createAndInsertAttachment(Case refObj) {
        PageReference pagePdf = new PageReference('/apex/EEC_CaseSubmitPDF');
        pagePdf.getParameters().put('id', refObj.Id);
        Blob pdfPageBlob;
        pdfPageBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pagePdf.getContentAsPDF();
             
        Attachment a = new Attachment();
        a.Body = pdfPageBlob;
        a.ParentID = refObj.Id;
        a.Name = 'CaseSubmitted.pdf';
        a.Description = 'Case Submitted';
        //insert a;
        insert a;
        system.debug('MMMMMMM'+a);
    }

  /**
   * deleteReturn
   * 
   * This function will delete the current case and return the user to the provider page.
   * @author Chris
   */
  public PageReference deleteReturn() {
    deleteCase();
    return returnProvider();
  }

  /**
   * prevStage
   * 
   * This function will send the user back one page stage.
   * @author Chris
   * @modified Darkis 19 Jun 2015
   */
  public PageReference prevStage() {
    if (thisStage == 2) {
      stageChange(thisStage - 1);
      //return URLwithFile(); 
      return null;
    } else {
      stageChange(thisStage - 1);
      return NULL;
    }
  }

  /**
   * nextStage
   * 
   * This function will send the user to the next page stage.
   * @author Chris
   * @modified Darkis 19 Jun 2015
   */
  public PageReference nextStage() {
    System.debug('-----> [Next Stage]: ' + thisStage);
    System.debug('-----> CaseType: ' + caseType);
    if (thisStage == 2) {
      stageChange(thisStage + 1);
      // Currently disabled until attachments are implemented.
      //return URLwithFile(); 
      return null;
    } else {
      stageChange(thisStage + 1);
      return NULL;
    }
  }

  /**
   * returnProvider
   * 
   * Send the user back to the provider page.
   * @author Chris
   */
  public PageReference returnProvider() {
    PageReference pPage = page.EEC_PortalProviderPage;
    if(memberId != null)  
       pPage.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
    return pPage;
  }

  /**
   * stageChange
   * 
   * This function will change the current stage of the page. 
   * @author Chris
   */
  private void stageChange(Integer newStage) {
    // Refresh the attachments list.
    refreshIncidentAttachments();

    Integer counter;
    for (counter = 0; counter < currentStage.size(); counter++) {
      if (counter == newStage) {
        currentStage[counter] = true;
      } else {
        currentStage[counter] = false;
      }
    } // end for loop
    thisStage = newStage;
  } // end void stageChange

  /**
   * saveCase
   * 
   * This function will save the case and all it's related objects. 
   * @author Chris
   * @modified Darkis 19 Jun 2015
   */
  private boolean saveCase() {
    try {
      System.debug('-----> [SaveCase] Case: ' + c);
      System.debug('-----> [SaveCase] CaseType: ' + caseType);  
      // If the case doesn't exist then insert.
      if (c.Id == NULL) {
        RecordType type = [Select Id From RecordType Where Name = :caseType Limit 1];
        System.debug('-----> [SaveCase] Case: ' + type);
        System.debug('-----> AccountID: ' + a);
        System.debug('-----> Contact: ' + ct);  
        c.AccountId = a.Id;
        c.ContactId = ct.Id;
        //c.RecordTypeId = '012j0000000hLwf'; // Set Record Type to "Incident," hard-coded value TO BE CHANGED
        c.RecordTypeId = type.Id;
        c.Status = 'Not Submitted';
        c.Origin = 'Web';
        insert c;
        // Fetch the case object with it's new fields.   
        c = retrieveBaseCase(c.Id);
      } else {
        update c;
      }
      // Update list of Involved Persons 
      if (personsList != null && personsList.size() <= 0) {
        personsList = new List<Involved_Persons__c> ();
      }
      System.debug('-----> personsList: ' + personsList);  
      System.debug('-----> personsList: ' + InvolvedPersons);   
      System.debug('-----> personsList: ' + RecordTypeIds);     
      personsList = Portal_Util.fromWrapper(c.Id, InvolvedPersons, RecordTypeIds);
      upsert personsList;
      // Delete all the removed people if editing.
      Boolean isSuccess = Portal_Util.deleteInvolvedPersons(deleteInvolvedPersons);
      // If successful then reset the deleteInvolcedPersons list.  
      if (isSuccess == true) {
        deleteInvolvedPersons = new List<Portal_Util.InvolvedPerson_Wrapper> ();
      }
      // Update the current InvolvedPersons set to include the newly inserted id's. This will ensure records are updated on upsert instead of duplicates. 
      InvolvedPersons = Portal_Util.fetchInvolvedPersons(c.Id, RecordTypeNames);
      System.debug('-----> [Save Case]Involved Persons: ' + InvolvedPersons);
      System.debug('-----> [Save Case]Delete Involved Persons: ' + isSuccess);
      System.debug('-----> [Save Case]deleteInvolvedPersons: ' + deleteInvolvedPersons);
    } catch(Exception e) {
      System.debug('-----> [SaveCase] Error: ' + e.getMessage());
      return false;
    }
    return true;
  }

  /**
   * submitCase
   * 
   * This function will change the case status to 'New' making it now submitted and un-editiable.
   * @author Chris.
   */
  private void submitCase() {
    if (c.Id != NULL) {
      c.Status = 'New';
      // Field for "Date/Time Submitted" does not exist, cannot set
      update c;
    }
  } // end submitCase

  /**
   * deleteCase
   * 
   * This function will delete the current case if an ID is available.
   * @author Chris
   */
  private void deleteCase() {
    // Handle deletions for existing case
    if (c.Id != NULL) { delete c; }
  }

  private Case retrieveBaseCase(Id caseId) {
    return[
    SELECT Id, AccountId, ContactId, Subject, Description, Status, CreatedDate, ClosedDate, Event_Location__c, Date_Event_Occured__c, Time_Event_Occured__c,
    First_Aid_or_CPR_Provided__c, First_Aid_When__c, First_Aid_By_whom__c, X911_Called__c, X911_called_when__c, X911_By_whom__c,
    Child_Transported_for_Medical_Attention__c, Med_AttentionWhere__c, Med_Attention_By_whom__c, Medical_Treatment_Provided__c,
    Diagnosis_Resulted__c, Child_return_to_Program__c, When_Child_Return__c, Shared_with_Parents__c, How_What_Shared_Info__c,
    When_Shared_Info__c, With_who__c, Who_Shared_Info__c, Filed_with_DCF__c, DCF_Filer__c, DCF_File_Submission_Date__c,
    Incident_involves_legal_proceedings__c,Other_Person_Notified__c, Group_the_child_was_in__c,No_children_in_group__c,
    Name_Qual_of_staff_supervising__c, Description_of_corrective_action__c, First_Aid_What__c ,Other_Person_Notified_Who__c,
    Other_Person_Notified_How__c, Other_Person_Notified_When__c, Legal_Proceeding_Description__c, CPR_Provided__c, CPR_When__c, CPR_By_Whom__c,
    DCF_Screening_Status__c, Filed_with_DPPC__c, DPPC_Filer__c, DPPC_File_Submission_Date__c, Homefinder_Contact_Last_6_months__c,
    Last_Social_Worker_Home_Visit__c, Most_Recent_Reevaluation__c, Original_Home_Study__c, Concerns_Identified__c, MAPP_Training_Date__c, 
  Home_Type__c, List_of_Restrictions__c,LastModifiedDate, RecordType.Name, RecordType.Id
    FROM Case WHERE Id = : caseId
    ];
  }

  /**
   * getInvolvedPersons
   * 
   * This function will get the InvolvedPerson list.
   * @author Chris
   */
  public List<Portal_Util.InvolvedPerson_Wrapper> getInvolvedPersons() {
    return InvolvedPersons;
  }

  /**
   * saveAttachmentsFromJson
   * 
   * This function will accept a json parameter of files decriptions to save to the transaction object.
   * @author Darkis
   */
  public void saveAttachmentsFromJson() {
    try {
      // List of S3Objects. 
      if (!String.isBlank(attachmentsJson)) {
        // Convert the json into S3_Files.
        List<S3_File__c> s3FilesList = (List<S3_File__c>) JSON.deserialize(attachmentsJson, List<S3_File__c>.class);
        upsert s3FilesList;
        // Get all the current FileMap records for the object and ensure we don't create any duplicates.  
        Set<Id> fileMappingIds = (new Map<Id, FileMap__c> ([Select S3_File__c From FileMap__c Where Object_Id__c = :c.Id])).keySet();
        List<FileMap__c> filesToMap = new List<FileMap__c> ();
        // Loop through all the files in the list and verify any that are new to be added. 
        for (S3_File__c file : s3FilesList) {
          if (!fileMappingIds.contains(file.Id)) {
            filesToMap.add(new FileMap__c(
                                          Object_Name__c = String.valueOf(c.getSObjectType()),
                                          Object_Id__c = c.Id,
                                          S3_File__c = file.Id
            ));
          }
        }
        // Insert the new files that need to be mapped.   
        insert filesToMap;
      }
    } catch(Exception e) {
      System.debug('-----> Error: ' + e.getMessage());
      ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
      ApexPages.addMessage(errMsg);
    }
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
    FileMap__c fileMap = [Select Id, S3_File__r.Filename__c From FileMap__c Where Object_Id__c = :c.Id AND S3_File__c = :fileToDelete LIMIT 1];
    delete fileMap;
    // Delete the S3_File reference in Sforce.
    S3_File__c file = [Select Id, Filename__c, Prefix__c From S3_File__c Where Id = :fileMap.S3_File__c LIMIT 1];
    delete file;
    // Invoke the future method to delete the object in S3 using the SOAP API.
    deleteS3FileReference(bucketName, file.Prefix__c + '/' + file.Filename__c);
    // Refresh the attachments list.
    refreshIncidentAttachments();
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
  @future(callout = true)
  public static void deleteS3FileReference(String bucketName, String filename) {
    // Delete the file from S3 using the SOAP API.  
    EEC_S3ComponentCtrl.deleteFile(bucketName, filename);
  }

  public List<S3_File__c> refreshIncidentAttachments() {
    attachments = new List<S3_File__c> ();
    List<FileMap__c> fileMappings = [Select Id, S3_File__r.Id, S3_File__r.CreatedDate, S3_File__r.Filename__c From FileMap__c Where Object_Id__c = :c.Id];

    if (fileMappings.size() > 0) {
      Set<Id> fileIds = new Set<Id> ();

      for (FileMap__c filemap : fileMappings) {
        fileIds.add(filemap.S3_File__r.Id);
      }
      attachments = [Select Id, Filename__c, CreatedDate From S3_File__c Where Id IN :fileIds];
      attachmentsJson = JSON.serialize(attachments);
      System.debug('----> All Files: ' + attachments);
      return attachments;
    } else {
      attachmentsJson = '';
    }
    return new List<S3_File__c> ();
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
  public static List<Map<String, String>> generateMultiplePolicySignature(String bucket, String acl, String fileJson) {
    List<Map<String, String>> returnJson = new List<Map<String, String>> ();
    List<EEC_S3ComponentCtrl.FileTypeJsonWrapper> fileTypeWrapperList = (List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>) JSON.deserialize(fileJson, List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>.class);
    // Loop through the files given and get all the necessary policy/sig combos.
    for (EEC_S3ComponentCtrl.FileTypeJsonWrapper wrapper : fileTypeWrapperList) {
      returnJson.add(EEC_S3ComponentCtrl.generatePolicySignature(bucket, acl, wrapper.filename, wrapper.type, null));
    }
    return returnJson;
  }
    
  public PageReference nextStageIncident() {
    //if (c == null) {
      caseType = 'Incident';
      caseTypeLabel = 'Incident';
    //}
  return nextStage();
  }
  
   public PageReference next51AIncident() {
    //if (c == null) {
      caseType = '51A Incident';  
      caseTypeLabel = '51A Incident';
    //}
    return nextStage();
  }
  
  public PageReference nextStageInjury() {
    //if (c == null) {
      caseType = 'SLGSA Injury';
      caseTypeLabel = 'Injury';
    //}
  return nextStage();
  }
}