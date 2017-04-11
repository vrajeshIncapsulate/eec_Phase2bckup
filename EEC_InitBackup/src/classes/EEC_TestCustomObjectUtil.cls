/*Feature		Personal Edition	Contact Manager	Group Edition	Professional Edition	Enterprise Edition	Unlimited and Performance Edition	Developer Edition
Custom Objects	N/A					5				50				50						200					2,000								400
*/
@isTest
private class EEC_TestCustomObjectUtil {

     private static testMethod void testCustomObjectCount() {
        Test.startTest();
        	EEC_CustomObjectLimitUtil col = new EEC_CustomObjectLimitUtil();
			if (EEC_CustomObjectLimitUtil.getEdition() == 'Unlimited Edition')
                System.assert(col.Count() <= 2000, 'Custom Object count exceeds limit - Edition - ' + EEC_CustomObjectLimitUtil.getEdition() + ' - Count - ' + col.Count());
            else if (EEC_CustomObjectLimitUtil.getEdition() == 'Developer Edition')
            	System.assert(col.Count() <= 400, 'Custom Object count exceeds limit - Edition - ' + EEC_CustomObjectLimitUtil.getEdition() + ' - Count - ' + col.Count());
            else if (EEC_CustomObjectLimitUtil.getEdition() == 'Enterprise Edition')
            	System.assert(col.Count() <= 200, 'Custom Object count exceeds limit - Edition - ' + EEC_CustomObjectLimitUtil.getEdition() + ' - Count - ' + col.Count());
    		else if (EEC_CustomObjectLimitUtil.getEdition() == 'Professional Edition')
            	System.assert(col.Count() <= 50, 'Custom Object count exceeds limit - Edition - ' + EEC_CustomObjectLimitUtil.getEdition() + ' - Count - ' + col.Count());
            else if (EEC_CustomObjectLimitUtil.getEdition() == 'Group Edition')
            	System.assert(col.Count() <= 50, 'Custom Object count exceeds limit - Edition - ' + EEC_CustomObjectLimitUtil.getEdition() + ' - Count - ' + col.Count());
          	else if (EEC_CustomObjectLimitUtil.getEdition() == 'Contact Manager')
            	System.assert(col.Count() <= 5, 'Custom Object count exceeds limit - Edition - ' + EEC_CustomObjectLimitUtil.getEdition() + ' - Count - ' + col.Count());
			else System.assert(true, 'Custom Object count exceeds limit - Edition - ' + EEC_CustomObjectLimitUtil.getEdition() + ' - Count - ' + col.Count());

        Test.stopTest();
    }
}