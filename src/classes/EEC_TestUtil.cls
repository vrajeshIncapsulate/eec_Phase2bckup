/* Test utility class */
@isTest
public class EEC_TestUtil {

  public static Intervention_Type__c mockInterventionType() {
    Intervention_Type__c i = new Intervention_Type__c(Name = 'Internal Investigation');
    upsert i;
    return i;
  }

  public static Investigation__c mockInvestigation(Account a) {
    Investigation__c i = new Investigation__c(Provider_No__c = a.Id, Assigned_To__c = Userinfo.getUserId());
    upsert i;
    return i;
  }

  public static User mockUser() {
    Profile p = [SELECT ID FROM Profile WHERE Name = 'System Administrator'];
    User u = new User(
                      Email = 'test@test.com',
                      LastName = generateRandomString(5),
                      FirstName = generateRandomString(5),
                      Username = generateRandomString(26) + '@test.com',
                      Alias = generateRandomString(5),
                      TimeZoneSidKey = 'GMT',
                      LocaleSidKey = 'en_US',
                      EmailEncodingKey = 'ISO-8859-1',
                      ProfileID = p.Id,
                      region__c = mockRegion().Id,
                      LanguageLocaleKey = 'en_US'
    );
    insert u;
    return u;
  }

  public static User mockPortalUser(Contact cont) {
    Profile p = [SELECT ID FROM Profile where name = 'EEC Community Standard User' OR name = 'Community Standard User for EEC' LIMIT 1];
    //UserRole r = [SELECT ID, Name FROM UserRole WHERE Name LIKE '%Customer User' limit 1];
    User u = new User(
                      Email = 'test@test.com',
                      LastName = EEC_TestUtil.generateRandomString(5),
                      FirstName = EEC_TestUtil.generateRandomString(5),
                      Username = EEC_TestUtil.generateRandomString(26) + '@test.com',
                      Alias = EEC_TestUtil.generateRandomString(5),
                      TimeZoneSidKey = 'GMT',
                      LocaleSidKey = 'en_US',
                      EmailEncodingKey = 'ISO-8859-1',
                      ProfileID = p.Id,
                      //UserRoleID = r.Id,
                      ContactId = cont.Id,
                      LanguageLocaleKey = 'en_US'
    );

    insert u;
    return u;
  }

  public static Non_Compliant__c mockNonCompliant(Investigation__c inv) {
    Non_Compliant__c nc = new Non_Compliant__c(
                                               Date_Implemented__c = System.Today(),
                                               Observations__c = generateRandomString(20),
                                               Investigation__c = inv.Id,
                                               Correction_Plan__c = generateRandomString(20),
                                               To_Review_on_Portal__c = true
    );

    insert nc;

    return nc;
  }


  public static Non_Compliant_Item_Regulation__c mockNonCompliantItemRegulation(Non_Compliant__c nc, Regulation__c r) {
    Non_Compliant_Item_Regulation__c ncir = new Non_Compliant_Item_Regulation__c(
                                                                                 Regulation__c = r.Id,
                                                                                 Non_Compliant_Item__c = nc.Id
    );

    insert ncir;

    return ncir;
  }

  public static City__c mockCity() {
    City__c c = new City__c();
    c.State__c = 'MA';
    upsert c;
    return c;
  }

  public static City__c mockCity(String name) {
    City__c c = new City__c();
    c.State__c = 'MA';
    c.Name = name;
    upsert c;
    return c;
  }

