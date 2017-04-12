@isTest
public class EEC_UpdateInterventionControllerTest {
    
  public static testMethod void testEEC_UpdateInterventionController() {
    PageReference pr = Page.EEC_PortalProviderPage;
    Test.setCurrentPage(pr);
    ID accountid;
    Investigation__c  invest = EEC_TestUtil.loadInvestigationSetup();  
    Intervention__c inter = EEC_TestUtil.mockIntervention(invest); 
    ApexPages.currentPage().getParameters().put('id', inter.Id);
    EEC_UpdateInterventionController pinter = new EEC_UpdateInterventionController();   
    pinter = new EEC_UpdateInterventionController();   
    Attachment attachment = pinter.Attachment;    
    attachment.Name = 'Narrative-Investigation 123';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attachment.Body = bodyblob;
//    attachment.ParentId = inter.id;    
    pinter.upload();
    pinter.save();
    pinter.cancel();
    pinter.done();
     
    
  }  
  
}