@isTest
public class EEC_PortalNonCompliancePageTest {
    
  public static testMethod void testEEC_PortalNonCompliancePageController() {
    PageReference pr = Page.EEC_PortalNonCompliancePage;
    Test.setCurrentPage(pr);
    ID accountid;  
    
    Inspection__c insp = EEC_TestUtil.loadInspectionSetup(); 
    
    RecordType rType = [select Id from RecordType where SobjectType = 'Inspection_Item__c' and DeveloperName = 'Additional_Inspection_Item'];
    List<Inspection_Item__c> iItemList = [select Id,Inspection_No__r.Provider_No__c from Inspection_Item__c where Inspection_no__c = :insp.Id and RecordTypeId = :rType.Id];
    Inspection_Item__c iItem = iItemList.get(0);     
    accountid=insp.Provider_No__c;
    ApexPages.currentPage().getParameters().put('accountid',accountid);    
    EEC_PortalNonCompliancePageController ncomp = new EEC_PortalNonCompliancePageController();    
    ncomp = new EEC_PortalNonCompliancePageController();    
    Investigation__c inv = EEC_TestUtil.loadInvestigationSetup(); 
    Regulation__c reg =  EEC_TestUtil.mockRegulation();
    Non_Compliant__c nc = EEC_TestUtil.mockNonCompliant(inv);
    Non_Compliant_Item_Regulation__c ncr = EEC_TestUtil.mockNonCompliantItemRegulation(nc,reg);
    accountid=inv.Provider_No__c;
    ApexPages.currentPage().getParameters().put('accountid',accountid);    
    EEC_PortalNonCompliancePageController ncomp2 = new EEC_PortalNonCompliancePageController();    
    ncomp2 = new EEC_PortalNonCompliancePageController();
    
  }           
  
   static testMethod void testSaveInspectionItems() {
        //Account prov = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        //ApexPages.currentPage().getParameters().put('accountid',prov.Id);
        EEC_PortalNonCompliancePageController ncomp = new EEC_PortalNonCompliancePageController();
        //Inspection__c ins = EEC_TestUtil.mockInspection(prov);
        //Inspection_Item__c insItem = EEC_TestUtil.mockInspectionItem(ins, EEC_TestUtil.mockStdInspectionItem(), '', true, '');       
       
        
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        Inspection_Item__c inspItem = EEC_TestUtil.mockInspectionItem(insp, EEC_TestUtil.mockStdInspectionItem(), '', true, '');       
        Investigation__c inv = EEC_TestUtil.loadInvestigationSetup(); 
        Regulation__c reg =  EEC_TestUtil.mockRegulation();
        Non_Compliant__c nc = EEC_TestUtil.mockNonCompliant(inv);
        Non_Compliant_Item_Regulation__c ncr = EEC_TestUtil.mockNonCompliantItemRegulation(nc,reg);
       

        List<EEC_PortalNonCompliancePageController.InspectionListWrapper> iiWrapperList = new List<EEC_PortalNonCompliancePageController.InspectionListWrapper>();
        List<EEC_PortalNonCompliancePageController.ComplainceListWrapper> ncWrapperList = new List<EEC_PortalNonCompliancePageController.ComplainceListWrapper>();       
        
        // Create a new wrapper list for the controller.
        iiWrapperList = new List<EEC_PortalNonCompliancePageController.InspectionListWrapper>();
        ncWrapperList = new List<EEC_PortalNonCompliancePageController.ComplainceListWrapper>();
        
        // Create and add a new InspectionListWrapper.
        EEC_PortalNonCompliancePageController.InspectionListWrapper ilw = new EEC_PortalNonCompliancePageController.InspectionListWrapper(0, inspItem, null);
        iiWrapperList.add(ilw);
        EEC_PortalNonCompliancePageController.ComplainceListWrapper clw = new EEC_PortalNonCompliancePageController.ComplainceListWrapper(0, nc, null);
        ncWrapperList.add(clw);
       
        
 
        ncomp.iiWrapperList =iiWrapperList;
        ncomp.ncWrapperList =ncWrapperList;
        ncomp.Save();   
        ncomp.Cancel();  
       
  }
    
  static testMethod void testInspectionListWrapper() {
        new EEC_PortalNonCompliancePageController.InspectionListWrapper(0, new Inspection_Item__c(), null);
  } 
  
  
 
}