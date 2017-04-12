//Test Class for EEC_ProcessLMVisitData + EEC_Batch_ProcessLMVisitData

@isTest
public with sharing class EEC_LEADJobsTest {
    
    static testMethod void testLegacyVisitsBatch()	{
        EEC_Batch_ProcessLegacyVisits bc = new EEC_Batch_ProcessLegacyVisits();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
    static testMethod void testLegacyVisitItemsBatch()	{
        EEC_Batch_ProcessLegacyVisitItems bc = new EEC_Batch_ProcessLegacyVisitItems();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
    static testMethod void testLegacyNonCompVisitsBatch()	{
        EEC_Batch_ProcessLegacyNonCompVisits bc = new EEC_Batch_ProcessLegacyNonCompVisits();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }
    
    static testMethod void testLegacyNonCompVisitItemsBatch()	{
        EEC_Batch_ProcessLegacyNonCompVisitItems bc = new EEC_Batch_ProcessLegacyNonCompVisitItems();
        
        Test.startTest();
           Database.executeBatch(bc, 1);
        Test.stopTest();
    }
      
     static testMethod void processLegacyVisitsTest() {  
    	
        City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
        Account a = new Account();
	 	a.Name = 'Test Account';
	 	a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
	 	a.License_Status__c = 'Licensed';
	 	a.Provider_Status__c = 'Current';
	 	a.Language__c = 'English';
	 	a.Preferred_Language__c = 'English';
	 	a.Provider_Address_1__c = 'street';
	 	a.Provider_City__c = c.id;
	 	a.State__c = 'MA';
	 	a.Provider_Zip_Code__c ='12345';
	 	a.Provider_No__c = '67890';
	 	insert a; 
  	 	
        EEC_HistoricalVisitStaging__c hv = new EEC_HistoricalVisitStaging__c();
    	hv.EEC_VisitId__c = '12345';
    	hv.EEC_ProgramId__c = '67890';
    	hv.EEC_LeadReasonOfVisit__c = 'Renewal';
    	hv.EEC_Comment__c = 'Test Comment';
    	hv.EEC_VisitDate__c = system.today();
    	hv.EEC_ComplianceCodeDesc__c = 'Compliance';
    	hv.EEC_Visit_Processed__c = false;
          
        system.debug('****Result***:'+ hv);        
        
        insert hv;
                
        Test.startTest();
           EEC_Batch_ProcessLegacyVisits bc = new EEC_Batch_ProcessLegacyVisits();
           Database.executeBatch(bc, 1);
        Test.stopTest();
         
        EEC_HistoricalVisitStaging__c result = [Select Id, EEC_VisitId__c,EEC_Visit_Processed__c From EEC_HistoricalVisitStaging__c Where id = :hv.Id];  
        
        system.debug('****Result2***:'+ result);  
          
        system.assert(result.EEC_Visit_Processed__c == true);
     }

       static testMethod void processLegacyVisitsTestError() {  
    	
        City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
        Account a = new Account();
	 	a.Name = 'Test Account';
	 	a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
	 	a.License_Status__c = 'Licensed';
	 	a.Provider_Status__c = 'Current';
	 	a.Language__c = 'English';
	 	a.Preferred_Language__c = 'English';
	 	a.Provider_Address_1__c = 'street';
	 	a.Provider_City__c = c.id;
	 	a.State__c = 'MA';
	 	a.Provider_Zip_Code__c ='12345';
	 	a.Provider_No__c = '67899';
	 	insert a; 
  	 	
        EEC_HistoricalVisitStaging__c hv = new EEC_HistoricalVisitStaging__c();
    	hv.EEC_VisitId__c = '12345';
    	hv.EEC_ProgramId__c = '67890';
    	hv.EEC_LeadReasonOfVisit__c = 'Renewal';
    	hv.EEC_Comment__c = 'Test Comment';
    	hv.EEC_VisitDate__c = system.today();
    	hv.EEC_ComplianceCodeDesc__c = 'Compliance';
    	hv.EEC_Visit_Processed__c = false;
          
        system.debug('****Result***:'+ hv);        
        
        insert hv;
                
        Test.startTest();
           EEC_Batch_ProcessLegacyVisits bc = new EEC_Batch_ProcessLegacyVisits();
           Database.executeBatch(bc, 1);
        Test.stopTest();
         
        EEC_HistoricalVisitStaging__c result = [Select Id, EEC_ErrorText__c, EEC_VisitId__c,EEC_Visit_Processed__c From EEC_HistoricalVisitStaging__c Where id = :hv.Id];  
        
        system.debug('****Result2***:'+ result);  
          
        system.assert(result.EEC_Visit_Processed__c == false);
        system.assert(result.EEC_ErrorText__c.contains('Provider Not Found in LEAD'));  
     }  
    
    static testMethod void leadJobsControllerTest() {  
    	
        City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
        Account a = new Account();
	 	a.Name = 'Test Account';
	 	a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
	 	a.License_Status__c = 'Licensed';
	 	a.Provider_Status__c = 'Current';
	 	a.Language__c = 'English';
	 	a.Preferred_Language__c = 'English';
	 	a.Provider_Address_1__c = 'street';
	 	a.Provider_City__c = c.id;
	 	a.State__c = 'MA';
	 	a.Provider_Zip_Code__c ='12345';
	 	a.Provider_No__c = '67890';
	 	insert a; 
  	 	
        EEC_HistoricalVisitStaging__c hv = new EEC_HistoricalVisitStaging__c();
    	hv.EEC_VisitId__c = '12345';
    	hv.EEC_ProgramId__c = a.id;
    	hv.EEC_LeadReasonOfVisit__c = 'Renewal';
    	hv.EEC_Comment__c = 'Test Comment';
    	hv.EEC_VisitDate__c = system.today();
    	hv.EEC_ComplianceCodeDesc__c = 'Compliance';
    	hv.EEC_Visit_Processed__c = false;
          
        system.debug('****Result***:'+ hv);        
        
        insert hv;
                
        EEC_LEADJobsController controller = new EEC_LEADJobsController();
        
        controller.processLegacyVisits();
        controller.processLegacyVisitItems();
         
        EEC_HistoricalVisitStaging__c result = [Select Id, EEC_VisitId__c,EEC_Visit_Processed__c From EEC_HistoricalVisitStaging__c Where id = :hv.Id];  
        
        system.debug('****Result2***:'+ result);  
          
        system.assert(result != null);
     }
    
    static testMethod void processLegacyVisitItemsTest() {  
    	
        City__c c = new City__c();
         c.name ='Bradford';
         c.State__c ='MA';
         insert c;
         
        Account a = new Account();
	 	a.Name = 'Test Account';
	 	a.RecordTypeId = [Select Id,Name From RecordType Where sObjectType='Account' and name='Family Child Care'].id;
	 	a.License_Status__c = 'Licensed';
	 	a.Provider_Status__c = 'Current';
	 	a.Language__c = 'English';
	 	a.Preferred_Language__c = 'English';
	 	a.Provider_Address_1__c = 'street';
	 	a.Provider_City__c = c.id;
	 	a.State__c = 'MA';
	 	a.Provider_Zip_Code__c ='12345';
	 	a.Provider_No__c = '67890';
	 	insert a; 
        
        
  	 	
        Inspection__c legacyVisit = new Inspection__c();
    	legacyVisit.Provider_No__c = a.id;
    	legacyVisit.Comments__c = 'Test Comment';
    	legacyVisit.Date_of_Visit__c = system.today() - 1;
        legacyVisit.Legacy_FCC_LM_Mobile_Visit__c = '67890|EEC-TAB065';
        legacyVisit.Status__c = 'Closed';
        insert legacyVisit;
        
        EEC_HistoricalVisitItemStaging__c hvi = new EEC_HistoricalVisitItemStaging__c();
    	hvi.EEC_VisitDetailId__c  = '12345';
    	hvi.EEC_VisitHeaderId__c  = '67890';
    	hvi.EEC_Comment__c = 'Test Comment';
    	hvi.EEC_ComplianceStatusDesc__c  = 'Compliance';
    	hvi.EEC_VisitItem_Processed__c = false;
        hvi.EEC_Hostname__c = 'EEC-TAB065';
        hvi.EEC_RegGroupItem__c = '7.11(07)';
        hvi.EEC_RegGroupItemDesc__c = 'Emergency Preparedness';    
        system.debug('****Result***:'+ hvi);        
        
        insert hvi;
        
        EEC_HistoricalVisitSubItemStaging__c subItem = new EEC_HistoricalVisitSubItemStaging__c ();
        subItem.EEC_DisplayText__c  = 'Test display';
        subItem.EEC_SubItemVal__c = '5';
        subItem.EEC_Visit_SubItem_Processed__c = false;
        subItem.EEC_VisitSubItemId__c = '1';
        subItem.EEC_VisitDetailId__c  = '12345';
    	subItem.EEC_VisitHeaderId__c  = '67890';
        subItem.EEC_Hostname__c = 'EEC-TAB065';
        
        insert subItem;
        
        Regulation__c reg = new Regulation__c();
        reg.Name = '7.11(07)';
        reg.Applicable_To__c ='Family Child Care; Large Group;';
        reg.Date_Active__c = system.today() - 100;
        insert reg;
                
        Test.startTest();
           EEC_Batch_ProcessLegacyVisitItems bc = new EEC_Batch_ProcessLegacyVisitItems();
           Database.executeBatch(bc, 1);
        Test.stopTest();
         
        EEC_HistoricalVisitItemStaging__c result = [Select Id,EEC_VisitItem_Processed__c From EEC_HistoricalVisitItemStaging__c Where id = :hvi.Id];  
        
        EEC_HistoricalVisitSubItemStaging__c result2 = [Select Id,EEC_Visit_SubItem_Processed__c From EEC_HistoricalVisitSubItemStaging__c where id =:subItem.Id];
        system.debug('****Result2***:'+ result);  
          
        system.assert(result.EEC_VisitItem_Processed__c == true);
        //system.assert(result2.EEC_Visit_SubItem_Processed__c == true);
     }
}