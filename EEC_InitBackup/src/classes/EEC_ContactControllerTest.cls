@isTest
public class EEC_ContactControllerTest {
    
  public static testMethod void EEC_ContactControllerTest() {
      ApexPages.currentPage().getParameters().put('Id',EEC_TestUtil.mockContact().Id);
      User u = EEC_TestUtil.mockAccountWithUser();
      System.runAs(u){
          EEC_ContactController cc = new EEC_ContactController();
          String address = cc.getAddress();
          String otherAddress = cc.getOtherAddress();
          Boolean isSelf = cc.getIsSelf();
          Boolean isSelfC = cc.getIsSelfContactMode();
          ApexPages.currentPage().getParameters().put('selfContactMode',EEC_TestUtil.mockContact().Id);
          Boolean isCCSelf = cc.getIsSelfContactMode();
      }
  }
}