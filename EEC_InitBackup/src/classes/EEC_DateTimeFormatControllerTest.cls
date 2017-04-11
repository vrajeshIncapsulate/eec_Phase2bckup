@isTest
public class EEC_DateTimeFormatControllerTest {

    public static testMethod void testFormatDatetime() {
        EEC_DateTimeFormatController ctrl = new EEC_DateTimeFormatController();
        ctrl.dateTimeValue = DateTime.now();
        System.assertEquals(ctrl.dateTimeValue.format(), ctrl.getTimeZoneValue());
    }
}