  public static Region__c mockRegion() {
    RecordType rType = [select Id from RecordType where DeveloperName = 'Licensing_Region' and SobjectType = 'Region__c'];
    List<Region__c> regList = new List<Region__c> ();
    User user = [SELECT Id FROM User WHERE ID = :UserInfo.getUserId() LIMIT 1];

    Region__c r = new Region__c();
    r.Name = 'Central';
    r.recordTypeId = rType.Id;
    r.FCC_GSA_1st_Escalation_Case_Approver__c = user.Id;
    r.FCC_GSA_2nd_Escalation_Case_Approver__c = user.Id;
    r.R_P_1st_Escalation_Case_Approver__c = user.Id;
    r.R_P_2nd_Escalation_Case_Approver__c = user.Id;
    r.Regional_Director__c = user.Id;
    r.SGLSA_New_Case_Default_Assignee__c = user.Id;
    r.Deputy_Commissioner__c = user.Id;
    r.FCC_New_Case_Default_Assignee__c = user.Id;
    regList.add(r);

    Region__c r1 = new Region__c();
    r1.Name = 'Northeast';
    r1.recordTypeId = rType.Id;
    r1.FCC_GSA_1st_Escalation_Case_Approver__c = user.Id;
    r1.FCC_GSA_2nd_Escalation_Case_Approver__c = user.Id;
    r1.R_P_1st_Escalation_Case_Approver__c = user.Id;
    r1.R_P_2nd_Escalation_Case_Approver__c = user.Id;
    r1.Regional_Director__c = user.Id;
    r1.SGLSA_New_Case_Default_Assignee__c = user.Id;
    r1.Deputy_Commissioner__c = user.Id;
    r1.FCC_New_Case_Default_Assignee__c = user.Id;
    regList.add(r1);

    insert regList;
    return regList.get(0);
  }

  public static Contact mockContact() {
    Contact c = new Contact(Salutation = 'Mr.', FirstName = generateRandomString(5), LastName = generateRandomString(5));
    insert c;
    return c;
  }
  public static Contact mockDirectorContact(Account accnt) {
    return mockContact(accnt, generateRandomString(5), generateRandomString(5), 'Director');
  }
  public static Contact mockContact(Account accnt, String firstName, String lastName, String role) {
    Contact c = new Contact(Salutation = 'Mr.', FirstName = firstName, LastName = lastName, Role__c = role, accountid = accnt.Id);
    insert c;
    return c;
  }

  public static Contact mockContact(String email) {
    Contact c = new Contact(Salutation = 'Mr.', FirstName = generateRandomString(5), LastName = generateRandomString(5), Email = email);
    insert c;
    return c;
  }

  public static AccountContactRole mockAccountContactRole(String role, Contact c, Account a) {
    AccountContactRole acr = new AccountContactRole(Role = role, ContactId = c.Id, AccountId = a.Id);
    insert acr;
    return acr;
  }
  public static User mockAccountWithUser() {
    Profile p = [SELECT ID FROM Profile Where Name = 'System Administrator' LIMIT 1];
    Account acc = mockProvider(mockCity());
    Contact con = mockDirectorContact(acc);

    User user = [Select Accountid From User Where id = :Userinfo.getUserId() Limit 1];
    acc.Owner = user;
    update acc;
    return user;
  }


  public static Account mockProvider(City__c c) {
    return mockProvider(c, null);
  }

  public static Account mockProvider(City__c c, Account a) {
    return mockProvider(c, null, null);
  }

  public static Account mockProviderConfig(City__c c, Lead_Configuration__c conf) {
    return mockProvider(c, null, conf);
  }

  public static Account mockProvider(City__c c, String accountName, String addressName, String pDevType) {
    return mockProvider(c, null, null, accountName, addressName, pDevType);
  }

  public static Account mockProvider(City__c c, Account a, Lead_Configuration__c conf, String pDevType) {
    return mockProvider(c, a, conf, 'Test User', 'Fake Adres 123', pDevType);
  }
  public static Account mockProvider(City__c c, Account a, Lead_Configuration__c conf) {
        RecordType r = [SELECT Id, Name FROM RecordType WHERE DeveloperName='FCC' and sobjecttype='Account'];
        Account pAccount = new Account(Name='TestProvider1',RecordTypeId=r.Id,Provider_Email__c='test@test.com');
        pAccount.Provider_City__c = c.Id;
        pAccount.Name = 'Test User';
        pAccount.Provider_Address_1__c = 'Fake Adres 123';
        pAccount.Provider_Zip_Code__c = '12345';
        pAccount.Renewal_date__c = Date.today();
        pAccount.license_status__c = 'Licensed';
        pAccount.Region__c = EEC_TestUtil.mockRegion().Id;
        if(a != null){
            pAccount.Umbrella_Members__c = a.Id;
        }
        if(conf != null){
            pAccount.Config_Record__c = conf.Id;
        }
        
        insert pAccount;
        System.debug(pAccount.Id);
        
        return pAccount;
    }

