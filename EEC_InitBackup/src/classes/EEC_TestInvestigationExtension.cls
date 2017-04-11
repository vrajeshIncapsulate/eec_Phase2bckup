@isTest
public with sharing class EEC_TestInvestigationExtension {

    @isTest static void testGetDirectorContact(){
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Contact c = EEC_TestUtil.mockDirectorContact(a);
        //AccountContactRole acr = EEC_TestUtil.mockAccountContactRole('Director', c, a);
        Investigation__c i = EEC_TestUtil.mockInvestigation(a);
        EEC_GenerateInvCoverLetterExtension cnt = new EEC_GenerateInvCoverLetterExtension(new ApexPages.StandardController(i));
        
        Contact co = cnt.getDirectorContact();
        System.assertEquals(c.FirstName, co.FirstName);
        System.assertEquals(c.LastName, co.LastName);
        System.assertEquals(c.Salutation, co.Salutation); 
    }
    
    /*@isTest static void testGetCaseNumbers(){ 
         Test.startTest();

        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Contact co = EEC_TestUtil.mockContact();
        
        Case ca1 = EEC_TestUtil.mockCase(a, co);
        Case ca2 = EEC_TestUtil.mockCase(a, co);
        ca1 = [SELECT CaseNumber FROM Case WHERE Id = :ca1.Id];
        ca2 = [SELECT CaseNumber FROM Case WHERE Id = :ca2.Id];
        
        Investigation__c i = EEC_TestUtil.mockInvestigation(a);
        
        ca1.Investigation__c = i.Id; 
        ca2.Investigation__c = i.Id; 
 
        upsert ca1;
        upsert ca2;
 
        EEC_GenerateInvCoverLetterExtension cnt = new EEC_GenerateInvCoverLetterExtension(new ApexPages.StandardController(i));
        
        String result = cnt.getCaseNumbers();
        System.assert(result.contains(ca1.CaseNumber));
        System.assert(result.contains(ca2.CaseNumber));
        Test.stopTest();

    }*/
    
    @isTest static void testGetNonCompliantItems(){ 
        Investigation__c i = EEC_TestUtil.mockInvestigation(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Non_Compliant__c nc1 = EEC_TestUtil.mockNonCompliant(i);
        Non_Compliant__c nc2 = EEC_TestUtil.mockNonCompliant(i);
        
        Regulation__c r1 = EEC_TestUtil.mockRegulation();
        Regulation__c r2 = EEC_TestUtil.mockRegulation();
        
        EEC_TestUtil.mockNonCompliantItemRegulation(nc1, r1);
        EEC_TestUtil.mockNonCompliantItemRegulation(nc1, r2);
        EEC_TestUtil.mockNonCompliantItemRegulation(nc2, r1);
        
        EEC_GenerateInvCoverLetterExtension cnt = new EEC_GenerateInvCoverLetterExtension(new ApexPages.StandardController(i));
        
        List<EEC_GenerateInvestigationPDFBase.InvestigationVisitChecklistItemWrapper> result = cnt.getNonCompliantItems();
        System.assertEquals(2, result.size());
        System.assert(result.get(0).standardRegulations.contains(r1.Name));
        System.assert(result.get(0).standardRegulations.contains(r2.Name));
        System.assert(result.get(1).standardRegulations.contains(r1.Name));
        System.assert(!result.get(1).standardRegulations.contains(','));
        System.assertEquals(null, result.get(0).inspectionItem);
        System.assertEquals(null, result.get(1).inspectionItem);
    }
    
    /*@isTest static void testGetInspecitonItems(){ 
        Investigation__c inv = EEC_TestUtil.mockInvestigation(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        i.Investigation__c = inv.Id;
        upsert i;
        
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null);
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, 'HJelp');
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), null, true, null);
        EEC_TestUtil.mockInspectionItem(i, stdIi, 'Non-Compliant', false, null);
        EEC_TestUtil.mockInspectionItem(i, stdIi, 'Non-Compliant', false, 'Helo');
        EEC_TestUtil.mockInspectionItem(i, stdIi, null, false, null);
        
        Regulation__c r1 = EEC_TestUtil.mockRegulation();
        Regulation__c r2 = EEC_TestUtil.mockRegulation(); 
        
        EEC_GenerateInvCoverLetterExtension cnt = new EEC_GenerateInvCoverLetterExtension (new ApexPages.StandardController(inv));
        List<EEC_GenerateInvestigationPDFBase.InvestigationVisitChecklistItemWrapper> result = cnt.getInspecitonItems();
        System.assertEquals(4, result.size());
    }*/

    /*@isTest static void testGetOlderCase(){
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Contact co = EEC_TestUtil.mockContact();
        
        Case ca1 = EEC_TestUtil.mockCase(a, co);
        Case ca2 = EEC_TestUtil.mockCase(a, co);
        ca1 = [SELECT CaseNumber FROM Case WHERE Id = :ca1.Id];
        ca2 = [SELECT CaseNumber FROM Case WHERE Id = :ca2.Id];
        
        Investigation__c i = EEC_TestUtil.mockInvestigation(a);
        
        ca1.Investigation__c = i.Id; 
        ca2.Investigation__c = i.Id; 
 
        upsert ca1;
        upsert ca2;
 
        EEC_GenerateInvCoverLetterExtension cnt = new EEC_GenerateInvCoverLetterExtension(new ApexPages.StandardController(i));
        
        ca1 = [SELECT CreatedDate FROM Case WHERE ID = :ca1.Id];
        
        Datetime result = cnt.getOldestCaseDate(); 
        System.assertEquals(ca1.CreatedDate, result);
    }*/

}