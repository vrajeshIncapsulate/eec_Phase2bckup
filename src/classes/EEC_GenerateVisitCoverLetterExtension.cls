public with sharing class EEC_GenerateVisitCoverLetterExtension {

    private Inspection__c visit;

    public EEC_GenerateVisitCoverLetterExtension (ApexPages.StandardController ctr){
        visit = (Inspection__c) ctr.getRecord();
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
    
    public String getCoverLetterNarrative() {
      // If the current visit is a child and it's cover letter narrative is blank then use the masters.
      if (visit.Mater_Visit_for_Res_Cluster_of_Visits__c != null && String.isBlank(visit.Cover_Letter_Narrative__c)) {
        return ([Select Cover_Letter_Narrative__c From Inspection__c Where Id = :visit.Mater_Visit_for_Res_Cluster_of_Visits__c]).Cover_Letter_Narrative__c;      
      }  
      return visit.Cover_Letter_Narrative__c;  
    }

}