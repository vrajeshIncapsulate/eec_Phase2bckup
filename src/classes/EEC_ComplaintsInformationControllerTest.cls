@isTest
public class EEC_ComplaintsInformationControllerTest {
    
    @isTest
    static void testAddInvolved(){
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        Case c = EEC_TestUtil.mockCase('testProvider', 'fake street', EEC_TestUtil.mockCity().Id, '12345');
        EEC_ComplaintsInformationController cic = new EEC_ComplaintsInformationController();
        cic.Complaint.Id = c.Id;
        cic.addInvolved();
        
        System.assertEquals(cic.involvedPersons.size(), 1);
        
    }
    
    @isTest
    static void testBackPage(){
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        Case c = EEC_TestUtil.mockCase('testProvider', 'fake street', EEC_TestUtil.mockCity().Id, '12345');
        EEC_ComplaintsInformationController cic = new EEC_ComplaintsInformationController();         
        System.assertEquals(Page.EEC_ComplaintsProviderInfo.getUrl(), cic.backPage().getUrl()); 
    }
    
    @isTest
    static void testRemoveInvolved(){
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        Case c = EEC_TestUtil.mockCase('testProvider', 'fake street', EEC_TestUtil.mockCity().Id, '12345');
        EEC_ComplaintsInformationController cic = new EEC_ComplaintsInformationController();    
        cic.Complaint.Id = c.Id;
        cic.addInvolved();    
        
        System.assertEquals(cic.involvedPersons.size(), 1);
        
        cic.personToRemove = 0;
        cic.removeInvolved();

        System.assertEquals(cic.involvedPersons.size(), 0);
    }
     
    @isTest
    static void testGetQuestions() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        Case c = EEC_TestUtil.mockCase('testProvider', 'fake street', EEC_TestUtil.mockCity().Id, '12345');
        EEC_ComplaintsInformationController cic = new EEC_ComplaintsInformationController();    
        System.assertEquals(cic.getComplaintInformationQuestions(), EEC_QuestionService.complaintInfoDescrQuestions);  
        System.assertEquals(cic.getInvolvedQuestions().size(), EEC_QuestionService.complaintInfoInvolvedQuestions().size());  
        System.assertEquals(cic.getDCFFilingQuestions(), EEC_QuestionService.complaintFilling);  
        System.assertEquals(cic.getSharedQuestions(), EEC_QuestionService.complaintSharedProvider);
        System.assertEquals(cic.getOtherInformationQuestions(), EEC_QuestionService.complaintInformationOtherQuestions);
    }
}