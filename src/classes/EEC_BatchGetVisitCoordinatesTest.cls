@isTest(SeeAllData=true)
private class EEC_BatchGetVisitCoordinatesTest {
	
	@isTest static void test_method_one() {
		Id cityId = (Id)[select id from City__c where Name = 'Boston'].id;
		Account acc1 = new Account();          
		Date cDate =  System.today();  
		acc1.Name = 'Test account 1 ';
		acc1.License_Status__c = 'Licensed';
		acc1.Provider_Status__c = 'Current';
		acc1.Provider_Email__c ='test@incapsulate.com';
		acc1.RecordTypeId = [select Id from RecordType where Name = 'Family Child Care' and SobjectType = 'Account'].Id;
		acc1.Provider_Address_1__c = '50 Milk Street';
		acc1.Provider_City__c = cityId;
		acc1.Provider_Zip_Code__c = '02109';
		acc1.Language__c = 'English';
		acc1.Preferred_Language__c = 'English';

		insert acc1;

		Inspection__c visit = new Inspection__c();
		visit.Provider_No__c = acc1.Id;
		visit.Estimated_Deadline__c = cDate;
		visit.Status__c = 'To be scheduled';
		visit.Type_of_Visit__c = 'Monitoring';
		visit.Address_1__c = acc1.Provider_Address_1__c;
		visit.City__c = cityId;
		visit.Zip_Code__c = acc1.Provider_Zip_Code__c;

		insert visit;

		Test.startTest(); 
			EEC_batchGetVisitCoordinates sfbatchSync = new EEC_batchGetVisitCoordinates();
			ID batchprocessid = Database.executeBatch(sfbatchSync);
		Test.stopTest();
		AsyncApexJob job  = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
			                      FROM AsyncApexJob WHERE Id =:batchprocessid];
			  //assert for total number of errors
		System.assertEquals(job.NumberOfErrors, 0);
	}
	
	
}