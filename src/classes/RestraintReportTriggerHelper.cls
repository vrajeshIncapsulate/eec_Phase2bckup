public with sharing class RestraintReportTriggerHelper {
	
	//Created by LD - LEAD-2043
    public static void bulkRestraintReport(List<RestraintReportTemp__c> triggerNew){
    	
    	
    	/*
    	Object -> RestraintReportTemp__c
    	
    	Restraint_Count__c
		RestraintId__c
		Restraint_Method__c
		Restraint_Position_Time__c
		Restraint_Quarter__c
		RestraintYear__c
		Submitted_By__c
		Submitted_Date__c
		DYSMethod
		
		*/
    	
    	Set<string> ProgramIds = new Set<string>();
    	Set<string> ProgramIdRestraintId = new Set<string>();
    	Set<string> submittedByNames = new Set<string>();
    	Set<Id> AccountIds = new Set<Id>();

    	integer prevPId = 0;
    	integer currPId = 0;
    	
    	for (RestraintReportTemp__c nc : triggerNew) {
    		
    		currPId = integer.valueof(nc.ProgramId__c.trim());
    		
    		if(currPId != prevPId){
    		   ProgramIds.add(nc.ProgramId__c.trim()); 
    		   ProgramIdRestraintId.add(nc.ProgramId__c.trim() + '|' + nc.RestraintId__c); 
    		   prevPId = currPId;
    		   currPId = 0;
    		   submittedByNames.add(nc.Submitted_By__c);
    		}
    				
    	}
    	
    	List<Restraint_Report__c> RestraintsToInsert = new List<Restraint_Report__c>();
    	
    	Map<Id,Account> AccountMap = new Map<Id,Account>([Select Id,Name, Provider_No__c,RecordTypeId From Account Where Provider_No__c in :ProgramIds]);
    	Map<string,Account> ProgramIdMap = new Map<string,Account>();
    	for(Account a: AccountMap.values()){
    		ProgramIdMap.put(a.Provider_No__c,a);
    		AccountIds.add(a.Id);
    	}
    	
    	//Map<Id,Contact> ContactMap = new Map<Id,Contact>([Select Id,Name, AccountId From Contact Where Name in :submittedByNames]);
    	Map<Id,Contact> ContactMap = new Map<Id,Contact>([Select Id,Name, AccountId From Contact Where AccountId in :AccountIds]);
    	Map<string,Contact> ContactIdMap = new Map<string,Contact>();
    	for(Contact c: ContactMap.values()){
    		ContactIdMap.put(c.Name,c);
    	}
    	
        string prevRestraint = null;
        string newRestraint = null;
        string ncStr = null;
        Restraint_Report__c rr;
        Id DYSRestraint = [Select id,Name from RecordType where sObjectType = 'Restraint_Report__c' and isActive = true and Name like 'DYS Restraint'].Id;
        Id OtherRestraint = [Select id,Name from RecordType where sObjectType = 'Restraint_Report__c' and isActive = true and Name like 'Other Restraint'].Id;
        
    	for (RestraintReportTemp__c nc : triggerNew) {
    		
    		newRestraint = nc.ProgramId__c.trim() + '|' + nc.RestraintId__c;	    		       		
    		
	    		Account acc = ProgramIdMap.get(nc.ProgramId__c);	
	    		
	    		if(acc != null){
	    			system.debug('*** Account Exists...');
			
	    		   if(newRestraint != prevRestraint){	    		      
	    		      prevRestraint = null;	
	    		      rr = new Restraint_Report__c();
	    		  }
	    		  
	    		   if(nc.RestraintRecordType__c.trim() == 'Other Restraint'){
	    		      rr.RecordTypeId = OtherRestraint;
	    		      system.debug('*** OtherRestraint...');
	    		   }
	    		   else{
	    		   	  rr.RecordTypeId = DYSRestraint;
	    		   }
	    		   
	    		   rr.Provider__c = acc.Id;
	    		   rr.Calendar_Year__c = nc.RestraintYear__c;
	    		   rr.Submitted_Date__c = nc.Submitted_Date__c;
	    		   rr.Quarter__c = nc.Restraint_Quarter__c;
	    		   rr.Restraint_Method2__c = nc.Restraint_Method__c;
	    		   
	    		   //Injury Info.
	    		   
	    		   
	    		   rr.Injured_Residents_Minor_Injury__c = (nc.Injured_Residents_Minor_Injury__c != null ? nc.Injured_Residents_Minor_Injury__c : 0);
	    		   rr.Injured_Residents_Serious_Injury__c = (nc.Injured_Residents_Serious_Injury__c != null ? nc.Injured_Residents_Serious_Injury__c : 0);
	    		   rr.Injured_Staff_Minor_Injury__c = (nc.Injured_Staff_Minor_Injury__c != null ? nc.Injured_Staff_Minor_Injury__c : 0);
	    		   rr.Injured_Staff_Serious_Injury__c = (nc.Injured_Staff_Serious_Injury__c != null ? nc.Injured_Staff_Serious_Injury__c : 0);
	    		   
	    		   //Other Restraints Stats Info.
	    		   rr.No_Restraints_Leading_to_Res_Injury__c = (nc.No_Restraints_Leading_to_Res_Injury__c != null ? nc.No_Restraints_Leading_to_Res_Injury__c : 0);
	    		   rr.No_Restraints_Leading_to_Staff_Injury__c = (nc.No_Restraints_Leading_to_Staff_Injury__c != null ? nc.No_Restraints_Leading_to_Staff_Injury__c : 0);
	    		   rr.Unduplicated_Count_of_Residnts_Restraind__c = (nc.Unduplicated_Count_of_Residents_Restr__c != null ? nc.Unduplicated_Count_of_Residents_Restr__c : 0);
	    		   rr.Unduplicated_Count_of_Residents_Served__c = (nc.Unduplicated_Count_of_Residents_Served__c != null ? nc.Unduplicated_Count_of_Residents_Served__c : 0);
	    		   rr.Total_Bed_Days_Utilized_this_Quarter__c = (nc.Total_Bed_Days_Utilized_this_Quarter__c != null ? Integer.valueOf(nc.Total_Bed_Days_Utilized_this_Quarter__c) : 0);
	    		   
	    		   
	    		   
	    		   Contact ct = ContactIdMap.get(nc.Submitted_By__c);
	    		   if(ct != null){
	    		   	  if (ct.AccountId == acc.Id){
	    		         rr.Contact_Submitted_By__c = ct.Id;
	    		   	  }
	    		   }
	    		   
	    		   
	    		   //Restraint Position Time info.
	    		   if (nc.Restraint_Position_Time__c != null){
	    		   	 
	    		   	 //Postion = Standing
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Standing 0-5'){
	    		   	 	rr.Standing_0_5__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Standing 6-10'){
	    		   	 	rr.Standing_6_10__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Standing 11-20'){
	    		   	 	rr.Standing_11_20__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Standing 21-30'){
	    		   	 	rr.Standing_21_30__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Standing 31-40'){
	    		   	 	rr.Standing_31_40__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Standing 41-50'){
	    		   	 	rr.Standing_41_50__c = nc.Restraint_Count__c;
	    		   	 }
	    		     if (nc.Restraint_Position_Time__c.trim() == 'Standing 51-60'){
	    		   	 	rr.Standing_51_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Standing >60'){
	    		   	 	rr.Standing_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 
	    		   	 //Postion = Sitting
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Sitting 0-5'){
	    		   	 	rr.Sitting_0_5__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Sitting 6-10'){
	    		   	 	rr.Sitting_6_10__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Sitting 11-20'){
	    		   	 	rr.Sitting_11_20__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Sitting 21-30'){
	    		   	 	rr.Sitting_21_30__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Sitting 31-40'){
	    		   	 	rr.Sitting_31_40__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Sitting 41-50'){
	    		   	 	rr.Sitting_41_50__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Sitting 51-60'){
	    		   	 	rr.Sitting_51_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Sitting >60'){
	    		   	 	rr.Sitting_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 
	    		   	 
	    		   	 //Postion = Floor (Supine)
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Supine) 0-5'){
	    		   	 	rr.Floor_Supine_0_5__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Supine) 6-10'){
	    		   	 	rr.Floor_Supine_6_10__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Supine) 11-20'){
	    		   	 	rr.Floor_Supine_11_20__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Supine) 21-30'){
	    		   	 	rr.Floor_Supine_21_30__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Supine) 31-40'){
	    		   	 	rr.Floor_Supine_31_40__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Supine) 41-50'){
	    		   	 	rr.Floor_Supine_41_50__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Supine) 51-60'){
	    		   	 	rr.Floor_Supine_51_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Supine) >60'){
	    		   	 	rr.Floor_Supine_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 
	    		   	 //Postion = Floor (Prone)
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Prone) 0-5'){
	    		   	 	rr.Floor_Prone_0_5__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Prone) 6-10'){
	    		   	 	rr.Floor_Prone_6_10__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Prone) 11-20'){
	    		   	 	rr.Floor_Prone_11_20__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Prone) 21-30'){
	    		   	 	rr.Floor_Prone_21_30__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Prone) 31-40'){
	    		   	 	rr.Floor_Prone_31_40__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Prone) 41-50'){
	    		   	 	rr.Floor_Prone_41_50__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Prone) 51-60'){
	    		   	 	rr.Floor_Prone_51_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Prone) >60'){
	    		   	 	rr.Floor_Prone_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 
	    		   	  	 //Postion = Floor (Both Prone and Supine)
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Both Prone and Supine) 0-5'){
	    		   	 	rr.Floor_Both_Prone_and_Supine_0_5__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Both Prone and Supine) 6-10'){
	    		   	 	rr.Floor_Both_Prone_and_Supine_6_10__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Both Prone and Supine) 11-20'){
	    		   	 	rr.Floor_Both_Prone_and_Supine_11_20__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Both Prone and Supine) 21-30'){
	    		   	 	rr.Floor_Both_Prone_and_Supine_21_30__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Both Prone and Supine) 31-40'){
	    		   	 	rr.Floor_Both_Prone_and_Supine_31_40__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Both Prone and Supine) 41-50'){
	    		   	 	rr.Floor_Both_Prone_and_Supine_41_50__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Both Prone and Supine) 51-60'){
	    		   	 	rr.Floor_Both_Prone_and_Supine_51_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Floor (Both Prone and Supine) >60'){
	    		   	 	rr.Floor_Both_Prone_and_Supine_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 
	    		   	 //Postion = Physical & Mechanical
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical & Mechanical 0-5'){
	    		   	 	rr.Physical_Mechanical_0_5__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical & Mechanical 6-10'){
	    		   	 	rr.Physical_Mechanical_6_10__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical & Mechanical 11-20'){
	    		   	 	rr.Physical_Mechanical_11_20__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical & Mechanical 21-30'){
	    		   	 	rr.Physical_Mechanical_21_30__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical & Mechanical 31-40'){
	    		   	 	rr.Physical_Mechanical_31_40__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical & Mechanical 41-50'){
	    		   	 	rr.Physical_Mechanical_41_50__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical & Mechanical 51-60'){
	    		   	 	rr.Physical_Mechanical_51_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical & Mechanical >60'){
	    		   	 	rr.Physical_Mechanical_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 
	    		   	 //Postion = Physical Holds Only
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical Holds Only 0-5'){
	    		   	 	rr.Physical_Holds_Only_0_5__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical Holds Only 6-10'){
	    		   	 	rr.Physical_Holds_Only_6_10__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical Holds Only 11-20'){
	    		   	 	rr.Physical_Holds_Only_11_20__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical Holds Only 21-30'){
	    		   	 	rr.Physical_Holds_Only_21_30__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical Holds Only 31-40'){
	    		   	 	rr.Physical_Holds_Only_31_40__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical Holds Only 41-50'){
	    		   	 	rr.Physical_Holds_Only_41_50__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical Holds Only 51-60'){
	    		   	 	rr.Physical_Holds_Only_51_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 if (nc.Restraint_Position_Time__c.trim() == 'Physical Holds Only >60'){
	    		   	 	rr.Physical_Holds_Only_60__c = nc.Restraint_Count__c;
	    		   	 }
	    		   	 
	    		   	 
	    		   }// end of Setting Restraint Position Count
	    		
	    		   if(newRestraint != prevRestraint){
	    		       RestraintsToInsert.add(rr);
	    		    }
	    		    prevRestraint = nc.ProgramId__c.trim() + '|' + nc.RestraintId__c;
	 		
	    	      } 
    		  newRestraint = null; 	      
    	      
          }
          
          if(RestraintsToInsert.size() > 0){
          	system.debug('***Restraints Inserted...'+ RestraintsToInsert);
          	insert RestraintsToInsert;   	
          }
 
    string queryStr = 'Select Id from RestraintReportTemp__c';
    Database.executeBatch(new Batch_CleanRestraintReportTemp(queryStr),200);  
         
    }

}