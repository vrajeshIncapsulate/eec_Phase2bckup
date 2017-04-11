@isTest
private class EEC_ShowMapsControllerTest {

    static testMethod void testEEC_ShowMapsController() {
        
        Profile p = [SELECT ID FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(
            Email = 'test@test.com',
            LastName = 'TestF',
            FirstName = 'TestL',
            Username = 'test123@test91.com',
            Alias = 'tst',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            ProfileID = p.Id,
            LanguageLocaleKey = 'en_US',
            ManagerId = Userinfo.getUserId(),
            Region__c = 'Central'
        );
        insert u;
        	
        	Inspection__c insp = EEC_TestUtil.loadInspectionSetup();
            insp.visitLatitude__c = '14.7788888';
            insp.visitLongitude__c = '-3.766676757575';
	        EEC_ShowMapsController controller = new EEC_ShowMapsController();
	        // Assert that values have been set by the constructor.
	        System.assertNotEquals(null, controller.userId);
	        System.assertNotEquals(null, controller.inspWrapperList);
	        // Instantiate the inner class.
	        EEC_ShowMapsController.InspectionWrapper inspWrap = new EEC_ShowMapsController.InspectionWrapper(insp);
	        System.assertNotEquals(null, inspWrap.Id);
	        System.assertNotEquals(null, inspWrap.content);
	        //System.assertNotEquals(null, inspWrap.announced);
	        System.assertNotEquals(null, inspWrap.providerAddress);
	        System.assertNotEquals(null, inspWrap.visitLink);
	        System.assertNotEquals(null, inspWrap.status);
    }
}