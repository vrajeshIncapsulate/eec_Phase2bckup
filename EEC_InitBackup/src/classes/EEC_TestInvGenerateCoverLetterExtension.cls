@isTest
public with sharing class EEC_TestInvGenerateCoverLetterExtension {
    
    @isTest static void testGetDirectorContact() { 
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Contact c = EEC_TestUtil.mockDirectorContact(a);
        //AccountContactRole acr = EEC_TestUtil.mockAccountContactRole('Director', c, a);
        Investigation__c i = EEC_TestUtil.mockInvestigation(a);
        
        EEC_GenerateInvCoverLetterExtension ext = new EEC_GenerateInvCoverLetterExtension  (new ApexPages.StandardController(i));
         
        Contact co = ext.getDirectorContact();
                 
        System.assertEquals(c.FirstName, co.FirstName);
        System.assertEquals(c.LastName, co.LastName);
        System.assertEquals(c.Salutation, co.Salutation); 
    }
}