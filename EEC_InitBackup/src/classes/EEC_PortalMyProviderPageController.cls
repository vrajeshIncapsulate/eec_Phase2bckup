/**
 * An apex class that views and updates provider/umbrella information.
 */
public without sharing class EEC_PortalMyProviderPageController {
    
    public List<Conditions_and_Limitations__c> conditions { get; set; }
    public String condition_none{get;set;}

    public List<Account> providerslist { get; set; }
    
    public list<Contact> contactlist {get;set; }
    public list<Inspection__c> inspectionlist {get;set; }
    public list<Investigation__c> investlist {get;set; }
    public list<Licensing_Transaction__c> licenselist {get;set; }
    public list<Restraint_Report__c> reportlist {get;set; }
    public list<Case> incidentlist {get;set; }
    public list<Intervention__c> interventionlist {get;set; }
    public String conditionStr {get;set;}
    public String profileName {get;set;}
    public String memberId {get; set;}
    public String memberIds {get; set;}
    private String sortDirection = 'ASC';
    private String sortExp = 'License_Status__c';
    public String Attachmentid {get;set;}
    public map<string,string> attachmap{get;set;}
    set<string> caseid = new set<string>(); 
    
    public integer listsize {get; set; }
    public Map<String,PageReference> lastStepMap;
    public Map<String, String> secureMemberMap {get;set;}
    public Map<String, String> secureIdMap {get;set;}
    public String errorMsg {get;set;}
    
    private Account account;
    private Contact contact;
    private String accountid;
    private User user;
    private boolean isEdit = false;
      
    public Account getAccount(){
      return account;
    }
    public Contact getContact(){
      return contact;
    }
    public User getUser(){
       return user;
    }    
    public Boolean getIsEdit() {
       return isEdit;
    }
    
    public EEC_PortalMyProviderPageController() {
       List<Account> tempAccount; 
       secureIdMap = new Map<String,String>();
       attachmap=new map<string,string>();
       String PageURL = ApexPages.currentPage().getUrl();
       memberId = ApexPages.currentPage().getParameters().get('member');
       if(String.isNotBlank(memberId)){
      	 	memberId = EncodingUtil.urlDecode(memberId, 'UTF-8'); 
       }
       List<Profile> profiles = [SELECT Name from profile where Id = :userinfo.getProfileId() LIMIT 1]; 
       if(profiles.size() > 0) 
       	profileName = profiles[0].Name; 
       if (PageUrl.equalsIgnoreCase(Page.EEC_Umbrella.getURL())) {
         System.debug('----> Umbrella page.');
         tempAccount = [SELECT Id, Umbrella_Members__c, RecordType.Name FROM Account WHERE ID in (SELECT Accountid FROM User WHERE id = :Userinfo.getUserId()) Limit 1];
         if (tempAccount != null && tempAccount.size() == 1 && !tempAccount[0].Recordtype.Name.contains('Umbrella')) {
           tempAccount = [SELECT Id FROM Account WHERE Id = :tempAccount.get(0).Umbrella_Members__c];  
         }  
       } else {  
         if(!String.isBlank(memberId)) {
           System.debug('----> Umbrella Member.');
           memberId = EEC_Util.decryptGetParam(memberId);
           tempAccount = [SELECT Id FROM Account WHERE ID = :memberId Limit 1];            
         } else { 
           tempAccount = [SELECT Id FROM Account WHERE ID in (SELECT Accountid FROM User WHERE id = :Userinfo.getUserId()) Limit 1];        
         }
       }
        
       
       if (tempAccount != null && tempAccount.size() == 1){
         accountid = tempAccount.get(0).Id;    
       }
       if(accountid == null){
           accountid = ApexPages.currentPage().getParameters().get('accountid');
       } 
       
       if (accountid != null) {
         getProviderdata();
       }
        
       if (account != null) {
         getContactlist();
         getLicenselist();
         getinspectionlist();
         getincidentslist();
         getinvestlist(); 
         getreportlist();
         getconditions();
         getproviderslist();
         getProviders();
         getinterventionlist();
         defineLastStepMap();
         defineattachmap();
         createSecureMemberMap();
         //createSecureTransactionMap();
         System.debug('-----> secureMap: ' + secureIdMap);
       } 
        
       if (String.isBlank(accountid) && account == null) {
         errorMsg = 'An error has occured. Please contact your administrator for assistance.';     
       }
    }    
    
    public PageReference trxIntro() {
        PageReference pPage = page.EEC_TransactionIntroduction;
        addMemberIdParameter(pPage);
        return pPage;
    }
   
   public PageReference noncomp() { 
        PageReference pPage = page.EEC_PortalNonCompliancePage;
        addMemberIdParameter(pPage);
        return pPage;
    } 
   public PageReference investigationPage() {
        PageReference pPage = page.EEC_Interventionpage;
       	addMemberIdParameter(pPage);
        return pPage;
    }

    public PageReference home() {
        return Page.EEC_PortalLandingPage;        
    }


    public void cancel() {
        isEdit =false;
    }
    
	public PageReference subInc() {
        PageReference pPage = page.EEC_CasesIncidentsPage;
        addMemberIdParameter(pPage);
        return pPage;
  	}
    public PageReference resReport() {
        PageReference pPage = page.EEC_RestraintReport;
        addMemberIdParameter(pPage);
        return pPage;
  	}    

    public PageReference save() {
        try{
           if (account != null){
               update account;
           }
           isEdit=false;
        }catch(DmlException e) {
            ApexPages.addMessages(e);
        }
       
        return null;
    }
    
    public void getProviderdata(){
    
       try{
           account = [select id,name,Umbrella_Members__c,Umbrella_Members__r.Name,Business_Name__c,Recordtype.Name,Provider_Number__c,License_Status__c,Provider_Status__c,Tax_ID__c,OwnerId
                 ,Public_Approval__c,Publish_on_Web__c,Head_Start__c,Accept_Referral__c,Phone,Alternate_Phone__c,fax,Provider_Email__c,Provider_Address_1__c,
              Provider_Address_2__c,Provider_City__r.Name,State__c,Provider_Zip_Code__c,ShippingAddress,Current_License_Number__c,License_Type__c,
              First_Issue_Date__c,Last_Issue_Date__c,Renewal_date__c,Foster_Parent__c,Bi_lingual_Licensor__c,Language__c,capacity__c,
              Preferred_Language__c,Race__c,Regulatory_Status__c,Gender__c,Has_Multi_Age_Group__c,Min_Age_Years_LG_SG__c,Min_Age_Months__c,
              Max_Age_Years_LG_SG__c,Max_Age_Months__c,Has_Full_Day_Program__c,Has_Half_Day_Program__c,Has_Camp_Capacity__c,Full_School_Year__c,
              Pool_Approved__c,Provide_Transportation__c,Cafeteria_Approved__c,Gym_Approved__c,Offsite_Outdoor_Play_Location__c,Other_Approved_Additional_Space__c,
              Total_Staff__c,Referral_Required__c,Referral_Agency__c,Private_Adoption__c,Program_Age__c,Level_of_Care__c,Approved_Reg_766__c,Use_Physical_Restraints__c,
              Restraint_Method__c,Secured_Facility__c,Locked_Facility__c,Administer_Own_School__c,Has_Medical_Administration__c,Characteristics_of_Children_Served__c,
              Specialties__c,Number_of_Foster_Homes__c,Number_of_Children_Placed_in_Care__c,Awake_Ratio__c,Asleep_Ratio__c,Ratios__c,Ratio_Comment__c,
              Infant_birth_15_mo__c,Infant_Toddler_birth_33_mo__c,Toddler_15_mo_33_mo__c,Toddler_Preschool_15_mo_K__c,Preschool_33_mo_K__c,Preschool_SA_33_mo_8_yr__c,
              Kindergarten__c,Kindergarten_School_Age__c,School_Age_5_yr_14_yr__c,Multi_Age_Group_birth_14_yr__c,Summer_Capacity__c,
              ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,Provider_city_text__c, FCC_System__c
              

              from account where id = :accountId limit 1 ];
              if (account != null){      
                  List<Contact> contactList = [select id,Name,Title,Email,Phone,Role__c from Contact where Accountid = :account.id limit 1];
                  List<User> userList = [select id,name,Phone,Email from user where id = :account.Ownerid limit 1];
                  
                  if(contactList.size() > 0) {
                    contact = contactList[0];    
                  }
                  
                  if (userList.size() > 0) {
                    user = userList[0];     
                  }
              }           
       }catch(exception ex){
           System.debug('----> Error: ' + ex.getMessage());
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator');
                        ApexPages.addMessage(errMsg);
       }   
    }
    
    public String getFCCSystemName() {
      Account[] fccSystem = [Select Id, Name From Account Where Id = :account.FCC_System__c];
      if(fccSystem.size() > 0)  
      	return fccSystem[0].Name;
      return null;  
    }
    
     public String getAttachmentId() {
      list<attachment> Att = new list<attachment>([Select id,name,parentid from attachment where parentid IN: Caseid and name='CaseSubmitted.pdf']);
      system.debug('MMMMM'+att.size());
      if(att.size() > 0)  
      	return att[0].id;
      	system.debug('MMMMM'+att[0].id);
      return null;
    }
    public void defineattachmap(){
    	list<attachment> Att = new list<attachment>([Select id,name,parentid from attachment where parentid IN: Caseid and name='CaseSubmitted.pdf']);
        if(Att.size()>0)
            for(Attachment a:Att)
            	attachmap.put(a.parentid,a.id);
    }
    
    public void  getContactlist(){
       try{
          If (account.Recordtype.Name.contains('Umbrella')){
              contactlist = [select id,Name,Title,Email,Phone,Role__c from Contact where Accountid = :account.id limit 50];
          }else{
              contactlist = [select id,Name,Title,Email,Phone,Role__c from Contact where Accountid = :account.id and Role__c in 
                         ('Director','Designee','Board Chair','Funding Source','Main Contact / Licensee') limit 50];
          }
       }catch(exception ex){
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator');
                        ApexPages.addMessage(errMsg);
       } 
    }
    
    public  void getLicenselist(){
      
       licenselist = [select id,Name,Recordtype.Name,Status__c,Last_Reached_Step__c,Submission_Date__c,Assigned_To__r.name,
                        Assigned_To__r.Email,Assigned_To__r.Phone from Licensing_Transaction__c where Provider__c = :account.id order by CreatedDate Desc limit 50 ];
    
    }
    
    public void getinspectionlist(){
       
       inspectionlist = [SELECT id,Name,Status__c,Created_on_the_Web__c,Date_of_Visit__c,Time_of_visit__c,Inspector_del__r.Name,Number_of_non_compliant_items__c
                         FROM Inspection__c WHERE Provider_No__c = :accountid AND RecordType.DeveloperName != 'Legacy_System_Import_Visit_Non_Compliance' AND (Status__c in 
                         ('Closed','Report to be sent to Provider','Report Sent to Provider, Awaiting feedback','Feedback received, to review') OR 
                         ( Status__c = 'Scheduled' and Announced__c = true)) AND RecordType.Name != 'Investigation Visits'  order by CreatedDate Desc limit 50 ];
       
    }

    public void getincidentslist(){
        
       incidentlist = [ SELECT id,CaseNumber,Subject,Date_Event_Occured__c,Status,CreatedDate,ClosedDate FROM Case WHERE 
                        AccountId = :accountid AND
                       (Recordtype.Name = 'Incident' OR Recordtype.Name = 'SLGSA Injury')
                       AND CreatedById IN: [SELECT Id FROM User WHERE UserType = 'CspLitePortal']
                       ORDER BY CreatedDate DESC LIMIT 50 ];
        
       for(Case C : Incidentlist){
       		caseid.add(C.id);
        	attachmap.put(c.id,'None');
       }
    } 
    
                           

    public void getinvestlist(){               
       investlist = [ SELECT id,Name,Investigation_Status__c,Closed_Date__c from Investigation__c where 
                      Provider_No__c = :accountid and Investigation_Status__c = 'Closed' order by Closed_Date__c Desc limit 50 ];

    }                          

    public void getreportlist(){               
       reportlist = [SELECT id,Name,Calendar_Year__c,Quarter__c,Contact_Submitted_By__r.name,Submitted_Date__c,Restraint_Method2__c,
                     Grand_Total__c FROM Restraint_Report__c  WHERE Provider__c =: accountid order BY Calendar_Year__c,Quarter__c DESC LIMIT 200];
  
    }                         
    
    public void getconditions(){
        try{        
           conditions = [SELECT Condition_On_License__c from Conditions_and_Limitations__c WHERE Current__c = true and Provider__c = :accountId];        
           }catch(exception ex){
                        ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator');
                        ApexPages.addMessage(errMsg);
           } 
           
           if (conditions == null || conditions.size() == 0){
               conditionStr = 'None';
           }
           else{
           	   conditionStr = '';
               for(Conditions_and_Limitations__c cond : conditions){
                  conditionStr = conditionStr + cond.Condition_On_License__c + '. ';
               }
               if(String.isNotBlank(conditionStr) && conditionStr.length() > 2){
               	  conditionStr = conditionStr.substring(0, conditionStr.length()-2);
               }
           	
           }
    } 
    public String sortExpression
  {
    get
    {
      return sortExp;
    }
    set
    {
      if (value == sortExp)
      sortDirection = (sortDirection == 'ASC') ? 'DESC' : 'ASC';
      else
      sortDirection = 'ASC';
      sortExp = value;
    }
  }

  public String getSortDirection()
  {
    if (sortExpression == null || sortExpression == '')
    return 'ASC';
    else
    return sortDirection;
  }

  public void setSortDirection(String value)
  {
    sortDirection = value;
  }  
  public PageReference getProviders() {
  	string sortFullExp =  ' order by '+sortExpression  + ' ' + sortDirection+' NULLS LAST' ;
  	system.debug('MMMMMM'+sortFullExp);
  	string query = 'Select id,name,Provider_Number__c,Provider_city_text__c,Phone,License_Status__c,recordtype.name,Provider_Status__c FROM Account WHERE Umbrella_Members__c = \'' + account.Id + '\'' + sortFullExp;
  	providerslist = Database.query(query);
  	system.debug('MMMM'+providerslist);
  	return null;
  
  }
                
    public void getproviderslist(){
        providerslist = [SELECT Id,Name,Provider_Number__c,Provider_city_text__c,Phone,License_Status__c,recordtype.name,Provider_Status__c FROM Account WHERE Umbrella_Members__c = :account.id ORDER BY License_Status__c ASC,recordtype.name,name ASC LIMIT 150];         

    }   
    
    public void getinterventionlist(){                   
       interventionlist = [SELECT id,Investigation__r.Name,Portal_User_Instructions__c,To_Be_Provided_By__c,
                           Investigation__r.Provider_No__c, Status__c
                           FROM Intervention__c 
                           WHERE Investigation__r.Provider_No__c = :accountId 
                           AND Recordtype.Name = 'Internal Investigation' 
                           AND (Status__c = 'To Submit' OR Status__c = 'Submitted' OR Status__c = 'Done')
                           LIMIT 100 ];
    }
            
    public void edit() {
        isEdit=true;
    }
    public void addMemberIdParameter(PageReference pPage){
        if(String.isNotBlank(memberId))
        	pPage.getParameters().put('member',accountid);
    }
    
    public Pagereference editInstruction(){
    	String ltId = ApexPages.currentPage().getParameters().get('licTransId');
        Licensing_Transaction__c lt;
        //ltId = EEC_Util.decryptGetParam(ltId);
    	Licensing_Transaction__c[] lts = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :ltId];
        if(lts.size() > 0){
            lt = lts[0];
            PageReference pPage = lastStepMap.get(lt.Last_Reached_Step__c);
        	pPage.getParameters().put('ltId', lt.Id);
            addMemberIdParameter(pPage);
            return pPage;
        }
        else 
            return null;
    }
    private void defineLastStepMap(){
        lastStepMap = new Map<String,PageReference>();
        lastStepMap.put('Instructions', Page.EEC_TransactionInstructions);
        lastStepMap.put('Transaction / Provider Information',Page.EEC_TransactionProvider);
        lastStepMap.put('Household Members',Page.EEC_HouseHoldMembers);
        lastStepMap.put('License Status and Capacity / Assistant Information',Page.EEC_LicenseStatusCapacityInfo);
        lastStepMap.put('EEC Involvement Experience & Professional Exp.',Page.EEC_InvolvementExperience);
        lastStepMap.put('Background Information',Page.EEC_BackgroundInformation);
        lastStepMap.put('Training Information',Page.EEC_TrainingInformation);
        lastStepMap.put('Indoor / Outdoor space information',Page.EEC_IndoorSpacePage);
        lastStepMap.put('Daily Routing Activities / Technical Assistance',Page.EEC_TechnicalAssistance);
        lastStepMap.put('Attachments',Page.EEC_LicenseTransactionAttachments);
        lastStepMap.put('Review Summary and Submission',Page.EEC_ReviewSummarySubmission);
        //lastStepMap.put('Instructions',Page.);
    }
    
    private void createSecureMemberMap() {
      this.getproviderslist(); 
      
      for (Account acc : providerslist) {
        secureIdMap.put(acc.Id, EncodingUtil.urlEncode(EEC_Util.encryptGetParam(acc.Id),'UTF-8'));  
      } 
    }
    
    private void createSecureTransactionMap() {
      for (Licensing_Transaction__c lt : licenselist) {
        secureIdMap.put(lt.Id, EEC_Util.encryptGetParam(lt.Id));      
      }
    }
    
    public List<Account> getUmbrellaFCCSystem() {
      List<Account> assocProviders = [Select Id, Name, Provider_Number__c, Provider_city_text__c, License_Status__c, Provider_Status__c, Phone From Account Where FCC_System__c = :account.Id];
      return assocProviders;
    }
    
    public Boolean getFCCSystemExists() {
        System.debug('----> Account: ' + account);
        System.debug('----> Count Query: ' + [Select Count() From Account Where FCC_System__c = :account.Id]);
      Integer count = [Select Count() From Account Where FCC_System__c = :account.Id];
      System.debug('----> Count: ' + count);
      return count > 0 ? true : false;
    }
}