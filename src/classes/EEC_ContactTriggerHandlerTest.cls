@isTest
public class EEC_ContactTriggerHandlerTest {
    
    static testMethod void testContactUpdate(){
        Contact c = EEC_TestUtil.mockContact();
        c.FirstName = 'New Name';
		update c;
    }

}