  public static Account mockProvider(City__c c, Account a, Lead_Configuration__c conf, String accountName, String addressName, String pDevType) {
    RecordType r = [SELECT Id, Name FROM RecordType WHERE DeveloperName = :pDevType AND sobjecttype = 'Account'];
    Account pAccount = new Account(Name = accountName, RecordTypeId = r.Id, Provider_Email__c = 'test@test.com');
    pAccount.Provider_City__c = c.Id;
    pAccount.Name = accountName;
    pAccount.Provider_Address_1__c = addressName;
    pAccount.Provider_Zip_Code__c = '12345';
    pAccount.Renewal_date__c = Date.today();
    pAccount.license_status__c = 'Licensed';
    pAccount.Region__c = EEC_TestUtil.mockRegion().Id;
    if (a != null) {
      pAccount.Umbrella_Members__c = a.Id;
    }
    if (conf != null) {
      pAccount.Config_Record__c = conf.Id;
    }

    insert pAccount;
    System.debug(pAccount.Id);

    return pAccount;
  }
  
  public static Account mockAssistProvider(City__c c, Account a, Lead_Configuration__c conf) {
    RecordType r = [SELECT Id, Name FROM RecordType WHERE Name = 'FCC Assistant' and sobjecttype = 'Account'];
    Account pAccount = new Account(Name = 'TestProvider1', RecordTypeId = r.Id, Provider_Email__c = 'test@test.com');
    pAccount.Provider_City__c = c.Id;
    pAccount.Name = 'Test User';
    pAccount.Provider_Address_1__c = 'Fake Adres 123';
    pAccount.Provider_Zip_Code__c = '12345';
    pAccount.Renewal_date__c = Date.today();
    pAccount.license_status__c = 'Licensed';
    pAccount.Region__c = EEC_TestUtil.mockRegion().Id;
 
    if (conf != null) {
      pAccount.Config_Record__c = conf.Id;
    }

    insert pAccount;
    System.debug(pAccount.Id);

    return pAccount;
  }

  public static Inspection_Item__c mockInspectionItem(Inspection__c insp, Regulation__c reg, String inspectionResult, Boolean nonAssessed, String technicalAssistance, String observations) {
    RecordType aiRType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Additional_Inspection_Item'];

    Inspection_Item__c iItem = new Inspection_Item__c(Inspection_no__c = insp.Id, Associated_regulation__c = reg.Id, RecordTypeId = aiRType.Id,
                                                      Non_Assessed_Item__c = nonAssessed, Technical_Assistance__c = technicalAssistance, Observations__c = observations, To_Review_on_Portal__c = true);

    if (!nonAssessed) {
      iItem.Inspection_Result__c = inspectionResult;
    }

    upsert iItem;
    return iItem;
  }

  public static Inspection_Item__c mockInspectionItemWithoutInsert(Inspection__c insp, Regulation__c reg, String inspectionResult, Boolean nonAssessed, String technicalAssistance, String observations) {
    RecordType aiRType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Additional_Inspection_Item'];

    Inspection_Item__c iItem = new Inspection_Item__c(Inspection_no__c = insp.Id, Associated_regulation__c = reg.Id, RecordTypeId = aiRType.Id,
                                                      Non_Assessed_Item__c = nonAssessed, Technical_Assistance__c = technicalAssistance, Observations__c = observations, To_Review_on_Portal__c = true);

    if (!nonAssessed) {
      iItem.Inspection_Result__c = inspectionResult;
    }
    return iItem;
  }

  public static Inspection_Item__c mockInspectionItem(Inspection__c insp, Regulation__c reg, String inspectionResult, Boolean nonAssessed, String technicalAssistance) {
    RecordType aiRType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Additional_Inspection_Item'];
    Inspection_Item__c iItem = new Inspection_Item__c(Inspection_no__c = insp.Id, Associated_regulation__c = reg.Id, RecordTypeId = aiRType.Id,
                                                      Non_Assessed_Item__c = nonAssessed, Technical_Assistance__c = technicalAssistance, Observations__c = 'TestObs', To_Review_on_Portal__c = true);

    if (!nonAssessed) {
      iItem.Inspection_Result__c = inspectionResult;
    }

    upsert iItem;
    return iItem;
  }

