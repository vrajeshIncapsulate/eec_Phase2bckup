public with sharing class EEC_GenerateVisitChecklistExtension extends EEC_GeneratePDFBase {

  public List<VisitChecklistItemWrapper> nonCompliantAssessedItems { get; set; }
  public List<VisitChecklistItemWrapper> compliantAssessedItems { get; set; }
  public List<VisitChecklistItemWrapper> compliantnoobservation { get; set; }
  public Map<String, Integer> domainComplianceCountMap { get; set; }
  public Map<String, Integer> domainComplianceTotalCountMap { get; set; }
  public Integer assessedItemsTotal { get; set; }
  public List<Inspection_Item__c> compliantwithobservation { get; set; }
  public List<Inspection_Item__c> compliantwithoutobservation { get; set; }

  public EEC_GenerateVisitChecklistExtension(ApexPages.StandardController stdController) {
    super(stdController);
    // Get the assessed items.
    nonCompliantAssessedItems = getAssessedStandardInspectionItemsWithStatus('Non-Compliant');
    compliantAssessedItems = getComplianceitemsWithObservation('Compliant');
    compliantnoobservation = getComplianceitemsWithoutObservation('Compliant');
  }

  public List<VisitChecklistItemWrapper> getAssessedStandardInspectionItems() {
    List<Inspection_Item__c> rows = [
                                     SELECT Associated_regulation__r.Name,Non_Assessed_Item__c,  Standard_Inspection_Item__c, Standard_Inspection_Item__r.Description__c,Visit_Mode_Ranking__c,
                                     Inspection_Item_Name__c, Category_list__c, Additional_Inspection_Item_Name__c, Category_standard__c, Inspection_Result__c, Observations__c,
                                     Category_additional__c
                                     FROM Inspection_Item__c
                                     WHERE Inspection_No__c = :visit.Id AND Non_Assessed_Item__c = false ];

    return augmentStandardInspectionItems(rows);
  }

  public List<VisitChecklistItemWrapper> getUnassessedStandardInspectionItems() {
    List<Inspection_Item__c> rows = [
                                     SELECT Associated_regulation__r.Name,Non_Assessed_Item__c, Standard_Inspection_Item__c, Inspection_Item_Name__c, Standard_Inspection_Item__r.Description__c,
                                     Additional_Inspection_Item_Name__c, Category_list__c, Category_standard__c, Observations__c, Category_additional__c
                                     FROM Inspection_Item__c
                                     WHERE Inspection_No__c = :visit.Id AND Non_Assessed_Item__c = true];

    return augmentStandardInspectionItems(rows);
  }

  /**
   * getTypeOfVisitHeaderText
   *
   * @description This function will determine the type of header text that should show up on V2 of the checklist pdf.
   * @author Darkis
   * @return String  
   */
  public String getTypeOfVisitHeaderText() {
    String typeOfVisit = this.visit.Type_of_Visit__c;

    if (typeOfVisit.equalsIgnoreCase('Monitoring') || typeOfVisit.equalsIgnoreCase('Enhanced Monitoring')) {
      return '';
    }

    if (typeOfVisit.contains('Renewal')) {
      return 'Renewal -';
    }
    return typeOfVisit + ' -';
  }

  public Boolean getNonComplaintAvailable() {
    return nonCompliantAssessedItems.size() > 0 ? true : false;
  }

  public Boolean getComplaintAvailable() {
    return compliantAssessedItems.size() > 0 ? true : false;
  }
  public Boolean getComplaintNoobservationAvailable() {
    return compliantnoobservation.size() > 0 ? true : false;
  }

  public Boolean getTechnicalAssistanceAvailable() {
    return this.getAdditionalInspectionItems().size() > 0 ? true : false;
  }

  public Set<String> getVisitOutcomesSummary() {
    // Get all assessed items for the visit.
    List<VisitChecklistItemWrapper> assessedItems = getAssessedStandardInspectionItems();
    assessedItemsTotal = assessedItems.size();
    List<String> applicableDomains = new List<String> ();
    domainComplianceCountMap = new Map<String, Integer> ();
    domainComplianceTotalCountMap = new Map<String, Integer> ();
    // 1. Loop through items
    for (VisitChecklistItemWrapper visitItemWrapper : assessedItems) {
      String domain = visitItemWrapper.inspectionItem.Category_list__c;
      // 2. Check if the item is observed compliant
      String result = String.valueOf(visitItemWrapper.inspectionItem.Inspection_Result__c);
      if (!String.isBlank(result) && result.equalsIgnoreCase('compliant')) {
        // 3. If Complaint then increment the mapping total.
        if (domainComplianceCountMap.containsKey(domain)) {
          domainComplianceCountMap.put(domain, domainComplianceCountMap.get(domain) + 1);
        } else {
          domainComplianceCountMap.put(domain, 1);
        }
      }

      if (!String.isBlank(result) && !domainComplianceCountMap.containsKey(domain)) {
        domainComplianceCountMap.put(domain, 0);
      }
	  if(!String.isBlank(result) && (result.equalsIgnoreCase('compliant') || result.equalsIgnoreCase('non-compliant'))){
          if (domainComplianceTotalCountMap.containsKey(domain)) {
            domainComplianceTotalCountMap.put(domain, domainComplianceTotalCountMap.get(domain) + 1);
          }
          else {
            domainComplianceTotalCountMap.put(domain, 1);
      	  }   
      }
      else if(!String.isBlank(result) && !domainComplianceTotalCountMap.containsKey(domain)){
            domainComplianceTotalCountMap.put(domain, 0);
      }  
    }
    // 4. Return the string list of domains that will then use the mapping to present the result. 
    return domainComplianceCountMap.keySet();
  }

  public List<Visit_Best_Practices__c> getVisitBestPractices() { 
    return[Select Best_Practice_Guidance__c, Observation__c, Best_Practice__r.Domain__c From Visit_Best_Practices__c Where Associated_Visit__c = : visit.Id];
  }

  private List<VisitChecklistItemWrapper> getAssessedStandardInspectionItemsWithStatus(String status) {
    List<Inspection_Item__c> rows = [
                                     SELECT Associated_regulation__r.Name,Non_Assessed_Item__c, Standard_Inspection_Item__c, Standard_Inspection_Item__r.Description__c,Visit_Mode_Ranking__c,
                                     Inspection_Item_Name__c, Category_list__c, Additional_Inspection_Item_Name__c, Category_standard__c, Inspection_Result__c, Observations__c,
                                     Category_additional__c
                                     FROM Inspection_Item__c
                                     WHERE Inspection_No__c = :visit.Id AND Non_Assessed_Item__c = false AND Inspection_Result__c = :status order by Visit_Mode_Ranking__c asc nulls last];

    return augmentStandardInspectionItems(rows);
  }
  private List<VisitChecklistItemWrapper> getComplianceitemsWithObservation(String status) {
  	compliantwithobservation=new list<Inspection_Item__c>();
    for(Inspection_Item__c Items : [SELECT Associated_regulation__r.Name,Non_Assessed_Item__c, Standard_Inspection_Item__c, Standard_Inspection_Item__r.Description__c,Visit_Mode_Ranking__c,
                                     Inspection_Item_Name__c, Category_list__c, Additional_Inspection_Item_Name__c, Category_standard__c, Inspection_Result__c, Observations__c,
                                     Category_additional__c
                                     FROM Inspection_Item__c
                                     WHERE Inspection_No__c = :visit.Id AND Non_Assessed_Item__c = false AND Inspection_Result__c = :status order by Visit_Mode_Ranking__c asc nulls last])
          {
          	if(String.isNotBlank(items.Observations__c)){
            	compliantwithobservation.add(items);
            }
                                     
       }

    return augmentStandardInspectionItems(compliantwithobservation);
  }
  private List<VisitChecklistItemWrapper> getComplianceitemsWithoutObservation(String status) {
  	compliantwithoutobservation=new list<Inspection_Item__c>();
    for(Inspection_Item__c Items : [SELECT Associated_regulation__r.Name,Non_Assessed_Item__c, Standard_Inspection_Item__c, Standard_Inspection_Item__r.Description__c,Visit_Mode_Ranking__c,
                                     Inspection_Item_Name__c, Category_list__c, Additional_Inspection_Item_Name__c, Category_standard__c, Inspection_Result__c, Observations__c,
                                     Category_additional__c
                                     FROM Inspection_Item__c
                                     WHERE Inspection_No__c = :visit.Id AND Non_Assessed_Item__c = false AND Inspection_Result__c = :status order by Visit_Mode_Ranking__c asc nulls last])
          {
          	if(String.isBlank(items.Observations__c)){
            	compliantwithoutobservation.add(items);
            }
                                     
       }

    return augmentStandardInspectionItems(compliantwithoutobservation);
  }
}