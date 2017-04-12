public with sharing class EEC_ToolVisitItems {
        public ID Toolid;
        private final Standard_Checklist_Reference__c Toolrecord;
        public list< Junction_ChklInsp__c>ToolItemList=new list<Junction_ChklInsp__c>();
        public list< Junction_ChklInsp__c>Totallist=new list<Junction_ChklInsp__c>();
        public list< Junction_InspReg__c>RegList=new list<Junction_InspReg__c>();
        public boolean key=false;
        public list< Standard_Inspection_Item__c>Stditemlist=new list<Standard_Inspection_Item__c>();
        public Set<Id> siSet = new Set<Id> ();
        public List<ToolWrapper> ToolWrapperlist { get; set; }
        public string applicableto;
        
        public EEC_ToolVisitItems(ApexPages.StandardController controller){
                this.Toolrecord = (Standard_Checklist_Reference__c) controller.getRecord();
                Toolid = Toolrecord.id;
                //applicableto=toolrecord.Applicable_To__c;
                system.debug('MMMMM'+Toolid);
                ToolItemList();
        }
        public pageReference redirect(){
                pageReference PREF= new pageReference('/'+Toolid);
                return PREF;
        }
    public class ToolWrapper implements Comparable {
        public Id Id { get; set; }
        public Standard_Inspection_Item__c sinspobj { get; set; }
        public String name { get; set; }
        public Integer rowIndex { get; set; }
        public String description { get; set; }
        public String domain { get; set; }
        public boolean nonassesseditem { get; set; }
        public boolean randomitem { get; set; }
        public boolean KeyIndicator { get; set; }
        public boolean FCCKey { get; set; }
        public boolean GSAKey { get; set; }
        public boolean RPKey { get; set; }
        public list< Junction_ChklInsp__c>ToolItemListW=new list<Junction_ChklInsp__c>();
        public list< Junction_ChklInsp__c>ToolItemList=new list<Junction_ChklInsp__c>();
        public Map<String, Id> regulationMap { get; set; }
        public String guidance { get; set; }
        public String applicableto { get; set; }
        public Id TId { get; set; }
        public Decimal ModeRank { get; set; }
        public Map<Id,Regulation__c> Checkmap{get;set;}
        
        public Integer compareTo(Object compareTo){
        	ToolWrapper WrapCompare = (ToolWrapper)compareTo;
        	system.debug('AAAAAA');
        	if(ModeRank<WrapCompare.ModeRank){
                return -1;
              }
           	else if(ModeRank>WrapCompare.ModeRank){
                return 1;
           	}
            else {
                if(KeyIndicator)
                 return -1;
               else if(WrapCompare.KeyIndicator)
                 return 1;
               else{
               	 if(randomitem){
               	 	 return 1;
               	 }else if(WrapCompare.randomitem){ 
               	 	 return -1;
               	}else{
                 if(name>WrapCompare.name){
                 	return -1;
                 }else if(name<WrapCompare.name){
                 	return 1;
                }else{
                	return 0;
               }
             }
           }
         }
      }
        public ToolWrapper(Standard_Inspection_Item__c sinsp, Map<Id, Map<String, String>> iRegMap,map<id,Junction_ChklInsp__c>titemmap,Map<id,map<id,Regulation__c>> STRmap,string Tool) {
                this.Id = sinsp.Id;
                this.sinspobj=sinsp;
                this.name = sinsp.name;
                this.description = sinsp.Description__c;
                this.rowIndex = rowIndex;
                //this.regulationMap = null;
                this.regulationMap = iRegMap.get(Id);
                this.checkmap=STRmap.get(Id);
                system.debug('Checkmap'+this.checkmap);
                this.keyindicator=false;
                this.FCCkey=false;
                this.GSAkey=false;
                this.RPkey=false;
                this.guidance = sinsp.Guidance__c;
                this.applicableto=tool;
                //this.Tid= tool.id;
                //ToolItemListW=[select id,name,Standard_Checklist_Reference__c,Random_Item__c,Random_Item_Domain__c,Standard_Inspection_Item__c from Junction_ChklInsp__c where Standard_Inspection_Item__c=:this.Id and Standard_Checklist_Reference__c =: this.tid and Random_Item__c=true];
                     if(titemmap.get(this.id).Random_Item__c==false){
                         this.domain = sinsp.Category__c;
                       }else{
                         this.domain = titemmap.get(this.id).Random_Item_Domain__c;
                       }
                       
                      if(titemmap.get(this.id).Visit_Mode_Ranking__c == null){
                         this.ModeRank = 99999;
                       }else{
                         this.ModeRank = titemmap.get(this.id).Visit_Mode_Ranking__c;
                       }
                       
                         this.nonassesseditem = titemmap.get(this.id).Non_Assessed_Item__c;
                         this.randomitem = titemmap.get(this.id).Random_Item__c;
                         system.debug('Assessed'+this.nonassesseditem);
           if(STRmap.get(this.Id) != null){     
            for(Regulation__c r: STRmap.get(this.Id).values()){
                if(!this.keyindicator && r.FCC_High_Risk_Reg__c && this.applicableto.contains('Family Child Care')){
                    this.keyindicator=true;
                }else
                if(!this.keyindicator && r.GSA_High_Risk_Reg__c&& (this.applicableto.contains('Large Group')||this.applicableto.contains('Small Group'))){
                 this.keyindicator=true;
                }else
                if(!this.keyindicator && r.R_P_High_Risk_Reg__c && (this.applicableto.contains('Foster Care Agency')||this.applicableto.contains('Adoption Agency')||this.applicableto.contains('Temporary Shelter')||this.applicableto.contains('Group Care'))){
                this.keyindicator=true;
                }
            }
           }
            /*for(Junction_ChklInsp__c J: [select id,name,Standard_Checklist_Reference__c,Standard_Checklist_Reference__r.Applicable_To__c,Standard_Inspection_Item__c from Junction_ChklInsp__c where Standard_Inspection_Item__c =: this.id and Standard_Checklist_Reference__c =:this.tid]){
                if(J.Standard_Checklist_Reference__r.Applicable_To__c.contains('Family Child Care') &&this.FCCkey){
                this.keyindicator=true;
                }else
                if(J.Standard_Checklist_Reference__r.Applicable_To__c.contains('Small Group')||J.Standard_Checklist_Reference__r.Applicable_To__c.contains('Large Group')&& this.GSAkey){
                this.keyindicator=true;
                }
            
            }*/
            
        }
        }
    
        public list<ToolWrapper> ToolItemList(){
                ToolWrapperlist = new list<ToolWrapper>();
                ToolItemList=[select id,name,Standard_Checklist_Reference__c,Standard_Inspection_Item__c,Standard_Checklist_Reference__r.Applicable_To__c,Random_Item__c from Junction_ChklInsp__c where Standard_Checklist_Reference__c=:Toolid];
                
        for(Junction_ChklInsp__c TL :ToolItemList ){
                siSet.add(TL.Standard_Inspection_Item__c);
                applicableto=TL.Standard_Checklist_Reference__r.Applicable_To__c;
        }
        TotalList=[select id,name,Standard_Checklist_Reference__c,Standard_Checklist_Reference__r.Applicable_To__c,Visit_Mode_Ranking__c,Non_Assessed_Item__c,Random_Item__c,Random_Item_Domain__c,Standard_Inspection_Item__c from Junction_ChklInsp__c where Standard_Inspection_Item__c in:siSet and Standard_Checklist_Reference__c =: Toolid];
        map<id,Junction_ChklInsp__c> toolitemmap=new map<id,Junction_ChklInsp__c>();
        for(Junction_ChklInsp__c J : Totallist){
        toolitemmap.put(J.Standard_Inspection_Item__c,J);
        }
        Stditemlist=[select id,name,Description__c,Category__c,guidance__c from Standard_Inspection_Item__c where id IN: siSet];
        Map<Id, Map<String, Id>> iregulationMap = new Map<Id, Map<String, String>> ();
        Map<String, String> jiMap;
        Map<id, Regulation__c> jiMap2;
        set<id> regset = new set<id>();
        map<id,Regulation__c> regmap = new map <id,Regulation__c>();
        map<id,map<id,Regulation__c>> SRmap = new map <id,map<id,Regulation__c>>();
            for (Junction_InspReg__c jir :[select Id, Regulation__c, Regulation__r.name, Regulation__r.article__c, Standard_Inspection_Item__c from Junction_InspReg__c where Standard_Inspection_Item__c in :siSet]) {
                        regset.add(jir.Regulation__c);
            if (iregulationMap.containsKey(jir.Standard_Inspection_Item__c)) {
                iregulationMap.get(jir.Standard_Inspection_Item__c).put(jir.Regulation__r.name + ',', jir.Regulation__c);
            }
            else {
                jiMap = new Map<String, String> ();
                jiMap.put(jir.Regulation__r.name + ',', jir.Regulation__c);
                iregulationMap.put(jir.Standard_Inspection_Item__c, jiMap);
            }
         }
         for(Regulation__c R: [select id,name,FCC_High_Risk_Reg__c,GSA_High_Risk_Reg__c,R_P_High_Risk_Reg__c from Regulation__c where id IN: regset]){
                regmap.put(R.id,R);
         }         
         for (Junction_InspReg__c jir :[select Id, Regulation__c, Regulation__r.name, Regulation__r.article__c, Standard_Inspection_Item__c from Junction_InspReg__c where Standard_Inspection_Item__c IN: siset and Regulation__c IN:regset ]) {
                if (SRmap.containsKey(jir.Standard_Inspection_Item__c)) {
                SRmap.get(jir.Standard_Inspection_Item__c).put(jir.Regulation__c, regmap.get(jir.Regulation__c));
            }
            else {
                jiMap2=new Map<id, Regulation__c>();
                jiMap2.put(jir.Regulation__c, regmap.get(jir.Regulation__c));
                SRmap.put(jir.Standard_Inspection_Item__c, jiMap2);
            }
         }         
        
        for(Standard_Inspection_Item__c SI :Stditemlist ){
                system.debug(SI.id+SI.name+'MMMMMMMM');
                ToolWrapper newWrapper = new ToolWrapper(SI, iregulationMap,toolitemmap,SRmap,applicableto);
                ToolWrapperlist.add(newWrapper);
                ToolWrapperlist.sort();
        }
        
   return ToolWrapperlist;
   }
}