@isTest
private class EEC_StandardItemRegulationNamesTest {

    static testMethod void testEEC_StandardItemRegulationNames() {
        EEC_StandardItemRegulationNames ctrl = new EEC_StandardItemRegulationNames();
        ctrl.standardItemId = 'TestString';
        System.assertEquals('TestString', ctrl.standardItemId);
    }
}