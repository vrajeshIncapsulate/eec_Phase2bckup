@isTest
public class EEC_LicensingElaborationQuestionTest { 
 
	@isTest
	static void testElaborationQuestionGetQuestionType() {
		EEC_LicensingElaborationQuestion eq = new EEC_LicensingElaborationQuestion('1', '2', '3', '4', new List<String>{'a','b'});
		System.assertEquals(eq.getQuestionType(), 'elaboration');
	}

	@isTest
	static void testElaborationQuestionConstruct() {
		EEC_LicensingElaborationQuestion eq = new EEC_LicensingElaborationQuestion('1', '2', '3', '4', new List<String>{'a','b'});
		System.assertEquals(eq.getHideOnLicensingType(), 'a,b');
		System.assertEquals(eq.question, '1');
		System.assertEquals(eq.statusField, '2');
		System.assertEquals(eq.elaborationDescription, '3');
		System.assertEquals(eq.elaborationField, '4');
	}
}