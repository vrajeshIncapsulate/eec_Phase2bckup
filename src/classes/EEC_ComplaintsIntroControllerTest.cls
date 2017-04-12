@isTest
public class EEC_ComplaintsIntroControllerTest { 

    @isTest
    static void testReportAComplaint() { 
        LEAD_Configuration__c conf = EEC_TestUtil.mockLeadConfig('Global', 'Test');
        EEC_ComplaintsIntroController cic = new EEC_ComplaintsIntroController(); 
        PageReference pr = cic.reportAComplaint();
        System.assertEquals(pr.getUrl(), Page.EEC_ComplaintsProviderInfo.getUrl());
    }
    
    @isTest
    static void testRequireComplaint(){
        LEAD_Configuration__c conf = EEC_TestUtil.mockLeadConfig('Global', 'Test');
        EEC_ComplaintsIntroController cic = new EEC_ComplaintsIntroController();  
        System.assert(!cic.requireComplaint());
    }

}