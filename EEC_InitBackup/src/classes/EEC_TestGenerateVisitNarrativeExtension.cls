@isTest
public with sharing class EEC_TestGenerateVisitNarrativeExtension {

    @isTest static void testGetCompliantWithObservations(){
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null, 'My observation'); 
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null, null); 
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Not Applicable', false, null, 'test'); 
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null, 'test 2'); 
        EEC_GenerateVisitNarrativePDFExtension ext = new EEC_GenerateVisitNarrativePDFExtension(new ApexPages.StandardController(i));
        
        List<EEC_GeneratePDFBase.VisitChecklistItemWrapper> l = ext.getCompliantWithObservations();
        
        System.assertEquals(2, l.size());
    }

    @isTest static void testGetProgramDirectorContactValid(){ 
        Account pa = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()); 
         
        Inspection__c i = EEC_TestUtil.mockInspection(pa);
        
        i = [SELECT Provider_No__r.Umbrella_Members__c FROM Inspection__c WHERE Id = :i.Id];
        
        Contact c = EEC_TestUtil.mockDirectorContact(pa);
        //AccountContactRole acr = EEC_TestUtil.mockAccountContactRole('Director', c, pa);
        EEC_GenerateVisitNarrativePDFExtension ext = new EEC_GenerateVisitNarrativePDFExtension(new ApexPages.StandardController(i));
        Contact result = ext.getDirectorContact();
        
        System.assertEquals(c.FirstName, result.FirstName);
        System.assertEquals(c.Id, result.Id);
    }

    @isTest static void testGetProgramDirectorContactInvalid(){ 
        Account pa = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());  
         
        Inspection__c i = EEC_TestUtil.mockInspection(pa);
        
        i = [SELECT Provider_No__r.Umbrella_Members__c,Mater_Visit_for_Res_Cluster_of_Visits__c FROM Inspection__c WHERE Id = :i.Id];
         
        EEC_GenerateVisitNarrativePDFExtension ext = new EEC_GenerateVisitNarrativePDFExtension(new ApexPages.StandardController(i));
        Contact result = ext.getDirectorContact();
        
        List<Inspection__c> insp = ext.getChildVisits();
        
        System.assertEquals(null, result ); 
    }


    @isTest static void testGetExecutiveDirectorContactValid(){ 
        Account pa = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Account ca = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity(), pa);
         
        Inspection__c i = EEC_TestUtil.mockInspection(ca);
        
        i = [SELECT Provider_No__r.Umbrella_Members__c FROM Inspection__c WHERE Id = :i.Id];
        
        System.debug('-----Inspection__c: ' + i);
        
        Contact c = EEC_TestUtil.mockContact();
        //AccountContactRole acr = EEC_TestUtil.mockAccountContactRole('Director', c, pa);
        EEC_GenerateVisitNarrativePDFExtension ext = new EEC_GenerateVisitNarrativePDFExtension(new ApexPages.StandardController(i));
        System.debug('Ext: ' + ext);
        Contact result = ext.getExecutiveDirectorContact();
        
        //System.assertEquals(c.FirstName, result.FirstName);
        //System.assertEquals(c.Id, result.Id);
    }

    @isTest static void testGetExecutiveDirectorContactInvalid(){ 
        Account pa = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()); 
         
        Inspection__c i = EEC_TestUtil.mockInspection(pa);
        
        i = [SELECT Provider_No__r.Umbrella_Members__c FROM Inspection__c WHERE Id = :i.Id];
        
        Contact c = EEC_TestUtil.mockContact();
        //AccountContactRole acr = EEC_TestUtil.mockAccountContactRole('Director', c, pa);
        EEC_GenerateVisitNarrativePDFExtension ext = new EEC_GenerateVisitNarrativePDFExtension(new ApexPages.StandardController(i));
        Contact result = ext.getExecutiveDirectorContact();
        
        System.assertEquals(null, result);
    }
}