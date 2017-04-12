@isTest
public class EEC_BaseAttachmentsExtensionTest {
    
  public static void loadMock() {
    EEC_WebServiceMock mockCallout = new EEC_WebServiceMock();
    mockCallout.objectClassName = 'S3.DeleteObjectResponse_element';
    Test.setMock(WebServiceMock.class, mockCallout);
  }
    
  static testMethod void testAttachmentsExtensions() {
      EEC_TestUtil.mockAWSKeys();
      EEC_BaseAttachmentsExtensionTest.loadMock();
      
      Case c = EEC_TestUtil.mockCase(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()), EEC_TestUtil.mockContact());
      ApexPages.currentPage().getParameters().put('id', c.Id);
      ApexPages.StandardController std = new ApexPages.StandardController(c);
      Test.startTest();
      EEC_IncidentsAttachmentsExtension incidentController = new EEC_IncidentsAttachmentsExtension(std);
      
      // Test Method
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
        Object_Name__c = 'Licensing_Transaction__c',
        S3_File__c = file.Id
      );
      insert fileMap;
      
      incidentController.refreshAttachmentsList();
      Test.stopTest();
      System.assertNotEquals(null, incidentController.genetateS3Link(file.Id));
      incidentController.deleteAttachment(file.Filename__c);
      System.assertEquals(new List<S3_File__c>(), [Select Id From S3_File__c Where Id = :file.Id]);
      System.assertEquals(incidentController, incidentController.getCtrlInstance());
    }
    
    static testMethod void testLicenseAttachments() {
      EEC_BaseAttachmentsExtensionTest.loadMock();
      
      Account accnt = loadTestData(Page.EEC_ReviewSummarySubmission,'Apply for License Renewal','1');
      EEC_TransactionWizardController controller = new EEC_TransactionWizardController();
      controller.LicenseRecordTypeName = 'FCC_Renewal';
      Licensing_Transaction__c lic = [select Id from Licensing_Transaction__c where Provider__c = :accnt.Id limit 1];
        
      ApexPages.currentPage().getParameters().put('id', lic.Id);
      ApexPages.StandardController std = new ApexPages.StandardController(lic);  
        
      EEC_LicenseAttachmentsExtension licenseCtrl = new EEC_LicenseAttachmentsExtension(std);  
      Test.startTest();  
      // Test Method
      S3_File__c file = new S3_File__c(
        Filename__c = 'testFile',
        Content_Type__c = 'image/png',
        Bucket__c = 'test',
        Acl__c = 'authenticated-read',
        Prefix__c = lic.Id
      ); 
      insert file;  
        
      S3_File__c file2 = new S3_File__c(
        Filename__c = 'testFile2',
        Content_Type__c = 'image/png',
        Bucket__c = 'test',
        Acl__c = 'authenticated-read',
        Prefix__c = lic.Id
      ); 
      insert file2;  
        
      FileMap__c fileMap = new FileMap__c(
        Object_Id__c = lic.Id,
        Object_Name__c = 'Licensing_Transaction__c',
        S3_File__c = file.Id
      );
      insert fileMap;  
        
      FileMap__c fileMap2 = new FileMap__c(
        Object_Id__c = lic.Id,
        Object_Name__c = 'Licensing_Transaction__c',
        S3_File__c = file2.Id
      );
      insert fileMap2;    
        
      licenseCtrl.refreshAttachmentsList();
      Test.stopTest();
      System.assertNotEquals(null, licenseCtrl.genetateS3Link(file.Id));
      licenseCtrl.deleteAttachment(file.Filename__c);
      System.assertEquals(new List<S3_File__c>(), [Select Id From S3_File__c Where Id = :file.Id]);  
      System.assertEquals(licenseCtrl, licenseCtrl.getCtrlInstance());
      EEC_BaseAttachmentsExtensionTest.testReadOnlyAttachmentCtrl(licenseCtrl, file2);
    }
    
    static void testReadOnlyAttachmentCtrl(AttachActionInterface aif, S3_File__c file) {
      EEC_ReadOnlyAttachmentsCtrl ctrl = new EEC_ReadOnlyAttachmentsCtrl();
      ctrl.aif = aif;
      ctrl.fileToDelete = file.Filename__c;
      ctrl.generateFileId = file.Id;
      ctrl.attachmentsJson = '[{"Filename__c": "TestFile", "Prefix__c": "12345", "Content_Type__c": "image/png", "Acl__c": "authenticated-read", "Bucket__c": "test"}]';
      
      ctrl.genetateS3Link();
      ctrl.deleteAttachment();
      ctrl.saveAttachmentsFromJson();
        
      // Test generateMultiplePolicySignature  
      String exampleJson = '[{"filename": "testName", "type": "image/png"}]'; 
      List<Map<String,String>> result = EEC_ReadOnlyAttachmentsCtrl.generateMultiplePolicySignature('eec', 'authenticated-read', exampleJson);
      System.assertNotEquals(0, result.size());
      System.assertNotEquals(null, result.get(0).get('policy'));  
      System.assertNotEquals(null, result.get(0).get('signature'));
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
}