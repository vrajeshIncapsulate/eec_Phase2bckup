@isTest 
public class EEC_VisitToolSelectionControllerTest {

  static testMethod void TestCopyStandardInspectionItems() {
    Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
    insp.Type_of_Visit__c = 'Pre-Licensing';
    update insp;
    insp = [SELECT Id, Provider_No__c,Visit_Tool_Used__c, Provider_No__r.RecordType.Name, 
            Can_be_edited__c, Mater_Visit_for_Res_Cluster_of_Visits__c, Type_of_Visit__c 
            FROM Inspection__c 
            WHERE Id = :insp.Id];
    ApexPages.StandardController sc = new ApexPages.StandardController(insp);
    EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);
     
    visitToolCtrl.populateLists();
    visitToolCtrl.recommendedTool = [SELECT Id, Name, No_of_Random_Items_Per_Domain_to_Pick__c
                                     FROM Standard_Checklist_Reference__c limit 1];
    for (EEC_VisitToolSelectionController.SCRWrapper scrw : visitToolCtrl.scrWrapperList) {
      scrw.selected = true;
    }
    visitToolCtrl.copyInspectionItems();
    /*visitToolCtrl.selectedTool = 'FCC Enhanced Monitoring Tool';
    visitToolCtrl.justificationText = 'test justification';*/
    visitToolCtrl.switchTool();
    System.debug('***UnitTest*** Switch tool done');
  }

  static testMethod void testIsItemAtRisk() {
    Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
    ApexPages.StandardController sc = new ApexPages.StandardController(insp);
    EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);

    List<Inspection_Item__c> inspItem = [Select Id, Name, Inspection_No__r.Provider_No__r.Is_R_P__c, Inspection_No__r.Provider_No__r.Is_GSA__c, Inspection_No__r.Provider_No__r.Record_Type_Name__c, Associated_regulation__r.R_P_High_Risk_Reg__c, Associated_regulation__r.GSA_High_Risk_Reg__c, Associated_regulation__r.FCC_High_Risk_Reg__c From Inspection_Item__c Where Inspection_No__c = :insp.Id];
    System.assertEquals(visitToolCtrl.isItemAtRisk(inspItem[0], null), inspItem[0].Associated_regulation__r.FCC_High_Risk_Reg__c);
  }
    
  static testMethod void testIsNCItemAtRisk() {
    Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
    Investigation__c invest = EEC_TestUtil.loadInvestigationSetup();
    ApexPages.StandardController sc = new ApexPages.StandardController(insp);
    EEC_VisitToolSelectionController visitToolCtrl = new EEC_VisitToolSelectionController(sc);
      
    Non_Compliant__c ncItem = EEC_TestUtil.mockNonCompliant(invest);
    Regulation__c reg = EEC_TestUtil.mockRegulation();  
    Non_Compliant_Item_Regulation__c ncItemReg = EEC_TestUtil.mockNonCompliantItemRegulation(ncItem, reg);
      
    System.assertEquals(visitToolCtrl.isNCItemAtRisk(ncItem, ncItemReg), false);  
  }
}