  public static Inspection_Item__c mockInspectionItemWithoutInsert(Inspection__c insp, Regulation__c reg, String inspectionResult, Boolean nonAssessed, String technicalAssistance) {
    RecordType aiRType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Additional_Inspection_Item'];
    Inspection_Item__c iItem = new Inspection_Item__c(Inspection_no__c = insp.Id, Associated_regulation__c = reg.Id, RecordTypeId = aiRType.Id,
                                                      Non_Assessed_Item__c = nonAssessed, Technical_Assistance__c = technicalAssistance, Observations__c = 'TestObs', To_Review_on_Portal__c = true);

    if (!nonAssessed) {
      iItem.Inspection_Result__c = inspectionResult;
    }
    return iItem;
  }
  
  public static Inspection_Item__c mockInspectionItem(Inspection__c insp, Standard_Inspection_Item__c sii, String inspectionResult, Boolean nonAssessed, String technicalAssistance) {
    RecordType sRType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Standard_Item'];
    Inspection_Item__c iItem = new Inspection_Item__c(Inspection_no__c = insp.Id, Standard_Inspection_Item__c = sii.Id, RecordTypeId = sRType.Id,
                                                      Non_Assessed_Item__c = nonAssessed, Technical_Assistance__c = technicalAssistance, Observations__c = 'TestObs', To_Review_on_Portal__c = true);

    if (!nonAssessed) {
      iItem.Inspection_Result__c = inspectionResult;
    }

    upsert iItem;
    return iItem;
  }

  public static Inspection_Item__c mockInspectionItemWithoutInsert(Inspection__c insp, Standard_Inspection_Item__c sii, String inspectionResult, Boolean nonAssessed, String technicalAssistance) {
    RecordType sRType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Standard_Item'];
    Inspection_Item__c iItem = new Inspection_Item__c(Inspection_no__c = insp.Id, Standard_Inspection_Item__c = sii.Id, RecordTypeId = sRType.Id,
                                                      Non_Assessed_Item__c = nonAssessed, Technical_Assistance__c = technicalAssistance, Observations__c = 'TestObs', To_Review_on_Portal__c = true);

    if (!nonAssessed) {
      iItem.Inspection_Result__c = inspectionResult;
    }
    return iItem;
  }

