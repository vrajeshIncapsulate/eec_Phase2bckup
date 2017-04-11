public with sharing class EEC_GenerateVisitNarrativePDFExtension extends EEC_GeneratePDFBase {
    
    public List<Inspection__c> childVisitsList {get;set;}

    public EEC_GenerateVisitNarrativePDFExtension(ApexPages.StandardController ctr){
        super(ctr);
    }

    public Contact getExecutiveDirectorContact(){
        if(visit.Provider_No__r.Umbrella_Members__c != NULL) {
            List<Contact> acrs = [
                SELECT Contact.Salutation, Contact.FirstName, Contact.LastName
                FROM Contact
                WHERE AccountID = :visit.Provider_No__r.Umbrella_Members__c AND Role__c = 'Director'
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];
            if(acrs.size() > 0) {
                return acrs.get(0);
            }
        }
        else{
        	List<Contact> acrs1 = [
            SELECT Salutation, FirstName, Contact.LastName 
            FROM Contact 
            WHERE AccountID = :visit.Provider_No__r.Umbrella_Members__c AND Role__c like 'Main Contact%' 
            ORDER BY CreatedDate DESC 
            LIMIT 1];
            if(acrs1.size() > 0) {
            	return acrs1.get(0);
            }
        }

        return null;
    }

    public List<VisitChecklistItemWrapper > getCompliantWithObservations(){
       List<Inspection_Item__c> finalRows = new List<Inspection_Item__c>(); 
        
       List<Inspection_Item__c> rows = [
         SELECT Associated_regulation__r.Name, Standard_Inspection_Item__c, Inspection_Item_Name__c, Standard_Inspection_Item__r.Description__c,
           Additional_Inspection_Item_Name__c , Technical_Assistance__c,  Category_additional__c,Visit_Mode_Ranking__c, Observations__c, Name
         FROM Inspection_Item__c
         WHERE Inspection_No__c = :visit.Id AND Inspection_Result__c <> 'Non-Compliant' AND Inspection_Result__c <>'Not Applicable' AND Inspection_Result__c <>'Not Assessed'AND  Inspection_Result__c <>'Non Assessed (tool abandoned)' order by Visit_Mode_Ranking__c asc nulls last];
       
       for(Inspection_Item__c row : rows){
           if(row.Observations__c != NULL && row.Observations__c != ''){
               finalRows.add(row);
           }
       }
        
       // Check for a child and retrieve all the records if they exist.
      if (visit.Mater_Visit_for_Res_Cluster_of_Visits__c == null) {
        // Get all the children ids.
        Set<Id> childIds = new Map<Id, Inspection__c>([Select Id From Inspection__c Where Mater_Visit_for_Res_Cluster_of_Visits__c = :visit.Id]).keySet();
        List<Inspection_Item__c> childRows = [
          SELECT Associated_regulation__r.Name, Standard_Inspection_Item__c,Visit_Mode_Ranking__c, Inspection_Item_Name__c, Standard_Inspection_Item__r.Description__c,
            Additional_Inspection_Item_Name__c , Technical_Assistance__c,  Category_additional__c, Observations__c, Name
          FROM Inspection_Item__c
          WHERE Inspection_No__c IN :childIds AND Inspection_Result__c <> 'Non-Compliant' AND Inspection_Result__c <>'Not Applicable' AND Inspection_Result__c <>'Not Assessed'AND Inspection_Result__c <>'Non Assessed (tool abandoned)' order by Visit_Mode_Ranking__c asc nulls last];
        
        for(Inspection_Item__c row : childRows){
          if(row.Observations__c != NULL && row.Observations__c != ''){
            finalRows.add(row);
          }
        }   
      } 
        return augmentStandardInspectionItems(finalRows);
    }
    
    public List<Inspection__c> getChildVisits() {
      if (visit.Mater_Visit_for_Res_Cluster_of_Visits__c == null) {
        if (childVisitsList == null) {
          childVisitsList = [
            Select 
              Id, 
              Name, 
              Provider_No__r.Name,
              Provider_No__r.RecordType.DeveloperName,
              Address_1__c,
              Address_2__c,
              City__c,
              State__c,
              Zip_Code__c,
              Provider_No__r.Provider_Number__c,
              License_Number__c,
              Provider_No__r.Capacity__c,
              Provider_No__r.Renewal_date__c,
              Provider_No__r.MinAgeServed__c,
              Provider_No__r.MaxAgeServed__c,
              Provider_No__r.RecordType.Name,
              Provider_No__r.Ratios__c,
              Provider_No__r.Awake_Ratio__c,
              Provider_No__r.Asleep_Ratio__c,
              Provider_No__r.Characteristics_of_Children_Served__c,
              Number_of_Foster_Homes__c,
              NumberOfChildrenPlacedInCare__c,
              Mater_Visit_for_Res_Cluster_of_Visits__c
            From Inspection__c Where Mater_Visit_for_Res_Cluster_of_Visits__c = :visit.Id
          ];      
        }
      } else {
        childVisitsList = new List<Inspection__c>();
      }
      return childVisitsList;
    }
}