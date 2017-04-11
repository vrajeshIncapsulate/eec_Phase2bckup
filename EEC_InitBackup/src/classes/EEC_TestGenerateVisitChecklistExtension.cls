@isTest 
public with sharing class EEC_TestGenerateVisitChecklistExtension  {
  
    @isTest static void testVisitChecklistItemWrapperConstruct(){
        Inspection_Item__c i = new Inspection_Item__c();
        String s = 'test';
        
        EEC_GeneratePDFBase.VisitChecklistItemWrapper vciwc = new 
        EEC_GeneratePDFBase.VisitChecklistItemWrapper (i, s);
        
        System.assertEquals(vciwc.inspectionItem, i);
        System.assertEquals(vciwc.standardRegulations, s);
    }
    
    
    @isTest static void testAugmentStandardInspectionItems(){  
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c sii1 = EEC_TestUtil.mockStdInspectionItem();
        
        Regulation__c reg1 = EEC_TestUtil.mockRegulation();
        Regulation__c reg2 = EEC_TestUtil.mockRegulation();
        EEC_TestUtil.mockRegStdInsp(reg1, sii1);
        EEC_TestUtil.mockRegStdInsp(reg2, sii1);
        
        Inspection_Item__c ii1 = EEC_TestUtil.mockInspectionItem(i, sii1 , 'Non-Compliant', false, null);
        Inspection_Item__c ii2 = EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation() , 'Non-Compliant', false, null);
        List<EEC_GeneratePDFBase.VisitChecklistItemWrapper> l = EEC_GeneratePDFBase.augmentStandardInspectionItems(new List<Inspection_Item__c>{ii1, ii2});
        
        System.assertEquals(2, l.size());
        System.assertEquals(reg1.Name + ', ' + reg2.Name, l.get(0).standardRegulations);
        System.assertEquals('', l.get(1).standardRegulations);

    
    }

    @isTest static void testGetAssessedStandardInspectionItems(){ 
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null);
        EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));
        
        List<EEC_GeneratePDFBase.VisitChecklistItemWrapper> l = ext.getAssessedStandardInspectionItems();
        System.assertEquals(1, l.size());
    }


    @isTest static void testGetUnassessedStandardInspectionItems(){
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), null, true, null);
        EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));
        
        List<EEC_GeneratePDFBase.VisitChecklistItemWrapper> l = ext.getUnassessedStandardInspectionItems();
        System.assertEquals(1, l.size());
        
    }

    @isTest static void testGetAdditionalInspectionItems() {
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        Regulation__c reg = EEC_TestUtil.mockRegulation(); 
        //EEC_TestUtil.mockInspectionItem(i, reg, 'Non-Compliant', false, null);
        //EEC_TestUtil.mockInspectionItem(i, reg, 'Non-Compliant', false, 'HJelp');
        //EEC_TestUtil.mockInspectionItem(i, reg, null, true, null);
        EEC_TestUtil.mockInspectionItem(i, stdIi, 'Non-Compliant', false, null);
        EEC_TestUtil.mockInspectionItem(i, stdIi, 'Non-Compliant', false, 'Helo');
        EEC_TestUtil.mockInspectionItem(i, stdIi, null, true, null);
        EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));
        
        List<EEC_GeneratePDFBase.VisitChecklistItemWrapper> l = ext.getAdditionalInspectionItems();
        
        System.assertEquals(1, l.size(), 1);
    }
    
    @isTest static void testGetHasNonCompliantTrue() {
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null); 
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null); 
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Not Applicable', false, null); 
        EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));
         
        System.assertEquals(true, ext.getHasNonCompliant());
    }
    @isTest static void testGetHasNonCompliantFalse() {
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null); 
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Not Applicable', false, null); 
        EEC_GenerateVisitChecklistExtension ext = new EEC_GenerateVisitChecklistExtension(new ApexPages.StandardController(i));
         
        System.assertEquals(false, ext.getHasNonCompliant());
    }

}