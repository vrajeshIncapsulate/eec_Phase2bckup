@isTest
private class EEC_Toolvisititemstest {
	static testMethod void testToolvisititem() {
    Standard_Checklist_Reference__c Tool = new Standard_Checklist_Reference__c(Name = 'Test',No_of_Random_Items_Per_Domain_to_Pick__c=2);
    string toolid= Tool.id;
    insert Tool;
    Standard_Inspection_Item__c SI = new Standard_Inspection_Item__c(name='SITEST');
    insert SI;
    Junction_ChklInsp__c JI= new Junction_ChklInsp__c(Standard_Inspection_Item__c=SI.id,Standard_Checklist_Reference__c=Tool.id,Non_Assessed_Item__c=true,Random_Item__c=false);
    insert JI;
    Regulation__c R = new Regulation__c(name='TestR',Date_Active__c=date.today());
    insert R;
    Junction_InspReg__c JR = new Junction_InspReg__c(Standard_Inspection_Item__c=SI.id,Regulation__c=R.id);
    insert JR;
    ApexPages.StandardController sc = new ApexPages.StandardController(Tool);
    EEC_ToolVisitItems ctr = new EEC_ToolVisitItems(sc);
    List<EEC_ToolVisitItems.ToolWrapper> iiWrapperList = new List<EEC_ToolVisitItems.ToolWrapper>();
    Map<Id, Map<String, Id>> iregulationMap = new Map<Id, Map<String, String>> ();
    Map<String, String> jiMap = new map<String, String>();
        Map<id, Regulation__c> jiMap2=new map <id, Regulation__c>();
    for (Junction_InspReg__c jir :[select Id, Regulation__c, Regulation__r.name, Regulation__r.article__c, Standard_Inspection_Item__c from Junction_InspReg__c where Standard_Inspection_Item__c  =:SI.id]) {
			
            if (iregulationMap.containsKey(jir.Standard_Inspection_Item__c)) {
             	iregulationMap.get(jir.Standard_Inspection_Item__c).put(jir.Regulation__r.name + ',', jir.Regulation__c);
            }
            else {
            	jiMap = new Map<String, String> ();
                jiMap.put(jir.Regulation__r.name + ',', jir.Regulation__c);
                iregulationMap.put(jir.Standard_Inspection_Item__c, jiMap);
            }
         }
     map<id,Junction_ChklInsp__c> toolitemmap=new map<id,Junction_ChklInsp__c>();
     for(Junction_ChklInsp__c J : [select id,name,Standard_Checklist_Reference__c,Standard_Checklist_Reference__r.Applicable_To__c,Non_Assessed_Item__c,Random_Item__c,Random_Item_Domain__c,Standard_Inspection_Item__c from Junction_ChklInsp__c where Standard_Inspection_Item__c =:si.id and Standard_Checklist_Reference__c =: Tool.id]){
     	toolitemmap.put(J.Standard_Inspection_Item__c,J);
     	}
     map<id,Regulation__c> regmap = new map <id,Regulation__c>();
     for(Regulation__c Re: [select id,name,FCC_High_Risk_Reg__c,GSA_High_Risk_Reg__c,R_P_High_Risk_Reg__c from Regulation__c where id =: R.id]){
         	regmap.put(Re.id,Re);
         }
    	map<id,map<id,Regulation__c>> SRmap = new map <id,map<id,Regulation__c>>();
    for (Junction_InspReg__c jir :[select Id, Regulation__c, Regulation__r.name, Regulation__r.article__c, Standard_Inspection_Item__c from Junction_InspReg__c where Standard_Inspection_Item__c =: si.id and Regulation__c =:R.id ]) {
         	if (SRmap.containsKey(jir.Standard_Inspection_Item__c)) {
             	SRmap.get(jir.Standard_Inspection_Item__c).put(jir.Regulation__c, regmap.get(jir.Regulation__c));
            }
            else {
            	jiMap2=new Map<id, Regulation__c>();
                jiMap2.put(jir.Regulation__c, regmap.get(jir.Regulation__c));
                SRmap.put(jir.Standard_Inspection_Item__c, jiMap2);
            }
         }
     Test.startTest();
     ctr.ToolItemList();
     iiWrapperList.add(new EEC_ToolVisitItems.ToolWrapper(SI,iregulationmap,toolitemmap,SRMap,toolid));
     ctr.redirect();
    Test.stopTest();
    }
}