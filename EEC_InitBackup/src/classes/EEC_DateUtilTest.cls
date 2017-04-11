/**
 * EEC_DateUtilTest
 * 
 * This class contains all the unit test behaviour for the EEC_DateUtil class.
 * @author Darkis
 */

@isTest
private class EEC_DateUtilTest {
    static testMethod void testFormatDate() {
        System.assertEquals('April 29, 2015',EEC_DateUtil.formatDate('MMMM d, yyyy', date.newInstance(2015, 04, 29)));
    }
}