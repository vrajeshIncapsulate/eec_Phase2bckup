@isTest
public class EEC_PortalInvestivationControllerTest {
    
  public static testMethod void testEEC_PortalInvestigationController() {
    PageReference pr = Page.EEC_PortalInvestigationPage;
    Test.setCurrentPage(pr);
    Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    Contact cont = EEC_TestUtil.mockDirectorContact(accnt);
    Investigation__c invest = mockInvestigation(accnt);
    User usr = EEC_TestUtil.mockPortalUser(cont);
    EEC_PortalInvestigationController piCtrl;
    System.runAs(usr){
    	piCtrl = new EEC_PortalInvestigationController();
    }
    
    EEC_PortalInvestivationControllerTest.loadInspectionSetup();
    
    Blob b = Blob.valueOf('Test');
    Attachment attachment = new Attachment(
      ParentId = invest.Id
    );
    attachment.Name = 'Narrative-Investigation 123';
    attachment.Body = b;
    insert attachment;
      
    ApexPages.currentPage().getParameters().put('id', invest.Id);
    piCtrl = new EEC_PortalInvestigationController();
    piCtrl.getVisits('1234');
    piCtrl.getNonCompliants('1234');
  }
    
 
  public static Investigation__c mockInvestigation(Account a) {
    Investigation__c i = new Investigation__c(Provider_No__c = a.Id);
    upsert i;
    return i;
  }  
    
  public static City__c mockCity(){
    City__c c = new City__c(
      Name = 'Testville',
      State__c = 'MA'
    );
    upsert c;
    return [Select Id From City__c Limit 1];
  }
    
  public static Inspection__c loadInspectionSetup(){
        RecordType r = [select Id, Name from RecordType where DeveloperName='FCC' and sobjecttype='Account'];
        System.debug('-----RecordTypeName: ' + r.Name);
        Account pAccount = new Account(
          name='TestProvider1',
          RecordTypeId=r.Id,
          Provider_Email__c='test@test.com',
          Provider_Address_1__c='123 Test St',
          Provider_City__c=EEC_PortalInvestivationControllerTest.mockCity().Id,
          Provider_Zip_Code__c='B3H0A2');
        insert pAccount;
        
        Inspection__c insp = new Inspection__c(Provider_No__c=pAccount.Id,Status__c='Scheduled', Date_of_Visit__c=date.today());
        insert insp;
        return insp;
  }
}