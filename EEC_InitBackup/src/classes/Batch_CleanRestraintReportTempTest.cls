@isTest
public with sharing class Batch_CleanRestraintReportTempTest {
	
	@isTest static void bulkRestraintReportTest() {
     	
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
          acc1.Use_Physical_Restraints__c = true;
          acc1.Renewal_date__c = cdate +30; 
          acc1.Provider_No__c = '272727';
          acc1.Restraint_Method__c = 'Varied';
          insert acc1; 
          
          Contact c = new Contact();
          c.FirstName = 'Test';
          c.LastName = 'Contact';
          c.AccountId = acc1.Id; 
          insert c;
          
          	
     	List<RestraintReportTemp__c> rrList = new List<RestraintReportTemp__c>();
        
        RestraintReportTemp__c rr1 = new RestraintReportTemp__c();
     	
     	//Standing
     	rr1.Restraint_Count__c = 2;
		rr1.RestraintId__c = 5;
		rr1.Restraint_Method__c = null;
		rr1.Restraint_Position_Time__c = 'Standing 0-5';
		rr1.Restraint_Quarter__c = 'Second Quarter';
		rr1.RestraintYear__c = '2007';
		rr1.Submitted_By__c = 'Test Contact';
		rr1.Submitted_Date__c = date.parse('10/10/07');
     	rr1.ProgramId__c = '272727';
     	rr1.RestraintRecordType__c = 'Varied Restraint';
     	
     	rrList.add(rr1);
     	
     	RestraintReportTemp__c rr2 = rr1.clone();
     	rr2.Restraint_Position_Time__c ='Standing 6-10';
     	rrList.add(rr2);
     	
     	RestraintReportTemp__c rr3 = rr1.clone();
     	rr3.Restraint_Position_Time__c ='Standing 11-20';
     	rrList.add(rr3);
     	
     	RestraintReportTemp__c rr8 = rr1.clone();
     	rr8.Restraint_Position_Time__c ='Standing 21-30';
     	rrList.add(rr8);
     	
     	RestraintReportTemp__c rr4 = rr1.clone();
     	rr4.Restraint_Position_Time__c ='Standing 31-40';
     	rrList.add(rr4);
     	
     	RestraintReportTemp__c rr5 = rr1.clone();
     	rr5.Restraint_Position_Time__c ='Standing 41-50';
     	rrList.add(rr5);
     	
     	RestraintReportTemp__c rr6 = rr1.clone();
     	rr6.Restraint_Position_Time__c ='Standing 51-60';
     	rrList.add(rr6);
     	
     	RestraintReportTemp__c rr7 = rr1.clone();
     	rr7.Restraint_Position_Time__c ='Standing >60';
     	rrList.add(rr7);
     	
     	//Sitting
     	RestraintReportTemp__c rr9 = rr1.clone();
     	rr9.Restraint_Position_Time__c ='Sitting 0-5';
     	rrList.add(rr9);     	
     	RestraintReportTemp__c rr10 = rr1.clone();
     	rr10.Restraint_Position_Time__c ='Sitting 6-10';
     	rrList.add(rr10);	
     	RestraintReportTemp__c rr11 = rr1.clone();
     	rr11.Restraint_Position_Time__c ='Sitting 11-20';
     	rrList.add(rr11);
     	RestraintReportTemp__c rr12 = rr1.clone();
     	rr12.Restraint_Position_Time__c ='Sitting 21-30';
     	rrList.add(rr12);
     	RestraintReportTemp__c rr13 = rr1.clone();
     	rr13.Restraint_Position_Time__c ='Sitting 31-40';
     	rrList.add(rr13);
     	RestraintReportTemp__c rr14 = rr1.clone();
     	rr14.Restraint_Position_Time__c ='Sitting 41-50';
     	rrList.add(rr14);
     	RestraintReportTemp__c rr15 = rr1.clone();
     	rr15.Restraint_Position_Time__c ='Sitting 51-60';
     	rrList.add(rr15);
     	RestraintReportTemp__c rr16 = rr1.clone();
     	rr16.Restraint_Position_Time__c ='Sitting >60';
     	rrList.add(rr16);
     	
     	//Floor (Supine)
     	RestraintReportTemp__c rr17 = rr1.clone();
     	rr17.Restraint_Position_Time__c ='Floor (Supine) 0-5';
     	rrList.add(rr17);     	
     	RestraintReportTemp__c rr18 = rr1.clone();
     	rr18.Restraint_Position_Time__c ='Floor (Supine) 6-10';
     	rrList.add(rr18);	
     	RestraintReportTemp__c rr19 = rr1.clone();
     	rr19.Restraint_Position_Time__c ='Floor (Supine) 11-20';
     	rrList.add(rr19);
     	RestraintReportTemp__c rr20 = rr1.clone();
     	rr20.Restraint_Position_Time__c ='Floor (Supine) 21-30';
     	rrList.add(rr20);
     	RestraintReportTemp__c rr21 = rr1.clone();
     	rr21.Restraint_Position_Time__c ='Floor (Supine) 31-40';
     	rrList.add(rr21);
     	RestraintReportTemp__c rr22 = rr1.clone();
     	rr22.Restraint_Position_Time__c ='Floor (Supine) 41-50';
     	rrList.add(rr22);
     	RestraintReportTemp__c rr23 = rr1.clone();
     	rr23.Restraint_Position_Time__c ='Floor (Supine) 51-60';
     	rrList.add(rr23);
     	RestraintReportTemp__c rr24 = rr1.clone();
     	rr24.Restraint_Position_Time__c ='Floor (Supine) >60';
     	rrList.add(rr24);
     	
       //Floor (Prone)
     	RestraintReportTemp__c rr25 = rr1.clone();
     	rr25.Restraint_Position_Time__c ='Floor (Prone) 0-5';
     	rrList.add(rr25);     	
     	RestraintReportTemp__c rr26 = rr1.clone();
     	rr26.Restraint_Position_Time__c ='Floor (Prone) 6-10';
     	rrList.add(rr26);	
     	RestraintReportTemp__c rr27 = rr1.clone();
     	rr27.Restraint_Position_Time__c ='Floor (Prone) 11-20';
     	rrList.add(rr27);
     	RestraintReportTemp__c rr28 = rr1.clone();
     	rr28.Restraint_Position_Time__c ='Floor (Prone) 21-30';
     	rrList.add(rr28);
     	RestraintReportTemp__c rr29 = rr1.clone();
     	rr29.Restraint_Position_Time__c ='Floor (Prone) 31-40';
     	rrList.add(rr29);
     	RestraintReportTemp__c rr30 = rr1.clone();
     	rr30.Restraint_Position_Time__c ='Floor (Prone) 41-50';
     	rrList.add(rr30);
     	RestraintReportTemp__c rr31 = rr1.clone();
     	rr31.Restraint_Position_Time__c ='Floor (Prone) 51-60';
     	rrList.add(rr31);
     	RestraintReportTemp__c rr32 = rr1.clone();
     	rr32.Restraint_Position_Time__c ='Floor (Prone) >60';
     	rrList.add(rr32);
     	
     	//Floor (Both Prone and Supine)
     	RestraintReportTemp__c rr33 = rr1.clone();
     	rr33.Restraint_Position_Time__c ='Floor (Both Prone and Supine) 0-5';
     	rrList.add(rr33);     	
     	RestraintReportTemp__c rr34 = rr1.clone();
     	rr34.Restraint_Position_Time__c ='Floor (Both Prone and Supine) 6-10';
     	rrList.add(rr34);	
     	RestraintReportTemp__c rr35 = rr1.clone();
     	rr35.Restraint_Position_Time__c ='Floor (Both Prone and Supine) 11-20';
     	rrList.add(rr35);
     	RestraintReportTemp__c rr36 = rr1.clone();
     	rr36.Restraint_Position_Time__c ='Floor (Both Prone and Supine) 21-30';
     	rrList.add(rr36);
     	RestraintReportTemp__c rr37 = rr1.clone();
     	rr37.Restraint_Position_Time__c ='Floor (Both Prone and Supine) 31-40';
     	rrList.add(rr37);
     	RestraintReportTemp__c rr38 = rr1.clone();
     	rr38.Restraint_Position_Time__c ='Floor (Both Prone and Supine) 41-50';
     	rrList.add(rr38);
     	RestraintReportTemp__c rr39 = rr1.clone();
     	rr39.Restraint_Position_Time__c ='Floor (Both Prone and Supine) 51-60';
     	rrList.add(rr39);
     	RestraintReportTemp__c rr40 = rr1.clone();
     	rr40.Restraint_Position_Time__c ='Floor (Both Prone and Supine) >60';
     	rrList.add(rr40);
     	
     	//Physical & Mechanical
     	RestraintReportTemp__c rr41 = rr1.clone();
     	rr41.Restraint_Position_Time__c ='Physical & Mechanical 0-5';
     	rr41.RestraintRecordType__c = 'DYS Restraint';
     	rrList.add(rr41); 
     	    	
     	RestraintReportTemp__c rr42 = rr41.clone();
     	rr42.Restraint_Position_Time__c ='Physical & Mechanical 6-10';
     	rrList.add(rr42);	
     	RestraintReportTemp__c rr43 = rr41.clone();
     	rr43.Restraint_Position_Time__c ='Physical & Mechanical 11-20';
     	rrList.add(rr43);
     	RestraintReportTemp__c rr44 = rr41.clone();
     	rr44.Restraint_Position_Time__c ='Physical & Mechanical 21-30';
     	rrList.add(rr44);
     	RestraintReportTemp__c rr45 = rr41.clone();
     	rr45.Restraint_Position_Time__c ='Physical & Mechanical 31-40';
     	rrList.add(rr45);
     	RestraintReportTemp__c rr46 = rr41.clone();
     	rr46.Restraint_Position_Time__c ='Physical & Mechanical 41-50';
     	rrList.add(rr46);
     	RestraintReportTemp__c rr47 = rr41.clone();
     	rr47.Restraint_Position_Time__c ='Physical & Mechanical 51-60';
     	rrList.add(rr47);
     	RestraintReportTemp__c rr48 = rr41.clone();
     	rr48.Restraint_Position_Time__c ='Physical & Mechanical >60';
     	rrList.add(rr48);
     	
     	//Physical Holds Only
     	RestraintReportTemp__c rr49 = rr41.clone();
     	rr49.Restraint_Position_Time__c ='Physical Holds Only 0-5';
     	rrList.add(rr49);     	
     	RestraintReportTemp__c rr50 = rr41.clone();
     	rr50.Restraint_Position_Time__c ='Physical Holds Only 6-10';
     	rrList.add(rr50);	
     	RestraintReportTemp__c rr51 = rr41.clone();
     	rr51.Restraint_Position_Time__c ='Physical Holds Only 11-20';
     	rrList.add(rr51);
     	RestraintReportTemp__c rr52 = rr41.clone();
     	rr52.Restraint_Position_Time__c ='Physical Holds Only 21-30';
     	rrList.add(rr52);
     	RestraintReportTemp__c rr53 = rr41.clone();
     	rr53.Restraint_Position_Time__c ='Physical Holds Only 31-40';
     	rrList.add(rr53);
     	RestraintReportTemp__c rr54 = rr41.clone();
     	rr54.Restraint_Position_Time__c ='Physical Holds Only 41-50';
     	rrList.add(rr54);
     	RestraintReportTemp__c rr55 = rr41.clone();
     	rr55.Restraint_Position_Time__c ='Physical Holds Only 51-60';
     	rrList.add(rr55);
     	RestraintReportTemp__c rr56 = rr41.clone();
     	rr56.Restraint_Position_Time__c ='Physical Holds Only >60';
     	rrList.add(rr56);
        
        try{
     	insert rrList;
        }
        catch(exception ex){
            System.Assert(ex.getMessage().contains('match'));
        }       
     	
     /*	Restraint_Report__c rrResult = [Select Id,Name,Standing_0_5__c From Restraint_Report__c Where Standing_0_5__c > 0 limit 1];
     	
     	system.assert(rrResult != null);
        system.assert(rrResult.Standing_0_5__c == 2);
      */
     	Test.startTest();    	
     	string SOQL = 'Select Id,Name from RestraintReportTemp__c';
        Database.executeBatch(new Batch_CleanRestraintReportTemp(SOQL),60);  
        Test.stopTest();
        
        List<RestraintReportTemp__c> rrResult2 = [Select Id,Name From RestraintReportTemp__c Where Id = :rr1.Id];
        
     	system.assertEquals(rrResult2.size(),0);



     }

}