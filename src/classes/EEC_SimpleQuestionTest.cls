@isTest
public class EEC_SimpleQuestionTest {

    @isTest
    static void testSimpleConstruct() {
        EEC_SimpleQuestion q = new EEC_SimpleQuestion('the_field', 'the_label');
        System.assert(q.getIsRequired());
        System.assertEquals('the_label', q.label);
        System.assertEquals('the_field', q.fieldName);
    }

    @isTest
    static void testFullConstruct() {
        EEC_SimpleQuestion q = new EEC_SimpleQuestion('the_field', 'the_label');
        q.isRequired(false);
        System.assert(!q.getIsRequired());
        System.assertEquals('the_label', q.label);
        System.assertEquals('the_field', q.fieldName);
    }

}