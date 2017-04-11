@isTest
private class EEC_VisitAnnouncedEmailTest {

    static testMethod void testBatchable() {
    	Account accnt = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
    	EEC_TestUtil.mockInspection(accnt);
        EEC_VisitAnnouncedEmail batchable = new EEC_VisitAnnouncedEmail('SELECT Id FROM Inspection__c Limit 200');
        
        Test.startTest();
        Database.executeBatch(batchable);
        Test.stopTest();
    }
}