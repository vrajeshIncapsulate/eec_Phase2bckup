@isTest
public class EEC_RegulationViewControllerTest {
    
  public static testMethod void testEEC_RegulationViewController() {
    PageReference pr = Page.EEC_RegulationView;
    Test.setCurrentPage(pr);
    EEC_RegulationViewController regCtrl = new EEC_RegulationViewController();   
    Regulation__c reg = EEC_TestUtil.mockRegulation();
      
    ApexPages.currentPage().getParameters().put('id',reg.id);
    regCtrl = new EEC_RegulationViewController();
    regCtrl.getchildregs();
  }  
  
}