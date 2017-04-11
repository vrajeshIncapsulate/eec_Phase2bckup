public class EEC_NonComplaintItemRegulationTgrHandler {
	private static list<Non_Compliant__c> updatelist = new list <Non_Compliant__c>();
	 private static set<id> NCIRid = new set<id>();
	 private static set<id> Invid = new set<id>();
	 private static set<id> NCid = new set<id>();
	 private static map<id,Non_Compliant__c> NCMap = new map <id,Non_Compliant__c>();
	 private static boolean flag = false ;
	public static void UpdateKeyIndicator(Map<Id,Non_Compliant_Item_Regulation__c> NewMap, Map<Id,Non_Compliant_Item_Regulation__c> OldMap){
	
	for(Non_Compliant_Item_Regulation__c NCIR : NewMap.values()){
			NCIRid.add(NCIR.id);
			NCid.add(NCIR.Non_Compliant_Item__c);
	   }
	list<Non_Compliant_Item_Regulation__c> NCIRlist = new list <Non_Compliant_Item_Regulation__c>([select id,name,Non_Compliant_Item__c,Non_Compliant_Item__r.Key_Indicator__c,Non_Compliant_Item__r.Investigation__r.id,
	                                                Non_Compliant_Item__r.Investigation__r.Provider_No__r.name,Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_R_P__c,Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_GSA__c,
	                                                Non_Compliant_Item__r.Investigation__r.Provider_No__r.recordtype.name,
	                                                Regulation__c,Regulation__r.FCC_High_Risk_Reg__c,Regulation__r.R_P_High_Risk_Reg__c,Regulation__r.GSA_High_Risk_Reg__c
	                                                from Non_Compliant_Item_Regulation__c where Non_Compliant_Item__c IN: NCid]);
	
	list<Non_Compliant__c> NClist = new list<Non_Compliant__c>([select id,name,Key_Indicator__c from Non_Compliant__c where id IN: NCid]);
	for(Non_Compliant__c NC : NClist){
	     NCMap.put(NC.id,NC);
	}
	for(Non_Compliant_Item_Regulation__c NC : NCIRlist){
		system.debug('Record Type of Provider'+NC.Non_Compliant_Item__r.Investigation__r.Provider_No__r.recordtype.name);
		if(NC.Non_Compliant_Item__r.Investigation__r.Provider_No__r.recordtype.name == 'Family Child Care' && NC.Regulation__r.FCC_High_Risk_Reg__c ==true && flag==false){
		    NCMap.get(NC.Non_Compliant_Item__c).Key_Indicator__c = true;
		    flag = true;
		}else if (NC.Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_R_P__c == true && NC.Regulation__r.R_P_High_Risk_Reg__c==true){
	        NCMap.get(NC.Non_Compliant_Item__c).Key_Indicator__c = true;
		    flag = true;
		}else if(NC.Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_GSA__c == true && NC.Regulation__r.GSA_High_Risk_Reg__c==true){
		    NCMap.get(NC.Non_Compliant_Item__c).Key_Indicator__c = true;
		    flag = true;
		}
		else{
		if(flag == false)
		    NCMap.get(NC.Non_Compliant_Item__c).Key_Indicator__c = false;
		}
		
	}
	system.debug('Update Map'+NCMap.size());
	if(NCMap.size()>0){
	 update NCMap.values();
	}
  
	}
	
	public static void UpdateKeyOnDelete(Map<Id,Non_Compliant_Item_Regulation__c> NewMap, Map<Id,Non_Compliant_Item_Regulation__c> OldMap){
	
  for(Non_Compliant_Item_Regulation__c NCIR : OldMap.values()){
			NCIRid.add(NCIR.id);
			NCid.add(NCIR.Non_Compliant_Item__c);
    }
	list<Non_Compliant_Item_Regulation__c> NCIRlist = new list <Non_Compliant_Item_Regulation__c>([select id,name,Non_Compliant_Item__c,Non_Compliant_Item__r.Key_Indicator__c,Non_Compliant_Item__r.Investigation__r.id,
	                                                Non_Compliant_Item__r.Investigation__r.Provider_No__r.name,Non_Compliant_Item__r.Investigation__r.Provider_No__r.recordtype.name,
	                                                Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_R_P__c,Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_GSA__c,
	                                                Regulation__c,Regulation__r.FCC_High_Risk_Reg__c,Regulation__r.R_P_High_Risk_Reg__c,Regulation__r.GSA_High_Risk_Reg__c 
	                                                from Non_Compliant_Item_Regulation__c where Non_Compliant_Item__c IN: NCid]);
	
	list<Non_Compliant__c> NClist = new list<Non_Compliant__c>([select id,name,Key_Indicator__c from Non_Compliant__c where id IN: NCid]);
	for(Non_Compliant__c NC : NClist){
	        NCMap.put(NC.id,NC);
	}
	for(Non_Compliant_Item_Regulation__c NC : NCIRlist){
		system.debug('Record Type of the Provider'+NC.Non_Compliant_Item__r.Investigation__r.Provider_No__r.recordtype.name);
	  if(NC.Non_Compliant_Item__r.Investigation__r.Provider_No__r.recordtype.name == 'Family Child Care' && NC.Regulation__r.FCC_High_Risk_Reg__c ==true && flag==false){
		      NCMap.get(NC.Non_Compliant_Item__c).Key_Indicator__c = true;
		      flag = true;
		}else if (NC.Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_R_P__c == true && NC.Regulation__r.R_P_High_Risk_Reg__c==true){
	          NCMap.get(NC.Non_Compliant_Item__c).Key_Indicator__c = true;
		       flag = true;
		}else if(NC.Non_Compliant_Item__r.Investigation__r.Provider_No__r.Is_GSA__c == true && NC.Regulation__r.GSA_High_Risk_Reg__c==true){
		      NCMap.get(NC.Non_Compliant_Item__c).Key_Indicator__c = true;
		      flag = true;
		}
		else{
		 if(flag == false){
		      NCMap.get(NC.Non_Compliant_Item__c).Key_Indicator__c = false;
		      system.debug('Key Indicator'+NCMap.get(NC.Non_Compliant_Item__c).Key_Indicator__c);
		 }
		}
		
	}
	system.debug('Update Map'+NCMap.size());
	if(NCMap.size()>0){
	     update NCMap.values();
	}
  
	
	}
    
}