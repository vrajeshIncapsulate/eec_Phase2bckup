@isTest
public class EEC_BaseComplaintsControllerTest { 
    
    @isTest
    static void testOneMonthAgo() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintsIntroController cic = new EEC_ComplaintsIntroController();
        System.assertEquals(cic.getOneMonthAgo(),  Date.today().addMonths(-1)); 
    }
    
    @isTest
    static void testNoComplaintRedirect() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintReporterInfoController cic = new EEC_ComplaintReporterInfoController();
        ApexPages.currentPage().getParameters().put('id', null);
        System.assertEquals(Page.EEC_ComplaintsProviderInfo.getUrl(), cic.noComplaintRedirect().getUrl());
    }

    @isTest
    static void testNoComplaintNoRedirect() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintsIntroController cic = new EEC_ComplaintsIntroController();
        ApexPages.currentPage().getParameters().put('id', 'Test');
        System.assertEquals(null, cic.noComplaintRedirect());
    }

    @isTest
    static void testConstructNew() {
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintsIntroController cic = new EEC_ComplaintsIntroController();
        Id complaintId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
 
        System.assertEquals('Not Submitted', cic.complaint.Status);
        System.assertEquals('Web', cic.complaint.Origin);
        System.assertEquals(complaintId, cic.complaint.RecordTypeId);
    }
    
    @isTest
    static void testConstructExisting() { 
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        City__c city = EEC_TestUtil.mockCity();
        Case c = EEC_TestUtil.mockCase('Test', '10', city.Id, '12345');
        ApexPages.currentPage().getParameters().put('id', c.Id);
        EEC_ComplaintsIntroController cic = new EEC_ComplaintsIntroController(); 
        System.assertEquals(cic.complaint.Id, c.Id);
    }  
      

    @isTest
    static void testBack(){ 
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        EEC_ComplaintsIntroController cic = new EEC_ComplaintsIntroController(); 
        PageReference pr = cic.back();
        System.assert(pr.getRedirect());
        List<String> testL = new List<String>(); 
        System.assertEquals(pr.getParameters().size(), 1);
        System.assertEquals(pr.getParameters().get('Id'), null);
    }  

    @isTest
    static void testBackId(){ 
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        City__c city = EEC_TestUtil.mockCity();
        Case c = EEC_TestUtil.mockCase('Test', '10', city.Id, '12345');
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        EEC_ComplaintsIntroController cic = new EEC_ComplaintsIntroController(); 
        PageReference pr = cic.back();

        System.assert(pr.getRedirect());
        System.assertEquals(pr.getParameters().size(), 1);
        System.assertEquals(pr.getParameters().get('Id'), c.Id);
    } 

    @isTest
    static void testBackPage(){ 
        EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        City__c city = EEC_TestUtil.mockCity();
        Case c = EEC_TestUtil.mockCase('Test', '10', city.Id, '12345');
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        EEC_ComplaintsIntroController cic = new EEC_ComplaintsIntroController(); 
        PageReference pr = cic.backPage();
         
        System.assertEquals(pr.getUrl(), Page.EEC_ComplaintsIntro.getUrl()); 
    }

    @isTest
    static void testCancel(){  
        LEAD_Configuration__c conf = EEC_TestUtil.mockLeadConfig('Global', 'Test'); 
        conf.Complaint_Form_Redirect__c = 'http://google.com';
        upsert conf;

        EEC_ComplaintsIntroController cic = new EEC_ComplaintsIntroController(); 
        PageReference pr = cic.cancel();
         
        System.assertEquals(pr.getUrl(), 'http://google.com'); 
    } 
}