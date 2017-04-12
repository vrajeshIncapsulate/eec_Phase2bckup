/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class EEC_TestTransactionWizardController {

    static testMethod void TestIntroductionPage() {
        loadTestData(Page.EEC_TransactionIntroduction,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        List<String> buttonList = controller.getButtonList();
        System.assert(buttonList.size()>0);
        PageReference nextPageIntr = controller.callTransaction();
        System.assert(nextPageIntr.getUrl().contains('eec_transactioninstructions'));
        
        
    }
    
    static testMethod void TestInstructionPage() {
        Test.startTest();
        loadTestData(Page.EEC_TransactionIntroduction,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        PageReference nextPageIntr = controller.cancelInstruction();
        nextPageIntr = controller.previousInstruction();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_transactionintroduction'));
        nextPageIntr = controller.submitInstruction();
        Licensing_Transaction__c lt = [select Id,Status__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Status__c,'Submitted');
        PageReference nextPageIntr1 = controller.nextInstruction();
        lt = [select Id,Status__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Status__c,'To Submit');
        controller.getItems();
        controller.getHeatingElements();
        Test.stopTest();
    }
    
     static testMethod void TestTransactionProviderPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_TransactionProvider,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        //PageReference nextPageIntr = controller.nextInstruction();
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.saveAndNextTransactionProvider();
        List<Household_Member__c> hmList = [select Id from Household_Member__c where Licensing_Transactions__c = :controller.licenseTransation.Id];
        System.assert(hmList.size() == 1);
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_householdmembers'));
        nextPageIntr = controller.saveAndPreviousTransactionProvider();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_transactionintroduction'));
        System.assertEquals(lt.Last_Reached_Step__c,'Household Members');
        nextPageIntr = controller.saveAndReturnTransactionProvider();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        nextPageIntr = controller.CancelTransaction();
        lt = [select Id,status__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.status__c,'Cancelled');
        Test.stopTest();
     }
     
     
    static testMethod void TestHouseHoldPageNL() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_HouseholdMembers,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        controller.ihmList = EEC_TestUtil.mockHouseHold(lic, accnt);
        controller.addRow();
        
        controller.delRow();
        PageReference nextPageIntr = controller.SaveAndNextHH();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_licensestatuscapacityinfo'));
        System.assertEquals(lt.Last_Reached_Step__c,'License Status and Capacity / Assistant Information');
        nextPageIntr = controller.SaveAndPreviousHH();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Household Members');
        nextPageIntr = controller.SaveAndReturnHH();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        Test.stopTest();
    } 
    
    static testMethod void TestHouseHoldPageCA(){
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_HouseholdMembers,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'Change_of_Address';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'Change_of_Address');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.SaveAndNextHH();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_indoorspacepage'));
        System.assertEquals(lt.Last_Reached_Step__c,'Indoor / Outdoor space information');
    }
    static testMethod void TestTAPageRenewal() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_TechnicalAssistance,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_Renewal';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_Renewal');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.SaveAndNextTA();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Attachments');
        nextPageIntr = controller.SaveAndPreviousTA();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Daily Routing Activities / Technical Assistance');
        nextPageIntr = controller.SaveAndReturnTA();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        Test.stopTest();
    } 
    
    static testMethod void TestTAPageCA(){
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_TechnicalAssistance,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'Change_of_Address';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'Change_of_Address');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.SaveAndNextTA();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_reviewsummarysubmission'));
        System.assertEquals(lt.Last_Reached_Step__c,'Review Summary and Submission');
    }
    
    static testMethod void TestLSPageNL() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_LicenseStatusCapacityInfo,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        controller.faList = EEC_TestUtil.mockFCCAssistant(lic, accnt);
        controller.addRowLS();
        controller.delRowLS();
        PageReference nextPageIntr = controller.SaveAndNextLS();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_involvementexperience'));
        System.assertEquals(lt.Last_Reached_Step__c,'EEC Involvement Experience & Professional Exp.');
        nextPageIntr = controller.SaveAndPreviousLS();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'License Status and Capacity / Assistant Information');
        nextPageIntr = controller.SaveAndReturnLS();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        Test.stopTest();
    } 
    
    static testMethod void TestLSPageRenewal(){
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_LicenseStatusCapacityInfo,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_Renewal';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_Renewal');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.SaveAndNextLS();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_backgroundinformation'));
        System.assertEquals(lt.Last_Reached_Step__c,'Background Information');
    }
    
    static testMethod void TestEHPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_InvolvementExperience,'Apply for a New License','0');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        controller.addRowEH();
        controller.delRowEH();
        PageReference nextPageIntr = controller.SaveAndNextEH();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Background Information');
        nextPageIntr = controller.SaveAndPreviousEH();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'EEC Involvement Experience & Professional Exp.');
        nextPageIntr = controller.SaveAndReturnEH();
        Test.stopTest();
    }
    
    static testMethod void TestBIPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_BackgroundInformation,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_Renewal';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_Renewal');
        controller.licenseTransation = lic;
        PageReference nextPageIntr = controller.SaveAndNextBI();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Training Information');
        nextPageIntr = controller.SaveAndPreviousBI();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Background Information');
        nextPageIntr = controller.SaveAndReturnBI();
        Test.stopTest();
    }
    
    static testMethod void TestRoomPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_IndoorSpacePage,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        controller.roomList = EEC_TestUtil.mockRoom(lic);
        controller.selectedHestElems = new List<String>(); 
        controller.selectedHestElems.add('Background');
        controller.showCBDesc();
        controller.addRowRoom();
        controller.delRowRoom();
        PageReference nextPageIntr = controller.SaveAndNextRoom();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_technicalassistance'));
        System.assertEquals(lt.Last_Reached_Step__c,'Daily Routing Activities / Technical Assistance');
        nextPageIntr = controller.SaveAndPreviousRoom();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Indoor / Outdoor space information');
        nextPageIntr = controller.SaveAndReturnRoom();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        Test.stopTest();
    } 
    
    static testMethod void TestTEPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_TechnicalAssistance,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_Renewal');
        controller.licenseTransation = lic;
        controller.teList = EEC_TestUtil.mockTrainingExperience(lic);
        controller.addRowTE();
        controller.delRowTE();
        PageReference nextPageIntr = controller.SaveAndNextTE();
        Licensing_Transaction__c lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_indoorspacepage'));
        System.assertEquals(lt.Last_Reached_Step__c,'Indoor / Outdoor space information');
        nextPageIntr = controller.SaveAndPreviousTE();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Training Information');
        nextPageIntr = controller.SaveAndReturnTE();
        System.assert(nextPageIntr.getUrl().toLowerCase().contains('eec_portalproviderpage'));
        Test.stopTest();
    }
    /*static testMethod void TestReviewSummaryPage() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.licenseTransation = lic;
        controller.submitRS();
        Licensing_Transaction__c lt = [select Id,Status__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Status__c,'Submitted');
        controller.SaveAndReturnRS();
        lt = [select Id,Last_Reached_Step__c from Licensing_Transaction__c where Id = :controller.licenseTransation.Id];
        System.assertEquals(lt.Last_Reached_Step__c,'Review Summary and Submission');
        controller.previousRS();
    }*/
    static testMethod void TestLicenseTrans() {
        Test.startTest();
        Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for a New License','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_New_License';
        Licensing_Transaction__c lic = EEC_TestUtil.mockLicenseTransaction(accnt,'FCC_New_License');
        controller.getLicenseTrans(lic.Id);
    }
    
    static testMethod void testHMWrapper(){
    	Test.startTest();
        Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
        EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
        controller.LicenseRecordTypeName = 'FCC_Renewal';
        Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        Household_Member__c hm = [select Id from Household_Member__c where Licensing_Transactions__c = :lic.Id limit 1];
        controller.licenseTransation = lic;
        controller.MembersJson = '[{"Id":"'+hm.Id+'","First_Name":"Harry","Last_Name":"Potter","Date_of_Birth":"2015-06-28T00:00:00.000Z","Relationship_to_Provider":"baby","Occupation":"wizard","Number_of_Hours_Home_During_Child_Care":5,"Current_School_Grade":null,"Email_Address":null}]';
        controller.MembersToDeleteJson = '[{"Id":"'+hm.Id+'","First_Name":"Harry","Last_Name":"Potter","Date_of_Birth":"2015-06-28T00:00:00.000Z","Relationship_to_Provider":"baby","Occupation":"wizard","Number_of_Hours_Home_During_Child_Care":5,"Current_School_Grade":null,"Email_Address":null}]';
        controller.UpdateMembersList();
    }
    
    static Account loadTestData(PageReference lPageRef,String buttonLabel, String index){
        Account accnt = EEC_TestUtil.loadLicenseTransaction();
        PageReference pageRef = lPageRef;
        pageRef.getParameters().put('accountId',accnt.Id);
        pageRef.getParameters().put('buttonLabel',buttonLabel);
        pageRef.getParameters().put('index',index);
        Test.setCurrentPage(pageRef);
        EEC_TestUtil.mockAWSKeys();
        return accnt;
    }
    
    static testMethod void testGetWaterIsPrivate() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
      // False path.
      lic.Drinking_Water_Source__c = 'Town Water Supply';
      update lic;  
      System.assert(!controller.getWaterIsPrivate());
      // Success path.
      controller.selectedWaterStr = 'private water supply';
      System.assert(!controller.getWaterIsPrivate());
    }
    
    static testMethod void testGetHeatingConditionals() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        
      // Test the barricade section.
      controller.selectedHestStr = '';
      System.assert(!controller.getHeatingIsBarricaded());
      // Success path.
      controller.selectedHestElems = new List<String>{'Baseboards'};
      System.assert(!controller.getHeatingIsBarricaded());
        
      // Test the heating evidence section.  
      controller.selectedHestStr = null;
      System.assert(!controller.getHeatingEvidenceRequired());
      controller.selectedHestStr = 'Coal / Pellet / Wood Burning Stove';
      System.assert(controller.getHeatingEvidenceRequired());
    }
    
    static testMethod void testGetRoomTableVisibility() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
      
      controller.roomList = new List<Room__c>();
      System.assert(!controller.getRoomTableVisibility());
      controller.addRowRoom();
      System.assert(controller.getRoomTableVisibility());
    }
    
    static testMethod void testGenerateMultiplePolicySignature() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        
      // Test method.
      String exampleJson = '[{"filename": "testName", "type": "image/png"}]'; 
        
      List<Map<String,String>> result = EEC_TransactionWizardController.generateMultiplePolicySignature('eec', 'authenticated-read', exampleJson);
      System.assertNotEquals(0, result.size());
      System.assertNotEquals(null, result.get(0).get('policy'));  
      System.assertNotEquals(null, result.get(0).get('signature'));
    }
    
    static testMethod void testDeleteAttachment() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        
      // Test Method
      S3_File__c file = new S3_File__c(
        Filename__c = 'testFile',
        Content_Type__c = 'image/png',
        Bucket__c = 'test',
        Acl__c = 'authenticated-read',
        Prefix__c = lic.Id
      ); 
      insert file;  
        
      FileMap__c fileMap = new FileMap__c(
        Object_Id__c = lic.Id,
        Object_Name__c = 'Licensing_Transaction__c',
        S3_File__c = file.Id
      );
      insert fileMap;
      
      controller.licenseTransation = lic;
      controller.fileToDelete = 'testFile';
      controller.refreshAttachmentsList();
      controller.deleteAttachment();  
    }
    
    static testMethod void testGetExistingItems() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
      
      // Test Method.
      System.assert(!controller.getRenderExistingWaterAttachment()); 
      System.assert(!controller.getRenderExistingHeatingAttachment());
      System.assert(!controller.getRenderExistingMedicationAttachment());
      System.assert(!controller.getRenderExistingTransportationAttachment());
      System.assert(!controller.getRenderExistingSidsAttachment());
      System.assert(!controller.getRenderExistingUsdaAttachment());
      System.assert(!controller.getRenderExistingUpgradeAttachment());
      System.assert(!controller.getRenderExistingOrientationAttachment());
      System.assert(!controller.getRenderExistingCprAttachment());
      System.assert(!controller.getRenderExistingFirstAidAttachment());
    }
    
    static testMethod void testSaveAttachmentsFromJson() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        
      String attachmentsJson = '[{"Filename__c": "TestFile", "Prefix__c": "12345", "Content_Type__c": "image/png", "Acl__c": "authenticated-read", "Bucket__c": "test"}]';
      controller.indoorAttachmentsJson = attachmentsJson;
      controller.saveAttachmentsFromJson();
      controller.saveAllAttachmentsFromJson();
      controller.saveTrainingAttachmentsFromJson();
    }
    
    static testMethod void testGetAttachmentSpotlightText() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1]; 
        
      controller.getAttachmentSpotlightText();
      controller.licenseRecordTypeName = 'FCC_New_License';
      controller.getAttachmentSpotlightText();
      controller.licenseRecordTypeName = 'FCC_License_Upgrade';  
      controller.getAttachmentSpotlightText();
    }
    
    static testMethod void testGetCityOptions() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1]; 
        
      System.assertEquals(2, (controller.getCityOptions()).size());        
    }
    
    static testMethod void testSaveFileDescription() {
      Test.startTest();
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];   
      // Test Method
      S3_File__c file = new S3_File__c(
        Filename__c = 'testFile',
        Content_Type__c = 'image/png',
        Bucket__c = 'test',
        Acl__c = 'authenticated-read',
        Prefix__c = lic.Id,
        Description__c = 'Description!'
      ); 
      insert file;    
      System.assertEquals('Description!', file.Description__c);
       
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      controller.fileToEditId = file.Id;
      controller.fileToEditDescription = 'A new description';
      controller.saveFileDescription();
        
      file = [Select Description__c From S3_File__c Where Id = :file.Id];
      System.assertEquals('A new description', file.Description__c);        
    }
}