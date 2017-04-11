public abstract with sharing class EEC_GeneratePDFBase {
    
    protected final Inspection__c visit;

    public EEC_GeneratePDFBase(ApexPages.StandardController stdController) {
        this.visit = (Inspection__c) stdController.getRecord();
    }  
    
    public class VisitChecklistItemWrapper {
        public Inspection_Item__c inspectionItem { get; set; }
        public String standardRegulations { get; set; }
        
        public VisitChecklistItemWrapper(Inspection_Item__c inspItem, String regs) {
            this.inspectionItem = inspItem;
            this.standardRegulations = regs;
        }
    } 
    
    private static Map<ID, Standard_Inspection_Item__c> standardInspectionItems = new Map<ID, Standard_Inspection_Item__c>([
            SELECT Id, (SELECT Regulation__r.Name FROM Junction_InspRegs__r) 
            FROM Standard_Inspection_Item__c]);
            
    public static List<VisitChecklistItemWrapper> augmentStandardInspectionItems(List<Inspection_Item__c> rows) { 
        List<EEC_GeneratePDFBase.VisitChecklistItemWrapper > items = new List<EEC_GeneratePDFBase.VisitChecklistItemWrapper>();
        
        for(Inspection_Item__c row : rows){ 
            String regs = '';
            
            if(row.Standard_Inspection_Item__c != null){
                Standard_Inspection_Item__c sii = standardInspectionItems.get(row.Standard_Inspection_Item__c); 
                    
                for(Junction_InspReg__c jir : sii.Junction_InspRegs__r){
                    if(regs != ''){
                        regs += ', ';
                    }
                
                    regs += jir.Regulation__r.Name;
                }
            }
            
            items.add(new VisitChecklistItemWrapper (row, regs));
        }
            
        return items;
    } 

    public Boolean getHasNonCompliant(){
        List<Inspection_Item__c> rows = [
            SELECT Associated_regulation__r.Name, Standard_Inspection_Item__c, Inspection_Item_Name__c, Standard_Inspection_Item__r.Description__c, 
            Additional_Inspection_Item_Name__c , Category_standard__c, Observations__c, Category_additional__c 
            FROM Inspection_Item__c
            WHERE Inspection_No__c = :visit.Id AND Inspection_Result__c = 'Non-Compliant'];
        
        return rows.size() > 0;    
    }
    
    
    public Contact getDirectorContact() {
        List<Contact> acrs = [
            SELECT Salutation, FirstName, LastName 
            FROM Contact 
            WHERE AccountID = :visit.Provider_No__c AND Role__c = 'Director' 
            ORDER BY CreatedDate DESC 
            LIMIT 1
        ];
        
        if(acrs.size() > 0) {
            return acrs.get(0);
        }
        else{
        	List<Contact> acrs1 = [
            SELECT Salutation, FirstName, Contact.LastName 
            FROM Contact 
            WHERE AccountID = :visit.Provider_No__c AND Role__c like 'Main Contact%' 
            ORDER BY CreatedDate DESC 
            LIMIT 1];
            if(acrs1.size() > 0) {
            	return acrs1.get(0);
            }
        }
        return null;
    }
    
    public List<VisitChecklistItemWrapper > getAdditionalInspectionItems(){
      List<Inspection_Item__c> rows = new List<Inspection_Item__c>();
      // Get the Master objects records.
      for(Inspection_Item__c ii : [SELECT Associated_regulation__r.Name, Standard_Inspection_Item__c, Inspection_Item_Name__c, Standard_Inspection_Item__r.Description__c, 
        Additional_Inspection_Item_Name__c , Technical_Assistance__c,Visit_Mode_Ranking__c,  Category_additional__c 
        FROM Inspection_Item__c
        WHERE Inspection_No__c = :visit.Id order by Visit_Mode_Ranking__c asc nulls last]){
        if(String.isNotBlank(ii.Technical_Assistance__c)){
      	  rows.add(ii);
       	}
      }
      // Check for a child and retrieve all the records if they exist.
      if (visit.Mater_Visit_for_Res_Cluster_of_Visits__c == null) {
        // Get all the children ids.
        List<Inspection__c> lstInsp = [Select Id From Inspection__c Where Mater_Visit_for_Res_Cluster_of_Visits__c = :visit.Id];
        Set<Id> childIds = new Set<Id>();
        for(Inspection__c insp : lstInsp){
              childIds.add(insp.Id);
        }  
        //Set<Id> childIds = new Map<Id, Inspection__c>([Select Id From Inspection__c Where Mater_Visit_for_Res_Cluster_of_Visits__c = :visit.Id]).keySet();
        for(Inspection_Item__c ii : [SELECT Associated_regulation__r.Name, Standard_Inspection_Item__c, Inspection_Item_Name__c, Standard_Inspection_Item__r.Description__c, 
          Additional_Inspection_Item_Name__c , Technical_Assistance__c,  Category_additional__c 
          FROM Inspection_Item__c
          WHERE Inspection_No__c IN :childIds]){
                
          if(String.isNotBlank(ii.Technical_Assistance__c)){
            rows.add(ii);
          }
        }      
      }
      return augmentStandardInspectionItems(rows);
    }
 
}