@isTest
public class EEC_ReportGeneration_OneExtensionTest { 
  public static testmethod void testProcessNaraitiveDefault() {
    Test.startTest();
    Account provider = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
      
    Inspection__c i = EEC_TestUtil.mockInspection(provider);
    //Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 
	System.debug('Test Provider Id' + i.Provider_No__c);
    EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
    //ext.processNaraitiveDefault();
    //System.assertEquals('This functionality is only available if the visit is in status "Visit Completed" or "Report to be sent to Provider"', ext.toastMsg);

    i.Status__c = 'Visit Completed';
    i.Inspector_del__c = UserInfo.getUserId();  
    update i;

    ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
    ext.processNaraitiveDefault();

    Test.stopTest();
  } 
  public static testmethod void testProcessNaraitiveDefaultWithUmbrella() {
    Test.startTest();
    Account provider = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
    Account umbrella = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC');
      
    Contact director = EEC_TestUtil.mockContact(provider, 'firstName', 'lastName', 'Director');
    //Contact mainContact = EEC_TestUtil.mockContact(provider, 'firstName', 'lastName', 'Main Contact / Licensee');  
      
    umbrella.Umbrella_Members__c = provider.Id;
    update provider;  
      
    Inspection__c i = EEC_TestUtil.mockInspection(umbrella);
    //Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 
	System.debug('Test Provider Id' + i.Provider_No__c);
    EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
    //ext.processNaraitiveDefault();
    //System.assertEquals('This functionality is only available if the visit is in status "Visit Completed" or "Report to be sent to Provider"', ext.toastMsg);

    i.Status__c = 'Visit Completed';
    i.Inspector_del__c = UserInfo.getUserId();  
    update i;

    ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
    ext.processNaraitiveDefault();

    Test.stopTest();
  }   
 
  public static testmethod void testGenerateAllReports() {
    Test.startTest();

    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 

    Test.setCurrentPageReference(new PageReference('EEC_ReportGeneration_One')); 
    System.currentPageReference().getParameters().put('reportType', 'nc');

    EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
    ext.generateAllReports();
    System.assertEquals('Report Narrative can only be generated if the Visit is Completed, and not Closed', ext.toastMsg);

    i.Status__c = 'Visit Completed';
    update i;
    
    ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
    ext.generateAllReports();
    System.assertEquals('This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director', ext.toastMsg);

    Test.stopTest();  
  } 
  public static testmethod void testGenerateChecklistReports() {
    Test.startTest();

    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 

    i.Status__c = 'Visit Completed';
    update i;
      
    EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));  
      
    Test.setCurrentPageReference(new PageReference('EEC_ReportGeneration_One')); 
    System.currentPageReference().getParameters().put('reportType', 'checklist');
    ext.generateAllReports();
    System.assertEquals('Visit Summary generated. See Notes and Attachments to view the report.', ext.toastMsg);
  
      
    Test.stopTest();    
  }
  
  public static testmethod void testGenerateNarrativeReports() {
    Test.startTest();

    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 

    i.Status__c = 'Visit Completed';
    update i;
      
    EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));  
      
    Test.setCurrentPageReference(new PageReference('EEC_ReportGeneration_One')); 
    System.currentPageReference().getParameters().put('reportType', 'narrative');
    ext.generateAllReports();
    System.assertEquals('Visit Narrative generated. See Notes and Attachments to view the report.', ext.toastMsg);
  
      
    Test.stopTest(); 
  }
    
  public static testmethod void testGenerateCoverLetterReports() {
      
    Test.startTest();

    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 

    i.Status__c = 'Visit Completed';
    update i;
      
    EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));  
      
    Test.setCurrentPageReference(new PageReference('EEC_ReportGeneration_One')); 
    System.currentPageReference().getParameters().put('reportType', 'coverletter');
    ext.generateAllReports();
    System.assertEquals('Cover Letter generated. See Notes and Attachments to view the report.', ext.toastMsg);
  
      
    Test.stopTest();  
      
  }  

  public static testmethod void testPublishReportOnPortal() {
    Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(),'Test User','Fake Adres 123','FCC'));
    EEC_ReportGeneration_OneExtension ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));

    Test.startTest();
    ext.publishReportOnPortal();
    System.assertEquals('This provider does not use electronic communication', ext.toastMsg);

    /*
    Account acc = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    acc.Electronic_Communication__c = true;
    update acc;
    acc = [Select Id, Electronic_Communication__c From Account Where Id = :acc.Id];
    i = EEC_TestUtil.mockInspection(acc);
    ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
    ext.publishReportOnPortal();    
    System.assertEquals('Checklist Summary or Visit Narrative has not been issued.Please generate one of these reports before publishing.', ext.toastMsg);

    i.Checklist_Summary_issue_date__c = Date.today();
    i.Visit_Narrative_Issue_Date__c = Date.today();
    update i;
    ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
    ext.publishReportOnPortal();
    System.assertEquals('Visit has been published to the web.', ext.toastMsg);

    ext = new EEC_ReportGeneration_OneExtension(new ApexPages.StandardController(i));
    ext.publishReportOnPortal();
    System.assertEquals('This visit has already been published.', ext.toastMsg);
    */
  } 
}