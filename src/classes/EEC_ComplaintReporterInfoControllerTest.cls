@isTest
public class EEC_ComplaintReporterInfoControllerTest {

    @isTest
    static void testGetReporterInfoQuestions() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintReporterInfoController cic = new EEC_ComplaintReporterInfoController();
        cic.Complaint.Contact = new EEC_ComplaintContact();
        System.assertEquals(cic.getReporterInfoQuestions(),  EEC_QuestionService.complaintReporterInfoQuestion); 
    }

    @isTest
    static void testBackPage() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintReporterInfoController cic = new EEC_ComplaintReporterInfoController();
        cic.Complaint.Contact = new EEC_ComplaintContact();
        System.assertEquals(cic.backPage().getUrl(),  Page.EEC_ComplaintInformation.getUrl()); 
    } 
    
    @isTest
    static void testNoPhoneNumberGivenFalse() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintReporterInfoController cic = new EEC_ComplaintReporterInfoController();
        cic.Complaint.Contact = new EEC_ComplaintContact();
        System.assert(cic.noPhoneNumberGiven());
    }
    
    @isTest
    static void testNoPhoneNumberGivenTrue() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintReporterInfoController cic = new EEC_ComplaintReporterInfoController();
        cic.Complaint.Contact = new EEC_ComplaintContact();
        cic.complaint.Contact.HomePhone = '15064704361';
        System.assert(!cic.noPhoneNumberGiven());
    }
    
    @isTest
    static void testFindDuplicateContactEmail() { 
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintReporterInfoController cic = new EEC_ComplaintReporterInfoController();
        cic.Complaint.Contact = new EEC_ComplaintContact();
        Contact c = EEC_TestUtil.mockContact('john.benson@bluespurs.com');
        cic.Complaint.Contact.Email = 'john.benson@bluespurs.com';
        System.assertEquals(c.Id, cic.findDuplicateContact());
    }
    
    @isTest
    static void testFindDuplicateContactExisting() { 
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintReporterInfoController cic = new EEC_ComplaintReporterInfoController();
        cic.Complaint.Contact = new EEC_ComplaintContact();
        Contact c = EEC_TestUtil.mockContact('john.benson@bluespurs.com');
        cic.Complaint.Contact.Id = c.Id;
        cic.Complaint.Contact.Email = 'john.benson@bluespurs.com';
        System.assertEquals(cic.Complaint.Contact.Id, cic.findDuplicateContact());
    }
    
    @isTest
    static void testFindDuplicateContactPhone() { 
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintReporterInfoController cic = new EEC_ComplaintReporterInfoController(); 
        cic.Complaint.Contact = new EEC_ComplaintContact();
        Contact c = EEC_TestUtil.mockContact('john.benson@bluespurs.com');
        c.FirstName = 'firstName';
        c.LastName = 'lastName';
        c.Phone = '15064704361';
        upsert c;
        cic.Complaint.Contact.FirstName = 'firstName'; 
        cic.Complaint.Contact.LastName = 'lastName'; 
        cic.Complaint.Contact.Phone = '15064704361'; 
        System.assertEquals(c.Id, cic.findDuplicateContact());
    }  
    
    @isTest
    static void testGetQuestions() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintReporterInfoController cic = new EEC_ComplaintReporterInfoController();
        cic.Complaint.Contact = new EEC_ComplaintContact();
        System.assertEquals(cic.getReporterQuestions(), EEC_QuestionService.complaintReporterInfoQuestion);
        System.assertEquals(cic.getAddressQuestions(), EEC_QuestionService.complaintReporterAddressQuestion);
        System.assertEquals(cic.getContactQuestions(), EEC_QuestionService.complaintReporterContactQuestion);
    }
}