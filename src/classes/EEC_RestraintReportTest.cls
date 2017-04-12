@IsTest public class EEC_RestraintReportTest {
    public static void testEEC_RestraintReportTest () {
        RecordType r = [select Id from RecordType where DeveloperName='FCC' and sobjecttype='Account'];
        Account accnt = [select id from Account where RecordtypeID = :r.Id limit 1];  
        Contact con = [select id from Contact where AccountId = :accnt.id limit 1 ];
        Restraint_Report__c restraintReport = [SELECT Id 
									FROM Restraint_Report__c WHERE Provider__c = '0011100000vwa1WAAQ' limit 1];

        
         EEC_RestraintReport p1 = new EEC_RestraintReport();
		 p1.getRestraintReport(string.valueOf(accnt.id));
		 p1.getRestraintReportByID(restraintReport.id);
    }
    
	@isTest  static  void save() {
        City__c c = EEC_TestUtil.mockCity();
        Account a = EEC_TestUtil.mockProvider(c);
        ApexPages.currentPage().getParameters().put('accountId',a.Id);
    	EEC_RestraintReport p1 = new EEC_RestraintReport();
        User user = [SELECT ContactId FROM User WHERE Id =: userinfo.getuserid()];
    	p1.getRestraintReport(string.valueOf('0011100000vwa1WAAQ'));
		p1.getRestraintReportByID(string.valueOf('0011100000vwa1WAAQ'));
    	p1.save();
    }
}