  public static Licensing_Transaction__c mockLiscence(Account acc) {
    RecordType r = [select Id from RecordType where DeveloperName = 'Legacy_System_Transaction' and sobjecttype = 'Licensing_Transaction__c'];
    Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId = r.Id, Status__c = 'Active', Provider__c = acc.Id, Submitter__c = Userinfo.getUserId());
    upsert lic;
    return lic;
  }

  public static Inspection__c mockInspection(Account acc) {
    Inspection__c insp = new Inspection__c(Provider_No__c = acc.Id, Status__c = 'Scheduled', Date_of_Visit__c = System.Today(), Inspector_del__c = Userinfo.getUserId());
    upsert insp;
    return insp;
  }
  
  public static Inspection__c mockInspectionWithOutInsert(Account acc) {
    Inspection__c insp = new Inspection__c(Provider_No__c = acc.Id, Status__c = 'Scheduled', Date_of_Visit__c = System.Today(), Inspector_del__c = Userinfo.getUserId());
    
    return insp;
  }  

  public static Junction_InspReg__c mockRegStdInsp(Regulation__c reg, Standard_Inspection_Item__c sii) {
    Junction_InspReg__c jir = new Junction_InspReg__c(Regulation__c = reg.Id, Standard_Inspection_Item__c = sii.Id);
    insert jir;
    return jir;
  }

  public static Standard_Inspection_Item__c mockStdInspectionItem() {
    Standard_Inspection_Item__c sii = new Standard_Inspection_Item__c(name = generateRandomString(5), Description__c = generateRandomString(5), Applicable_to__c = 'Large Group');
    upsert sii;
    return sii;
  }

  public static Regulation__c mockRegulation() {
    Regulation__c reg = new Regulation__c(name = generateRandomString(5), Date_Active__c = Date.today(), Reg_key__c = generateRandomString(5), Article__c = generateRandomString(5), applicable_To__c = 'Family Child Care');
    upsert reg;
    return reg;
  }

  public static Case mockCase(String providerName, String street, Id city, String zip) {
    RecordType r = [SELECT Id FROM RecordType WHERE DeveloperName = 'Complaint' AND sObjectType = 'Case'];
    Case c = new Case(RecordTypeId = r.Id, Unlicensed_Provider_Name__c = providerName, Unlicensed_Provider_Street__c = street, Unlicensed_Provider_Zip_Code__c = zip, Unlicensed_Provider_City__c = city, Unlicensed_Provider_Region__c = EEC_TestUtil.mockRegion().Id, Priority = 'High Risk');
    insert c;
    return c;
  }

  public static Case mockCase(Account a, Contact contact) {
    RecordType r = [SELECT Id FROM RecordType WHERE DeveloperName = 'Incident' AND sObjectType = 'Case'];
    Case c = new Case(AccountId = a.Id, RecordTypeId = r.Id, ContactId = contact.Id, Priority = 'High Risk');
    insert c;
    return c;
  }

  public static Case mockCase(Account a, Contact contact, Investigation__c i) {
    RecordType r = [SELECT Id FROM RecordType WHERE DeveloperName = 'Incident' AND sObjectType = 'Case'];
    Case c = new Case(AccountId = a.Id, RecordTypeId = r.Id, ContactId = contact.Id, Investigation__c = i.Id, Unlicensed_Provider_Region__c = EEC_TestUtil.mockRegion().Id, Priority = 'High Risk');
    insert c;
    return c;
  }

  public static Task mockTask(Case c) {
    Task t = new Task(WhatId = c.Id, Status = 'Not Started', Priority = 'Normal', Subject = generateRandomString(5));

    insert t;
    return t;
  }

  public static Lead_Configuration__c mockLeadConfig(String visitSummary) {
    return mockLeadConfig(null, visitSummary);
  }

  public static Task mockTask(Investigation__c c) {
    Task t = new Task(WhatId = c.Id, Status = 'Not Started', Priority = 'Normal', Subject = generateRandomString(5));

    insert t;
    return t;
  }

  public static Task mockTask(String subject, Id whoId) {
    Task t = new Task(
                      WhoId = whoId,
                      Status = 'Completed',
                      Subject = subject
    );
    insert t;
    return t;
  }

  public static Lead mockLead() {
    Lead fp = new Lead(FirstName = 'TestF', LastName = 'TestL', Status = 'Registered',
                       Company = 'Test Provider', Street_Address_1__c = '1st Street',
                       City__c = EEC_TestUtil.mockCity().Id, State__c = 'MA', Zip_code__c = '01803', 
                       Region__c = EEC_TestUtil.mockRegion().Id, 
                       PPM_Participation_Region__c = EEC_TestUtil.mockRegion().Id,
                       PPM_Language__c = 'test');
    insert fp;
    return fp;
  }
  public static Lead_Configuration__c mockLeadConfig(String name, String visitSummary) {
    Lead_Configuration__c lead = new Lead_Configuration__c();

    lead.Visit_Narrative_Summary_Default__c = visitSummary;
    lead.No_of_Days_For_Investigation_Due_Date__c = 1;
    lead.Number_of_Non_Comp_before_longer_visit__c = 1;
    if (String.isNotBlank(name)) {
      lead.Name = name;
    }
    else {
      lead.name = 'Family Child Care';
    }

    insert lead;

    return lead;
  }

  public static String generateRandomString(Integer len) {
    final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    String randStr = '';
    while (randStr.length() < len) {
      Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
      randStr += chars.substring(idx, idx + 1);
    }
    return randStr;
  }


  public static Inspection__c loadInspectionSetup() {
    RecordType r = [select Id from RecordType where DeveloperName = 'FCC' and sobjecttype = 'Account'];
    RecordType r1 = [select Id from RecordType where DeveloperName = 'Investigation_Visits' and sobjecttype = 'Inspection__c'];
    Account pAccount = new Account(
                                   name = 'TestProvider1',
                                   RecordTypeId = r.Id,
                                   Provider_Email__c = 'test@test.com',
                                   Provider_Address_1__c = '123 Test St',
                                   Provider_City__c = EEC_TestUtil.mockCity().Id,
                                   Provider_Zip_Code__c = 'B3H0A2');
    insert pAccount;

    r = [select Id from RecordType where DeveloperName = 'FCC_New_License' and sobjecttype = 'Licensing_Transaction__c'];
    //Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId = r.Id, Status__c = 'Active', Provider__c = pAccount.Id, Submitter__c = Userinfo.getUserId());
    //insert lic;
    r1 = [select Id from RecordType where DeveloperName = 'Investigation_Visits' and sobjecttype = 'Inspection__c'];
    Inspection__c insp = new Inspection__c(Provider_No__c = pAccount.Id, RecordTypeId = r1.Id, Status__c = 'Scheduled', Date_of_Visit__c = date.today(), Mater_Visit_for_Res_Cluster_of_Visits__c = null);
    insert insp;
    System.debug('*******1 -- ' + insp.Status__c);
    Standard_Checklist_Reference__c scr = new Standard_Checklist_Reference__c(name = 'Swimming pool checklist', Active__c = true, Applicable_To__c = 'Large Group', No_of_Random_Items_Per_Domain_to_Pick__c = 0);
    insert scr;
    Standard_Checklist_Reference__c scr1 = new Standard_Checklist_Reference__c(name = 'Swimming pool checklist', Active__c = true, Applicable_To__c = 'Family Child Care', No_of_Random_Items_Per_Domain_to_Pick__c = 0);
    insert scr1;
    Standard_Checklist_Reference__c scr2 = new Standard_Checklist_Reference__c(name = 'Swimming pool checklist', Active__c = true, Applicable_To__c = 'Family Child Care', Available_for__c = 'Pre-Licensing', No_of_Random_Items_Per_Domain_to_Pick__c = 0);
    insert scr2;

    List<Standard_Inspection_Item__c> siiList = new List<Standard_Inspection_Item__c> ();
    Standard_Inspection_Item__c sii = new Standard_Inspection_Item__c(name = 'Swimming pool security rules', Description__c = 'Check gates', Applicable_to__c = 'Large Group');
    siiList.add(sii);
    Standard_Inspection_Item__c sii2 = new Standard_Inspection_Item__c(name = 'Swimming pool written consent', Description__c = '    Check written consent for children.', Applicable_to__c = 'Large Group');
    siiList.add(sii2);
    insert siiList;

    Regulation__c reg = new Regulation__c(name = 'Test Reg', Date_Active__c = Date.today(), Reg_key__c = '123456', Article__c = 'TEST Article', Applicable_To__c = 'Family Child Care');
    insert reg;

    List<Inspection_Item__c> iiList = new List<Inspection_Item__c> ();
    RecordType aiRType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Additional_Inspection_Item'];
    RecordType sRType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Standard_Item'];
    Inspection_Item__c iItem = new Inspection_Item__c(Inspection_no__c = insp.Id, Associated_regulation__c = reg.Id, RecordTypeId = aiRType.Id, Inspection_Result__c = 'Non-Compliant', Date_Implemented__c = Date.Today(), Correction_Plan__c = 'Testing 1', observations__c = 'test', To_Review_on_Portal__c = true);
    Inspection_Item__c iItem1 = new Inspection_Item__c(Inspection_no__c = insp.Id, Standard_Inspection_Item__c = sii.Id, RecordTypeId = sRType.Id, Inspection_Result__c = 'Non-Compliant', observations__c = 'test', Date_Implemented__c = Date.Today(), Correction_Plan__c = 'Testing 2', To_Review_on_Portal__c = true);
    Inspection_Item__c iItem2 = new Inspection_Item__c(Inspection_no__c = insp.Id, Standard_Inspection_Item__c = sii.Id, RecordTypeId = sRType.Id, Inspection_Result__c = 'Non-Compliant', observations__c = 'test', To_Review_on_Portal__c = true);
    Inspection_Item__c iItem3 = new Inspection_Item__c(Inspection_no__c = insp.Id, Standard_Inspection_Item__c = sii.Id, RecordTypeId = sRType.Id, Inspection_Result__c = 'Non-Compliant', observations__c = 'test', To_Review_on_Portal__c = true);
    iiList.add(iItem);
    iiList.add(iItem1);
    iiList.add(iItem2);
    iiList.add(iItem3);
    insert iiList;

    List<Junction_ChklInsp__c> jcList = new List<Junction_ChklInsp__c> ();
    Junction_ChklInsp__c jc = new Junction_ChklInsp__c(Standard_Inspection_Item__c = sii.Id, Standard_Checklist_Reference__c = scr.Id);
    Junction_ChklInsp__c jc1 = new Junction_ChklInsp__c(Standard_Inspection_Item__c = sii2.Id, Standard_Checklist_Reference__c = scr1.Id);
    Junction_ChklInsp__c jc2 = new Junction_ChklInsp__c(Standard_Inspection_Item__c = sii2.Id, Standard_Checklist_Reference__c = scr2.Id);
    jcList.add(jc);
    jcList.add(jc1);
    jcList.add(jc2);
    insert jcList;

    return insp;
  }

  public static Investigation__c loadInvestigationSetup() {
    RecordType r = [select Id from RecordType where DeveloperName = 'FCC' and sobjecttype = 'Account'];
    Account pAccount = new Account(
                                   name = 'TestProvider1',
                                   RecordTypeId = r.Id,
                                   Provider_Email__c = 'test@test.com',
                                   Provider_Address_1__c = '123 Test St',
                                   Provider_City__c = EEC_TestUtil.mockCity().Id,
                                   Provider_Zip_Code__c = 'B3H0A2');
    insert pAccount;

    Investigation__c invest = EEC_TestUtil.mockInvestigation(pAccount);
    return invest;
  }
  public static Investigation__c loadInvestigationSetup(Account provider) {
    Investigation__c invest = EEC_TestUtil.mockInvestigation(provider);
    return invest;
  }  

  public static Intervention__c mockIntervention(Investigation__c inv) {
    RecordType r = [select Id from RecordType where DeveloperName = 'Internal_Investigation' and sobjecttype = 'Intervention__c'];
    Intervention__c i = new Intervention__c(
                                            Investigation__c = inv.Id,
                                            RecordTypeId = r.id,
                                            Intervention_Type__c = mockInterventionType().Id
    );
    insert i;
    return i;
  }

  public static Licensing_Transaction__c loadLicenseSetup() {
    RecordType r = [select Id from RecordType where DeveloperName = 'FCC' and sobjecttype = 'Account'];
    Account pAccount = new Account(
                                   name = 'TestProvider1',
                                   RecordTypeId = r.Id,
                                   Provider_Email__c = 'test@test.com',
                                   Provider_Address_1__c = '123 Test St',
                                   Provider_City__c = EEC_TestUtil.mockCity().Id,
                                   Provider_Zip_Code__c = 'B3H0A2');
    insert pAccount;
    return EEC_TestUtil.mockLiscence(pAccount);

    //r = [select Id from RecordType where DeveloperName='large_group' and sobjecttype='Licensing_Transaction__c'];
    //Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId=r.Id,License_Status__c='Active', License_Type__c='Renewal', Provider_No__c=pAccount.Id);
    //upsert lic;
    //return lic;
  }

  public static Licensing_Transaction__c mockLicenseTransaction(Account accnt, String recordType) {
    RecordType r = [select Id from RecordType where DeveloperName = :recordType and sobjecttype = 'Licensing_Transaction__c'];
    Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId = r.Id, Status__c = 'Active', Provider__c = accnt.Id, Submitter__c = Userinfo.getUserId());
    insert lic;
    return lic;
  }

  public static Licensing_Transaction__c mockAssistantLicenseTransaction(Account a, String recordType) {
    RecordType r = [select Id from RecordType where DeveloperName = :recordType and sobjecttype = 'Licensing_Transaction__c'];
    Licensing_Transaction__c lic = new Licensing_Transaction__c(
      RecordTypeId = r.Id, 
      Status__c = 'Active', 
      Provider__c = a.Id,
      Submitter__c = Userinfo.getUserId()
    );
    insert lic;
    return lic;
  }

  public static Account loadLicenseTransaction() {
    Lead_Configuration__c config = EEC_TestUtil.mockLeadConfig('Family Child Care', null);
    Lead_Configuration__c config2 = EEC_TestUtil.mockLeadConfig('FCC Assistant', null);
    System.debug('----> Lead_Configuration__c Object: ' + config);
    System.debug('----> Lead_Configuration__c Object 2: ' + config2);
    Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), 'Test User', 'Fake Adres 123', 'FCC');
    accnt.Config_Record__c = config2.Id;
   // accnt.Electronic_Communication__c = true;
  //  accnt.Provider_Email__c = 'test2@email.com';
    upsert accnt;
    System.debug('----> Account: ' + accnt);
    //Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt, 'FCC_Renewal');
    RecordType r = [select Id from RecordType where DeveloperName = 'FCC_Renewal' and sobjecttype = 'Licensing_Transaction__c'];
    System.debug('----> RecordType: ' + r);
    Licensing_Transaction__c lic = new Licensing_Transaction__c(RecordTypeId = r.Id, Status__c = 'Active', Provider__c = accnt.Id, Submitter__c = Userinfo.getUserId());
    System.debug('----> [BEFORE] Licensing Transaction: ' + lic);
    insert lic;
    System.debug('----> [AFTER] Licensing Transaction: ' + lic);
    EEC_TestUtil.mockHouseHold(lic, accnt);
    EEC_TestUtil.mockFCCAssistant(lic, accnt);
    EEC_TestUtil.mockRoom(lic);
    EEC_TestUtil.mockTrainingExperience(lic);

    return accnt;
  }

  public static List<Household_Member__c> mockHouseHold(Licensing_Transaction__c lic, Account accnt) {
    List<Household_Member__c> hhList = new List<Household_Member__c> ();
    Household_Member__c iHm = new Household_Member__c();
    iHm.Relationship_to_Provider__c = 'TestR';
    iHm.Provider__c = accnt.Id;
    iHm.Occupation__c = 'TestO';
    iHm.Licensing_Transactions__c = lic.Id;
    iHm.Last_Name__c = 'TestL';
    iHm.First_Name__c = 'TestF';
    iHm.Email_Address__c = 'test@test.com';
    iHm.Date_of_Birth__c = Date.Today();
    iHm.Current__c = true;
    iHm.Current_School_Grade__c = 'TestC';
    iHm.Number_of_Hours_Home_During_Child_Care__c = 10;
    hhList.add(iHm);
    insert hhList;
    return hhList;
  }

  public static List<FCC_Assistant__c> mockFCCAssistant(Licensing_Transaction__c lic, Account accnt) {
    List<FCC_Assistant__c> faList = new List<FCC_Assistant__c> ();
    FCC_Assistant__c fa = new FCC_Assistant__c();
    fa.First_Name__c = 'TestAF';
    fa.Last_Name__c = 'TestLF';
    fa.Mailing_Address__c = 'test@test.com';
    fa.License_Number__c = '123';
    fa.License_Expiration_Date__c = Date.Today();
    fa.Provider__c = accnt.Id;
    fa.Source_Transaction__c = lic.Id;
    faList.add(fa);
    insert faList;
    return faList;
  }

  public static List<Room__c> mockRoom(Licensing_Transaction__c lic) {
    List<Room__c> roomList = new List<Room__c> ();
    Room__c tRoom = new Room__c();
    tRoom.Name = 'TestName';
    tRoom.Use__c = 'TestUse';
    tRoom.Dimension_Length_feet__c = 10;
    tRoom.Dimension_Width_feet__c = 10;
    tRoom.Floor_Level__c = '10';
    tRoom.Source_Transaction__c = lic.Id;
    roomList.add(tRoom);
    insert roomList;
    return roomList;
  }

  public static List<Training_Experience__c> mockTrainingExperience(Licensing_Transaction__c lic) {
    List<Training_Experience__c> teList = new List<Training_Experience__c> ();
    Training_Experience__c te = new Training_Experience__c();
    te.Topic__c = 'TestTopic';
    te.Date_of_the_Training__c = Date.Today();
    te.Number_of_Training_Hours__c = 10;
    te.Licensing_Transactions__c = lic.Id;
    te.Contact__c = EEC_TestUtil.mockContact().Id;
    teList.add(te);
    insert teList;
    return teList;
  }

  public static AWSKeys mockAWSKeys() {
    AWSKey__c key = new AWSKey__c();
    key.Key__c = '1234';
    key.Secret__c = 'abcde';
    key.Name = 'eec';
    key.Secret_Encrypted__c = 'abcde';
    insert key;

    AWSKeys creds = new AWSKeys('eec');
    return creds;
  }

  public static Standard_Best_Practices__c mockStdBestPractice() {
    Standard_Best_Practices__c bp = New Standard_Best_Practices__c(
                                                                   Name = 'Test BP',
                                                                   Applicable_To__c = 'FCC',
                                                                   Best_Practice_Guidance__c = 'Some more practice here',
                                                                   Domain__c = 'Care of Children'
    );
    insert bp;
    return bp;
  }

  public static Visit_Best_Practices__c mockVisitBestPractice(Inspection__c i, Standard_Best_Practices__c stdBP) {
    Visit_Best_Practices__c vbp = New Visit_Best_Practices__c(
                                                              Associated_Visit__c = i.Id,
                                                              Observation__c = 'Test observation',
                                                              Best_Practice__c = stdBP.Id
    );
    insert vbp;
    return vbp;
  }
}