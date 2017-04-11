@istest 

public with sharing class EEC_NCItemRegulationTgrHandlerTest {
	
	@istest static void EEC_NCIR(){
		
	Account acc1 = new Account();          
          Date cDate =  System.today();  
          // Scenario 1 : Renewal Application Not Submitted - 30 days prior to  expiration notice
          acc1.Name = 'Test account 1 ';
          acc1.License_Status__c = 'Licensed';
          acc1.Provider_Status__c = 'Current';
          acc1.Provider_Email__c ='test@incapsulate.com';
          acc1.RecordTypeId = [select Id from RecordType where Name = 'Family Child Care' and SobjectType = 'Account'].Id;
          acc1.Provider_Address_1__c = 'Test address';
          acc1.Provider_City__c = EEC_TestUtil.mockCity().Id;
          acc1.Provider_Zip_Code__c = '99999';
          acc1.Language__c = 'English';
          acc1.Preferred_Language__c = 'English';
          acc1.Restraint_Method__c = 'OWN';
          acc1.Use_Physical_Restraints__c = true;
          acc1.Renewal_date__c = cdate +30; 
          acc1.Provider_No__c = '603735';
          insert acc1;
        
        Regulation__c reg = new Regulation__c();
        reg.Applicable_To__c = 'Family Child Care';
        reg.Name = '14.14';
        reg.Date_Active__c = system.today();
        reg.Reg_key__c = 'FGS-18';
        reg.FCC_High_Risk_Reg__c=true;
        insert reg;
        
        Regulation__c reg1 = new Regulation__c();
        reg1.Applicable_To__c = 'Family Child Care';
        reg1.Name = '14.15';
        reg1.Date_Active__c = system.today();
        reg1.Reg_key__c = 'FGS-19';
        reg1.FCC_High_Risk_Reg__c=true;
        insert reg1;
        
        Investigation__c Inv = new Investigation__c();
        Inv.Provider_No__c= acc1.id;
        insert Inv;
        
        Non_Compliant__c NC = new Non_Compliant__c();
        NC.Observations__c ='test';
        NC.Investigation__c = Inv.id;
        insert NC; 
        
        Non_Compliant__c NC1 = new Non_Compliant__c();
        NC1.Observations__c ='test';
        NC1.Investigation__c = Inv.id;
        insert NC1;  
        
        Non_Compliant_Item_Regulation__c NCIR = new Non_Compliant_Item_Regulation__c();
        NCIR.Non_Compliant_Item__c = NC.id;
        NCIR.Regulation__c = reg.id;
        
        Non_Compliant_Item_Regulation__c NCIR1 = new Non_Compliant_Item_Regulation__c();
        NCIR1.Non_Compliant_Item__c = NC1.id;
        NCIR1.Regulation__c = reg1.id;
        insert NCIR1;
        
        
        Test.startTest();
        insert NCIR;
        delete NCIR1;
        EEC_NonComplaintItemRegulationTgrHandler hdlr = new EEC_NonComplaintItemRegulationTgrHandler();
        
	    /* map<id,Non_Compliant_Item_Regulation__c> newmap = new map<id,Non_Compliant_Item_Regulation__c>([select id,name,Non_Compliant_Item__c,Non_Compliant_Item__r.Key_Indicator__c,Non_Compliant_Item__r.Investigation__r.id,
	                                                Non_Compliant_Item__r.Investigation__r.Provider_No__r.name,Non_Compliant_Item__r.Investigation__r.Provider_No__r.recordtype.name,
	                                                Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_R_P__c,Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_GSA__c,
	                                                Regulation__c,Regulation__r.FCC_High_Risk_Reg__c,Regulation__r.R_P_High_Risk_Reg__c,Regulation__r.GSA_High_Risk_Reg__c 
	                                                from Non_Compliant_Item_Regulation__c where id =: NCIR.Id]);
	    map<id,Non_Compliant_Item_Regulation__c> oldmap = new map<id,Non_Compliant_Item_Regulation__c>([select id,name,Non_Compliant_Item__c,Non_Compliant_Item__r.Key_Indicator__c,Non_Compliant_Item__r.Investigation__r.id,
	                                                Non_Compliant_Item__r.Investigation__r.Provider_No__r.name,Non_Compliant_Item__r.Investigation__r.Provider_No__r.recordtype.name,
	                                                Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_R_P__c,Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_GSA__c,
	                                                Regulation__c,Regulation__r.FCC_High_Risk_Reg__c,Regulation__r.R_P_High_Risk_Reg__c,Regulation__r.GSA_High_Risk_Reg__c 
	                                                from Non_Compliant_Item_Regulation__c where id =: NCIR.Id]);*/
        //EEC_NonComplaintItemRegulationTgrHandler.UpdateKeyIndicator(newmap,oldmap);
        //EEC_NonComplaintItemRegulationTgrHandler.UpdateKeyOnDelete(newmap,oldmap);
        Test.stopTest();
        
	}
    
}