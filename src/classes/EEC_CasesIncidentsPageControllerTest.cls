@isTest
public class EEC_CasesIncidentsPageControllerTest {
    public static EEC_CasesIncidentsPageController testSetup() { 
      EEC_TestUtil.mockAWSKeys(); 
      RecordType r = [select Id from RecordType where DeveloperName='FCC' and sobjecttype='Account'];
        
      User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
      Account accnt;
      Contact con;  
      System.runAs( thisUser ) { 
          City__c city = EEC_TestUtil.mockCity();
		  accnt = EEC_TestUtil.mockProvider(city);
		  con = EEC_TestUtil.mockDirectorContact(accnt);  
      }
      //City__c city = [SELECT Id FROM City__c Limit 1];  
      User u = EEC_PortalLandingControllerTest.mockuser(con);
      EEC_CasesIncidentsPageController ctrl;
      
      System.runas(u){
        ctrl = new EEC_CasesIncidentsPageController();  
      }
      return ctrl;
    }
    
    public static testMethod void testConstructorAndTriageEmail() {
      Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
      Contact con = EEC_TestUtil.mockDirectorContact(accnt);  
      Case c = EEC_TestUtil.mockCase(accnt, con); 
        
      Test.startTest();
      c.SendCaseTriageEmail__c = 'Recalled';
      c.TriggerTriageEscalationApproval__C = true;
      update c;
      Test.stopTest();  
    }
    
    public static testMethod void testConstructorWithParams() {
      EEC_TestUtil.mockAWSKeys();
      Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
      Contact con = EEC_TestUtil.mockDirectorContact(accnt);  
      Case c = EEC_TestUtil.mockCase(accnt, con); 
      System.currentPageReference().getParameters().put('mode', 'edit');
      System.currentPageReference().getParameters().put('id', c.Id);  
      Test.startTest();
      EEC_CasesIncidentsPageController ctrl = new EEC_CasesIncidentsPageController();  
      
      System.assert(ctrl.editViewMode);
      System.assertNotEquals(null, ctrl.c);
      
      // Test submitReturn
      PageReference returnPage = page.EEC_PortalProviderPage;
      //returnPage.getParameters().put('accountId', ctrl.a.Id);
      System.assertEquals(returnPage.getUrl(),ctrl.submitReturn().getUrl());  
      c = [Select Status From Case Where Id = :c.Id];
      System.assertEquals('New', c.Status);
      
      // Test deleteReturn.
      System.assertEquals(returnPage.getUrl(),ctrl.deleteReturn().getUrl());  
      Test.stopTest();
      List<Case> availableCases = [Select Id From Case Where Id = :c.Id];
      System.assertEquals(0, availableCases.size());
    }
    
    public static testMethod void testGettersSetters() {
      EEC_CasesIncidentsPageController ctrl = EEC_CasesIncidentsPageControllerTest.testSetup();  
      System.assert(!ctrl.blnCalled911);
      System.assert(!ctrl.blnFirstAidCPR);
      System.assert(!ctrl.blnCPR);
      System.assert(!ctrl.blnChildTransport);
      System.assert(!ctrl.blnChildReturned);
      System.assert(!ctrl.blnSharedParents);
      System.assert(!ctrl.blnFiledDCF);
      System.assert(!ctrl.blnLegal);
      ctrl.nextStageIncident();  
      ctrl.nextStageInjury();  
    }
    
    public static testMethod void testEditIncident() {
      EEC_CasesIncidentsPageController ctrl = EEC_CasesIncidentsPageControllerTest.testSetup();  
      ctrl.editIncident();
      System.assert(ctrl.editMode);
      System.assert(!ctrl.editViewMode);
      System.assertEquals(new List<S3_File__c>(), ctrl.attachments);
    }
    
    public static testMethod void testViewIncident() {
      EEC_CasesIncidentsPageController ctrl = EEC_CasesIncidentsPageControllerTest.testSetup();  
      ctrl.viewIncident();
      System.assert(!ctrl.editMode);
      System.assert(ctrl.editViewMode);
      System.assertEquals(new List<S3_File__c>(), ctrl.attachments); 
    }
    
