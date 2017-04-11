/**
 * TestGenerateCertificatePDF
 * 
 * This class contains all the unit tests for validating the behaviour of the GenerateCertificatePDF class.
 * @author Darkis
 */

@isTest
private class TestGenerateCertificatePDF {
    
    static testMethod void testGenerateCertificatePDF() {
        // Setup basic defaults.
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        // Call constructor.
        new GenerateCertificatePDF(sc);
    }
    
    static testMethod void testGeneratePDF() {
        // Setup basic defaults.
        Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
        ApexPages.StandardController sc = new ApexPages.StandardController(insp);
        GenerateCertificatePDF controller = new GenerateCertificatePDF(sc);
        // Call the controller method.
        controller.GeneratePDF();
    }

}