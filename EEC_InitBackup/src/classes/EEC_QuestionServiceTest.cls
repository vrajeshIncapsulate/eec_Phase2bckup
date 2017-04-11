@isTest
public class EEC_QuestionServiceTest { 

	@isTest
	static void testGetSectionQuestionsForProviderDNEType() {
		System.assertEquals(EEC_QuestionService.getLicensingSectionQuestionsForProvider(EEC_QuestionService.Section.BackgroundInformation, 'Fake').size(), 0);
	}
	
	@isTest
	static void testGetSectionQuestionsForProviderDNESection() {
		System.assertEquals(EEC_QuestionService.getLicensingSectionQuestionsForProvider(EEC_QuestionService.Section.TrainingInformation, 'Family Child Care').size(), 0);
	}
	
	@isTest
	static void testGetSectionQuestionsForProvider() {
		System.assert(EEC_QuestionService.getLicensingSectionQuestionsForProvider(EEC_QuestionService.Section.BackgroundInformation, 'Family Child Care').size() > 0);
	}

}