    public static testMethod void testPersonMethods() {
      // AddPerson
      EEC_CasesIncidentsPageController ctrl = EEC_CasesIncidentsPageControllerTest.testSetup();  
      ctrl.addPerson();
      System.assertEquals(1, ctrl.InvolvedPersons.size());
        
      // DelPerson  
      System.currentPageReference().getParameters().put('index', '0');
      ctrl.delPerson();
      System.assertEquals(0, ctrl.InvolvedPersons.size());
        
      // Get all persons.
      System.assertNotEquals(null, ctrl.getInvolvedPersons().size());
        
      Portal_Util.InvolvedPerson_Wrapper p = new Portal_Util.InvolvedPerson_Wrapper();
      p.Type = 'Child Involvement';   // Default value
      ctrl.InvolvedPersons.add(p);
      // Save the person list.
      ctrl.saveButtonType = 'next';
      ctrl.save();
        
      Map<String, Id> RecordTypeIds = new Map<String, Id>();
      Map<Id, String> RecordTypeNames = new Map<Id, String>();
      for (RecordType rt : [SELECT Id,Name FROM RecordType WHERE sObjectType='Involved_Persons__c' ORDER BY Name ASC]) {
        RecordTypeIds.put(rt.Name,rt.Id);
        RecordTypeNames.put(rt.Id,rt.Name);
      }   
      
      List<Involved_Persons__c> personsList = Portal_Util.fromWrapper(ctrl.c.Id,ctrl.InvolvedPersons,RecordTypeIds);
      System.assert(personsList.size() == 1);
      System.debug('-----> Persons List: ' + personsList);
        
      Portal_Util.InvolvedPerson_Wrapper p2 = new Portal_Util.InvolvedPerson_Wrapper();
      p2.Type = 'Child Involvement';   // Default value
      ctrl.InvolvedPersons.add(p2);
      // Call the method again to test the > 0 path.
      personsList = Portal_Util.fromWrapper(ctrl.c.Id,ctrl.InvolvedPersons,RecordTypeIds);
      System.assert(personsList.size() == 2);  
        
      List<Portal_Util.InvolvedPerson_Wrapper> persons = Portal_Util.fetchInvolvedPersons(ctrl.c.Id, RecordTypeNames);  
      //System.assertEquals(1, persons.size());
      System.assert(Portal_Util.deleteInvolvedPersons(persons));
    }
    
    public static testMethod void testGetPersonTypes() {
      EEC_CasesIncidentsPageController ctrl = EEC_CasesIncidentsPageControllerTest.testSetup();  
      System.assertNotEquals(null, ctrl.getPersonTypes());
    }
    
    public static testMethod void testGetPersonRoles() {
      EEC_CasesIncidentsPageController ctrl = EEC_CasesIncidentsPageControllerTest.testSetup();  
      System.assertEquals(Portal_Util.getPicklistValues(new Involved_Persons__c(), 'Role__c'), ctrl.getPersonRoles());
    }
    
    public static testMethod void testSave() {
      EEC_CasesIncidentsPageController ctrl = EEC_CasesIncidentsPageControllerTest.testSetup(); 
        
      System.assertEquals(null, ctrl.save());
        
      // Test button flows. Save and Previous return null so no sense in asserting.
      //ctrl.saveButtonType = 'previous';
      //ctrl.save();  
      //ctrl.saveButtonType = 'next';
      //ctrl.save();
        
      // Test return page reference flow.
      ctrl.saveButtonType = 'return';
      PageReference returnPage = page.EEC_PortalProviderPage;
      //returnPage.getParameters().put('accountId', ctrl.a.Id);
      //System.assertEquals(returnPage.getUrl(), ctrl.save().getUrl());
    }
    
    public static testMethod void testButtonMethods() {
      EEC_CasesIncidentsPageController ctrl = EEC_CasesIncidentsPageControllerTest.testSetup(); 
      ctrl.nextStage();
      ctrl.nextStage();
      ctrl.nextStage();
      ctrl.prevStage();
      ctrl.prevStage();
      ctrl.prevStage();
    }
    
    public static testMethod void testAttachmentMethods() {
      EEC_CasesIncidentsPageController ctrl = EEC_CasesIncidentsPageControllerTest.testSetup(); 
      EEC_WebServiceMock mockCallout = new EEC_WebServiceMock();
      mockCallout.objectClassName = 'S3.DeleteObjectResponse_element';
      Test.setMock(WebServiceMock.class, mockCallout);
      Test.startTest();  
      String attachmentsJson = '[{"Filename__c": "TestFile", "Prefix__c": "12345", "Content_Type__c": "image/png", "Acl__c": "authenticated-read", "Bucket__c": "test"}]';
      ctrl.attachmentsJson = attachmentsJson;
      ctrl.saveAttachmentsFromJson();
      ctrl.refreshIncidentAttachments();
        
      Case c = EEC_TestUtil.mockCase(ctrl.a, ctrl.ct);
      
      S3_File__c file = new S3_File__c(
        Filename__c = 'testFile',
        Content_Type__c = 'image/png',
        Bucket__c = 'test',
        Acl__c = 'authenticated-read',
        Prefix__c = c.Id
      ); 
      insert file;  
        
      FileMap__c fileMap = new FileMap__c(
        Object_Id__c = c.Id,
        Object_Name__c = String.valueOf(ctrl.c.getSObjectType()),
        S3_File__c = file.Id
      );
      insert fileMap;
      Test.stopTest(); 
      // Test generateMultiplePolicySignature  
      String exampleJson = '[{"filename": "testName", "type": "image/png"}]'; 
      List<Map<String,String>> result = EEC_CasesIncidentsPageController.generateMultiplePolicySignature('eec', 'authenticated-read', exampleJson);
      System.assertNotEquals(0, result.size());
      System.assertNotEquals(null, result.get(0).get('policy'));  
      System.assertNotEquals(null, result.get(0).get('signature'));
      
      // Test DeleteAttachment
      ctrl.c = c;
      ctrl.fileToDelete = file.Id;
      ctrl.refreshIncidentAttachments();
      ctrl.deleteAttachment();
    }
}