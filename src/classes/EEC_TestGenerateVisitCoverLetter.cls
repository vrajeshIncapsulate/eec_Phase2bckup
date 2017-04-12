@isTest
public with sharing class EEC_TestGenerateVisitCoverLetter {

    @isTest static void testGetHasNonCompliantItemsTrue(){
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Non-Compliant', false, null);
        EEC_GenerateVisitCoverLetterExtension ext = new EEC_GenerateVisitCoverLetterExtension (new ApexPages.StandardController(i));
        
        System.assert(ext.getHasNonCompliant());
    }

    @isTest static void testGetHasNonCompliantItemsFalse(){
        Inspection__c i = EEC_TestUtil.mockInspection(EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity()));
        Standard_Inspection_Item__c stdIi = EEC_TestUtil.mockStdInspectionItem();
        EEC_TestUtil.mockInspectionItem(i, EEC_TestUtil.mockRegulation(), 'Compliant', false, null);
        EEC_GenerateVisitCoverLetterExtension ext = new EEC_GenerateVisitCoverLetterExtension (new ApexPages.StandardController(i));
        
        System.assert(!ext.getHasNonCompliant());
    }
    
    @isTest static void testGetDirectorContact() {
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Contact c = EEC_TestUtil.mockDirectorContact(a);
        //AccountContactRole acr = EEC_TestUtil.mockAccountContactRole('Director', c, a);
        Inspection__c i = EEC_TestUtil.mockInspection(a);
         
        EEC_GenerateVisitCoverLetterExtension ext = new EEC_GenerateVisitCoverLetterExtension (new ApexPages.StandardController(i));
         
        
        Contact co = ext.getDirectorContact();
         
        System.assertEquals(c.FirstName, co.FirstName);
        System.assertEquals(c.LastName, co.LastName);
        System.assertEquals(c.Salutation, co.Salutation);
        
    }
    
    @isTest static void testGetNonDirectorContact() {
    	Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    	Contact c = EEC_TestUtil.mockContact();
    	Inspection__c i = EEC_TestUtil.mockInspection(a);
    	EEC_GenerateVisitCoverLetterExtension ext = new EEC_GenerateVisitCoverLetterExtension (new ApexPages.StandardController(i));
    	Contact co = ext.getDirectorContact();
    }

}