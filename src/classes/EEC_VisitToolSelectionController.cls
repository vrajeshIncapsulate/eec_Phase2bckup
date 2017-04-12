public with sharing class EEC_VisitToolSelectionController {
  private final Inspection__c inspectionRecord;
  public List<SCRWrapper> scrWrapperList { get; set; }
  public String justificationText { get; set; }
  public String selectedTool { get; set; }
  public Standard_Checklist_Reference__c recommendedTool { get; set; }
  public Boolean recommendedToolOverrideAvailable { get; set; }
  public List<Inspection_Item__c> providerVisitNonCompliantItems { get; set; }
  public List<Non_Compliant__c> providerNonCompliantItems { get; set; }
  public Integer activeMode { get; set; }
  public Standard_Checklist_Reference__c activeVisitTool { get; set; }
  private Map<Id, List<SIIWrapper>> siiMaps = new Map<Id, List<SIIWrapper>> ();
  private Map<Id, Inspection_Item__c> nonApplicableInspectionsItems = new Map<Id, Inspection_Item__c>();  
  public boolean sf1 {get;set;}  

  private static final Integer MODE_RECOMMENDED_TOOL = 0;
  private static final Integer MODE_SWITCH_TOOL = 1;

  public EEC_VisitToolSelectionController(ApexPages.StandardController controller) {
    this.inspectionRecord = (Inspection__c) controller.getRecord();
    this.recommendedToolOverrideAvailable = false;
    this.activeMode = MODE_RECOMMENDED_TOOL;
    this.sf1 = false;
    try {
      activeMode = Integer.valueOf(ApexPages.currentPage().getParameters().get('mode'));
    } catch(Exception e) {
      System.debug('----> WARNING: Mode passed in was not an Integer or not available. DEFAULTING to edit mode.');
      // If the activeMode is equal to null verify that the visit doesn't have a registered tool.  
      // Get the name of the current page.
      String strurl = ApexPages.currentPage().getUrl();
      if(String.isNotBlank(strurl))  
        strurl = strurl.split('apex/') [1];
      // If the visit tool is available and we're on the switch selection page then activate the switch mode flow.
      if (inspectionRecord.Visit_Tool_Used__c != null && strUrl.contains('EEC_VisitToolSwitchSelection')) {
        // If the visit tool used is populated then we can assume we're in edit mode. 
        activeMode = MODE_SWITCH_TOOL;
      }
    }
  }

  // Get all the visit tools that have the provider and recommendation attached to the visit results.
  // Select Id, Name From Visit_Tool__c Where Applicable_To__c = :inspection.Provider_No__c.Name AND Recommended_for__c = :inspection.Type_of_Visit__c
  public void populateLists() {
    String errorMessage = '';
    scrWrapperList = new List<SCRWrapper> ();
    if (inspectionRecord.Can_be_edited__c) {
      String scrIds = '';
      String scrQuery = 'Select Id, Name,No_of_Random_Items_Per_Domain_to_Pick__c,CopyNonComplainceVisitItems__c , Recommended_for__c, Longer_visit_if_Non_Compliant__c, Order__c From Standard_Checklist_Reference__c Where Active__c = true AND Applicable_To__c includes (\'' + inspectionRecord.Provider_No__r.RecordType.Name + '\') AND Available_for__c includes (\'' + inspectionRecord.Type_of_Visit__c + '\') ORDER BY Order__c ASC';
      System.debug('----> Query: ' + scrQuery);
      List<Standard_Checklist_Reference__c> scrList = Database.Query(scrQuery);
      System.debug('----> Result: ' + scrList);
      if (scrList != null && scrList.size() > 0) {
        // Get the recommended tool.
        System.debug('----> Current Mode: ' + activeMode);

        if (activeMode != null && activeMode == MODE_RECOMMENDED_TOOL) {
          scrList = checkForRecommendedTool(scrList);
          processScrList(scrIds, scrList);
        } else if (activeMode != null && activeMode == MODE_SWITCH_TOOL) {
          scrList = removeCurrentTool(scrList);
          errorMessage = 'No other tools are available for this visit.';

          if (scrList != null && scrList.size() > 0) {
            processScrList(scrIds, scrList);
          }
        }
        List<Inspection_Item__c> lstNonApplicables = [Select Id, Name, Inspection_No__r.Provider_No__c, Standard_Inspection_Item__c,
                                      		RecordType.Name, Category_standard__c, Category_list__c, Inspection_Item_Name__c,Inspection_Result__c, 
                                      		Inspection_Item_Name_for_list__c,Technical_Assistance__c, Visit_Tool_Origin__c,Observations__c,Visit_Mode_Ranking__c,
                                      		Inspection_No__r.Date_of_Visit__c From Inspection_Item__c
                                      		Where Inspection_No__c IN
    										(Select Id From Inspection__c Where Provider_No__c = :inspectionRecord.Provider_No__c AND Status__c = 'Closed')
                                      		AND Inspection_Result__c = 'Not Applicable' ORDER BY LastModifiedDate DESC ];
          if(lstNonApplicables.size() > 0 && lstNonApplicables != null){
              for(Inspection_Item__c ii : lstNonApplicables){
                  if(!nonApplicableInspectionsItems.keySet().contains(ii.Standard_Inspection_Item__c))
                  	nonApplicableInspectionsItems.put(ii.Standard_Inspection_Item__c, ii);
              }
          } 
      } else {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no \'Active\' and/or applicable Visit Tools for this Visit.'));
      }
    } else {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director.'));
    }
  }

  private void processScrList(String scrIds, List<Standard_Checklist_Reference__c> scrList) {
    for (Standard_Checklist_Reference__c scr : scrList) {
      scrIds = scrIds + '\'' + scr.Id + '\',';
    }
    // Add the recommended tool id to the junction query.
    if (recommendedTool != null) {
      scrIds = scrIds + '\'' + recommendedTool.Id + '\',';
    }
    System.debug('----> scrIds: ' + scrIds);
    scrIds = scrIds.subString(0, scrIds.length() - 1);
    String jiQuery = 'Select Standard_Inspection_Item__c,Random_Item_Domain__c,Random_Item__c,Visit_Mode_Ranking__c,Standard_Inspection_Item__r.name,Standard_Inspection_Item__r.Category__c, Standard_Checklist_Reference__c, Non_Assessed_Item__c ' +
    'From Junction_ChklInsp__c  where Standard_Checklist_Reference__c in  (' + scrIds + ') order by Name asc';
    List<Junction_ChklInsp__c> jciList = Database.Query(jiQuery);

    Map<Id, List<SIIWrapper>> siiMap = new Map<Id, List<SIIWrapper>> ();

    List<SIIWrapper> siiMapList = null;
    if (jciList != null && jciList.size() > 0) {
      for (Junction_ChklInsp__c jci : jciList) {
        if (siiMap.containsKey(jci.Standard_Checklist_Reference__c)) {
          siiMap.get(jci.Standard_Checklist_Reference__c).add(new SIIWrapper(jci));
        } else {
          siiMapList = new List<SIIWrapper> ();
          siiMapList.add(new SIIWrapper(jci));
          siiMap.put(jci.Standard_Checklist_Reference__c, siiMapList);
        }
      }
      siiMaps = siiMap;
      for (Standard_Checklist_Reference__c scr : scrList) {
        scrWrapperList.add(new SCRWrapper(scr, siiMap.get(scr.Id)));
      }
      System.debug('*********scrWrapperList*********' + scrWrapperList);
      scrWrapperList.sort();
      System.debug('----> scrWrapperList => Sorted: ' + scrWrapperList);
    } else {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no Tools currently available.'));
    }
  }

  /**
   * removeCurrentTool
   * 
   * @description This function will remove the currently active visit tool from the available tools list.
   * @author Darkis
   * @param List<Standard_Checklist_Reference__c> toolList The list of tools.
   * @return List<Standard_Checklist_Reference__c>
   */
  private List<Standard_Checklist_Reference__c> removeCurrentTool(List<Standard_Checklist_Reference__c> toolList) {
    List<Standard_Checklist_Reference__c> updatedList = new List<Standard_Checklist_Reference__c> ();

    for (Standard_Checklist_Reference__c tool : toolList) {
      String toolId = tool.Id;
      if (!toolId.equalsIgnoreCase(inspectionRecord.Visit_Tool_Used__c)) {
        updatedList.add(tool);
      }
    }
    return updatedList;
  }

  /**
   * checkForRecommendedTool
   *
   * @description This function will check for any recommended tools while also populating and presenting all related data for a tool.
   * @author Darkis
   * @param toolList The list of tools to check.
   * @return List<Standard_Checklist_Reference__c> 
   */
  private List<Standard_Checklist_Reference__c> checkForRecommendedTool(List<Standard_Checklist_Reference__c> toolList) {
    recommendedToolOverrideAvailable = false;
    List<Standard_Checklist_Reference__c> updatedToolList = toolList;
    Integer counter = 0;
    // Get the date today and the date 14 months ago.
    DATE d1 = date.today();
    Date d2 = d1.addMonths(- 14);
    Integer d3 = d2.daysBetween(d1);
    // Query to obtain all the visit items and non-compliance items.
    providerVisitNonCompliantItems = [Select Id, Name, Inspection_No__r.Provider_No__c, Standard_Inspection_Item__c,Inspection_No__r.Date_Of_Visit__c,Inspection_Result__c ,
                                      RecordType.Name, Category_standard__c, Category_list__c, Inspection_Item_Name__c, Inspection_Item_Name_for_list__c, CreatedDate,
                                      Inspection_No__r.Name,Inspection_No__r.RecordType.Name, Inspection_No__r.Check_Record_Type_Name_Value__c,Inspection_No__r.Type_of_Visit__c, Associated_regulation__c,
                                      Inspection_No__r.Provider_No__r.Is_R_P__c, Associated_regulation__r.R_P_High_Risk_Reg__c,
                                      Inspection_No__r.Provider_No__r.Is_GSA__c, Associated_regulation__r.GSA_High_Risk_Reg__c,
                                      Inspection_No__r.Provider_No__r.Record_Type_Name__c, Associated_regulation__r.FCC_High_Risk_Reg__c,
                                      Associated_regulation__r.Name, RecordTypeId, Assessed_Date__c,
                                      Additional_Inspection_Item_Name__c,Visit_Mode_Ranking__c,
                                      Technical_Assistance__c, Visit_Tool_Origin__c,
                                      Inspection_No__c, Discussed__c, Random_Item_from_Visit_Tool__c,
                                      Standard_Inspection_Item__r.Category__c From Inspection_Item__c
                                      Where Inspection_No__c IN
    (Select Id From Inspection__c Where Provider_No__c = :inspectionRecord.Provider_No__c)
                                      AND Inspection_Result__c = 'Non-Compliant' AND Assessed_Date__c >= :d2 AND Assessed_Date__c <= :d1];
    providerNonCompliantItems = [Select Id, Name, CreatedDate, Investigation__r.Name,
                                 Investigation__r.Provider_No__r.Is_R_P__c, Investigation__r.Provider_No__r.Is_GSA__c,
                                 Investigation__r.Provider_No__r.Record_Type_Name__c, Observations__c,
                                 Investigation__r.Investigation_Type__c From Non_Compliant__c Where Investigation__c IN
    (Select Id From Investigation__c Where Provider_No__c = :inspectionRecord.Provider_No__c)
                                 AND CreatedDate >= :d2 AND CreatedDate <= :d1];
    System.debug('----> providerVisitNonCompliantItems: ' + providerVisitNonCompliantItems);
    System.debug('----> providerNonCompliantItems: ' + providerNonCompliantItems);
    // Verify all the visit items for standard visit items to verify their regulations. We also need to check the non standard items for regulations.  
    Set<Id> siSet = new Set<Id> ();
    List<Integer> idsToRemove = new List<Integer> ();
    List<Inspection_Item__c> providerVisitNonCompliantItemsHighRisk = new List<Inspection_Item__c> ();
    // Loop through the visit items and seperate standard from non-standard.
    for (Inspection_Item__c item : providerVisitNonCompliantItems) {
      // If the item is of the standard variant then add it's id to the set for obtaining Junction objects.
      if (item.RecordType.Name == 'Standard Visit Item') {
        siSet.add(item.Standard_Inspection_Item__c);
      } else {
        // Verify that the Non Standard item is valid for the table.
        if (item.Associated_regulation__c != null) {
          // Verify if the item is at risk based on the provider settings.
          if (isItemAtRisk(item, null)) {
            // Add the visit item to the final presentation table data.
            providerVisitNonCompliantItemsHighRisk.add(item);
          }
        }
      }
      counter++;
    }
    counter = 0;
    // Process Guide: 
    // 1. Add Junction_InspReg__c, which contains the Regulation information, to the list.
    // 2. Map will be compromised of Std Item ID => List<Junction_InspReg__c>
    // 3. Loop through Visit Items
    // 4. Check for std item.
    // 5. Get regulations for that item from map.
    // 6. Loop through regulations and check criteria.
    // 7. Add qualifing items to output list
    Map<String, List<Junction_InspReg__c>> stdVisitItemRegMap = new Map<String, List<Junction_InspReg__c>> ();
    for (Junction_InspReg__c jir :[Select Id, Regulation__c, Regulation__r.Name, Regulation__r.R_P_High_Risk_Reg__c, Regulation__r.GSA_High_Risk_Reg__c, Regulation__r.FCC_High_Risk_Reg__c, Standard_Inspection_Item__c From Junction_InspReg__c Where Standard_Inspection_Item__c in :siSet]) {
      if (stdVisitItemRegMap.containsKey(jir.Standard_Inspection_Item__c)) {
        // Add a new junction obj to the list of junction objects for a specific std item id.
        stdVisitItemRegMap.get(jir.Standard_Inspection_Item__c).add(jir);
      } else {
        // Create an initial list for the new std junction object.
        List<Junction_InspReg__c> riskObj = new List<Junction_InspReg__c> ();
        // Add the initial to the list.
        riskObj.add(jir);
        // Add the new std item id with it's list to the mapping. 
        stdVisitItemRegMap.put(jir.Standard_Inspection_Item__c, riskObj);
      }
    }
    // We need to loop through the items again to verify the standard items regulation status. 
    for (Inspection_Item__c item : providerVisitNonCompliantItems) {
      if (item.RecordType.Name == 'Standard Visit Item' && stdVisitItemRegMap.containsKey(item.Standard_Inspection_Item__c)) {
        List<Junction_InspReg__c> itemRegJuncList = stdVisitItemRegMap.get(item.Standard_Inspection_Item__c);
        for (Junction_InspReg__c inspRegJuncObj : itemRegJuncList) {
          if (isItemAtRisk(item, inspRegJuncObj)) {
            // Add the visit item to the final presentation table data.
            providerVisitNonCompliantItemsHighRisk.add(item);
            break;
          }
        }
      }
    }
    // Set the list of n/c visit items equal to the ones considered high risk only.
    providerVisitNonCompliantItems = providerVisitNonCompliantItemsHighRisk;
    System.debug('----> providerVisitNonCompliantItems: ' + providerVisitNonCompliantItems);

    // Process the Non-Compliant Objects to verify there is a regulation setup the same as the visit items.
    providerNonCompliantItems = validateNonCompliantRegulations(providerNonCompliantItems);

    // Get the total count of items.
    Integer totalNonCompliantItemCount = providerVisitNonCompliantItems.size() + providerNonCompliantItems.size();

    // Search for the recommended tool from the tool list.
    for (Standard_Checklist_Reference__c tool : toolList) {
      // Check for a recommended tool. 
      if (tool.Recommended_for__c != null && validateTypeOfVisit(tool, inspectionRecord.Type_of_Visit__c) /*tool.Recommended_for__c.contains(inspectionRecord.Type_of_Visit__c)*/) {
        // Verify if the tool should show the table.
        if (tool.Longer_visit_if_Non_Compliant__c != null) {
          Boolean breakLoop = false;
          // If the providers ineligibility criteria exists then simply attempt to use the longer than visit tool.
          if (inspectionRecord.Provider_No__r.Additional_Ineligibility_Criteria__c != null) {
            breakLoop = activateToolOverride(tool);
          } else if (totalNonCompliantItemCount >= inspectionRecord.Provider_No__r.Config_Record__r.Number_of_Non_Comp_before_longer_visit__c) {
            breakLoop = activateToolOverride(tool);
          }
          // If the loop is destined to be broken then break it.
          if (breakLoop) {
            break;
          }
        }
        recommendedTool = tool;
        updatedToolList.remove(counter);
        break;
      }
      counter++;
    }
    System.debug('----> RecommendedTool: ' + recommendedTool);
    // If the provided tool was overridden by the number of non compliant items them remove the tool from the list.
    if (recommendedToolOverrideAvailable) {
      List<Standard_Checklist_Reference__c> finalToolList = new List<Standard_Checklist_Reference__c> ();
      counter = 0;
      for (Standard_Checklist_Reference__c tool : toolList) {
        // If the current iteration's id is equal to the overidden recommended tool then remove the index.
        if (tool.Id != recommendedTool.Id) {
          finalToolList.add(tool);
        }
        counter++;
      }
      updatedToolList = finalToolList;
    }
    return updatedToolList;
  }

  public String getAdditionalIneleigibilityCriteria() {
    String returnText = inspectionRecord.Provider_No__r.Additional_Ineligibility_Criteria__c;

    if (returnText.startsWith(',')) {
      returnText = returnText.substring(1);
    }
    return returnText;
  }

  /**
  * activateToolOverride
  *
  * @description This function will set the active tool override when a longer than visit visit tool is requested.
  * @author Darkis
  * @param tool The visit tool in question
  * @return Boolean 
  */
  private Boolean activateToolOverride(Standard_Checklist_Reference__c tool) {
    System.debug('----> Inside the tool recommendedToolOverride');
    // Get the recommended tool using the id provided from the previous tool.
    List<Standard_Checklist_Reference__c> newRecommendedTool = [Select Id, Name,CopyNonComplainceVisitItems__c, Recommended_for__c, Longer_visit_if_Non_Compliant__c, No_of_Random_Items_Per_Domain_to_Pick__c From Standard_Checklist_Reference__c Where Id = :tool.Longer_visit_if_Non_Compliant__c];
    if (newRecommendedTool != null && newRecommendedTool.size() == 1) {
      recommendedTool = newRecommendedTool[0];
      recommendedToolOverrideAvailable = true;
      return true;
    }
    return false;
  }

  /**
   * validateTypeOfVisit
   *
   * @description A function that will verify if a visit tool is recommended for a specific visit based on its type.
   * @author Darkis
   * @param tool Standard_Checklist_Reference__c The visit tool to be checked.
   * @param typeOfVisit String A string containing the inspection items type of visit.
   * @return Boolean 
   */
  public Boolean validateTypeOfVisit(Standard_Checklist_Reference__c tool, String typeOfVisit) {
    if (tool.Recommended_for__c.contains(typeOfVisit)) {
      List<String> splitRecommendPicklist = tool.Recommended_for__c.split(';');
      // Verify that the split array contains more than one element.
      if (splitRecommendPicklist != null && splitRecommendPicklist.size() > 1) {
        // Loop through the resulting multi picklist values in search of the typeofVisit.
        for (String recommendedText : splitRecommendPicklist) {
          if (recommendedText.equalsIgnoreCase(typeOfVisit)) {
            return true;
          }
        }
      } else if (tool.Recommended_for__c.equalsIgnoreCase(typeOfVisit)) {
        return true;
      }
    }
    return false;
  }

  /**
   * validateNonCompliantRegulations
   *
   * @description This function will validate all the Non Compliant items to ensure they are at risk before presenting to the user.
   * @author Darkis
   * @param mProviderNonCompliantItems The items in question that could be high risk.
   * @return List<Non_Compliant__c> 
   */
  public List<Non_Compliant__c> validateNonCompliantRegulations(List<Non_Compliant__c> mProviderNonCompliantItems) {
    List<Non_Compliant__c> highRiskNcItems = new List<Non_Compliant__c> ();
    Set<Id> ncItemIds = new Set<Id> ();
    // Loop through the nc items and create a set of ids.
    for (Non_Compliant__c item : mProviderNonCompliantItems) {
      ncItemIds.add(item.Id);
    }

    Map<String, List<Non_Compliant_Item_Regulation__c>> stdNcItemRegMap = new Map<String, List<Non_Compliant_Item_Regulation__c>> ();
    for (Non_Compliant_Item_Regulation__c ncItemRegJuncObj :[Select Id, Non_Compliant_Item__c, Regulation__c, Regulation__r.Name, Regulation__r.R_P_High_Risk_Reg__c, Regulation__r.GSA_High_Risk_Reg__c, Regulation__r.FCC_High_Risk_Reg__c From Non_Compliant_Item_Regulation__c Where Non_Compliant_Item__c in :ncItemIds]) {
      if (stdNcItemRegMap.containsKey(ncItemRegJuncObj.Non_Compliant_Item__c)) {
        // Add a new junction obj to the list of junction objects for a specific id.
        stdNcItemRegMap.get(ncItemRegJuncObj.Non_Compliant_Item__c).add(ncItemRegJuncObj);
      } else {
        // Create an initial list for the new std junction object.
        List<Non_Compliant_Item_Regulation__c> riskObj = new List<Non_Compliant_Item_Regulation__c> ();
        // Add the initial to the list.
        riskObj.add(ncItemRegJuncObj);
        // Add the new std item id with it's list to the mapping. 
        stdNcItemRegMap.put(ncItemRegJuncObj.Non_Compliant_Item__c, riskObj);
      }
    }
    // We need to loop through the items again to verify the regulation status. 
    for (Non_Compliant__c item : mProviderNonCompliantItems) {
      if (stdNcItemRegMap.containsKey(item.Id)) {
        List<Non_Compliant_Item_Regulation__c> itemRegJuncList = stdNcItemRegMap.get(item.Id);
        for (Non_Compliant_Item_Regulation__c inspRegJuncObj : itemRegJuncList) {
          if (isNCItemAtRisk(item, inspRegJuncObj)) {
            // Add the visit item to the final presentation table data.
            highRiskNcItems.add(item);
            break;
          }
        }
      }
    }
    return highRiskNcItems;
  }

  /**
   * isItemAtRisk
   *
   * @description This function will check a single visit item with an attached regulation for it's risk.
   * @author Darkis
   * @param item The visit item that needs to be validated. 
   * @return Boolean 
   */
  public Boolean isItemAtRisk(Inspection_Item__c item, Junction_InspReg__c inspRegJunObj) {
    if (item.Inspection_No__r.Provider_No__r.Is_R_P__c) {
      return(inspRegJunObj != null ? inspRegJunObj.Regulation__r.R_P_High_Risk_Reg__c : item.Associated_regulation__r.R_P_High_Risk_Reg__c);
    } else if (item.Inspection_No__r.Provider_No__r.Is_GSA__c) {
      return(inspRegJunObj != null ? inspRegJunObj.Regulation__r.GSA_High_Risk_Reg__c : item.Associated_regulation__r.GSA_High_Risk_Reg__c);
    } else if (item.Inspection_No__r.Provider_No__r.Record_Type_Name__c == 'Family Child Care') {
      return(inspRegJunObj != null ? inspRegJunObj.Regulation__r.FCC_High_Risk_Reg__c : item.Associated_regulation__r.FCC_High_Risk_Reg__c);
    }
    return false;
  }

  /**
   * isNCItemAtRisk
   *
   * @description This function will check a single visit item with an attached regulation for it's risk.
   * @author Darkis
   * @param item The Non_Compliant__c item that needs to be validated. 
   * @return Boolean 
   */
  public Boolean isNCItemAtRisk(Non_Compliant__c item, Non_Compliant_Item_Regulation__c inspRegJunObj) {
    if (item.Investigation__r.Provider_No__r.Is_R_P__c) {
      return inspRegJunObj.Regulation__r.R_P_High_Risk_Reg__c;
    } else if (item.Investigation__r.Provider_No__r.Is_GSA__c) {
      return inspRegJunObj.Regulation__r.GSA_High_Risk_Reg__c;
    } else if (item.Investigation__r.Provider_No__r.Record_Type_Name__c == 'Family Child Care') {
      return inspRegJunObj.Regulation__r.FCC_High_Risk_Reg__c;
    }
    return false;
  }
  
  /*
   * Delete (Switch) Tool
   * 
   * */  
    public PageReference switchTool(){
        Map<Id,Inspection_Item__c> eVItems = new Map<Id,Inspection_Item__c>();
        Map<Id,Inspection_Item__c> dVItems = new Map<Id,Inspection_Item__c>();
        Set<Id> standardVisitItem = new Set<Id>();
        Set<Id> deleteIItems = new Set<Id>(); 
        List<Inspection_Item__c> visitItems = [SELECT ID,Inspection_Result__c,Observations__c,Technical_Assistance__c,
                                               Standard_Inspection_Item__c FROM Inspection_Item__c 
                                               WHERE Inspection_No__r.Provider_No__c =: inspectionRecord.Provider_No__c 
                                               AND Inspection_No__c =: inspectionRecord.Id
                                               AND Visit_Tool_Origin__c =: inspectionRecord.Visit_Tool_Used__c];
        if(selectedTool == 'on'){
            if(visitItems.size() > 0){
                delete visitItems;
            }
        }//If any other switch tool selected
        else{
        for(Inspection_Item__c insp : visitItems){
            eVItems.put(insp.Standard_Inspection_Item__c, insp);
            dVItems.put(insp.Id, insp);
        }
        standardVisitItem = eVItems.keySet();    
        Date d1 = date.today();
        Date d2 = d1.addMonths(- 14);
        providerVisitNonCompliantItems = [Select Id, Name, Inspection_No__r.Provider_No__c, Standard_Inspection_Item__c,
                                          RecordType.Name, Category_standard__c, Category_list__c, Inspection_Item_Name__c, Inspection_Item_Name_for_list__c, CreatedDate,
                                          Inspection_No__r.Name,Inspection_No__r.RecordType.Name, Inspection_No__r.Type_of_Visit__c, Associated_regulation__c,
                                          Inspection_No__r.Provider_No__r.Is_R_P__c, Associated_regulation__r.R_P_High_Risk_Reg__c,
                                          Inspection_No__r.Provider_No__r.Is_GSA__c, Associated_regulation__r.GSA_High_Risk_Reg__c,
                                          Inspection_No__r.Provider_No__r.Record_Type_Name__c, Associated_regulation__r.FCC_High_Risk_Reg__c,
                                          Associated_regulation__r.Name, RecordTypeId, Assessed_Date__c,
                                          Additional_Inspection_Item_Name__c,
                                          Technical_Assistance__c, Visit_Tool_Origin__c,
                                          Inspection_No__c, Discussed__c, Random_Item_from_Visit_Tool__c,
                                          Standard_Inspection_Item__r.Category__c From Inspection_Item__c
                                          Where Inspection_No__c IN
        (Select Id From Inspection__c Where Provider_No__c = :inspectionRecord.Provider_No__c)
                                          AND Inspection_Result__c = 'Non-Compliant' AND Assessed_Date__c >= :d2 AND Assessed_Date__c <= :d1];

            
        }
        
        PageReference resultPage = null;
        List<Inspection__c> childVisits = new List<Inspection__c> ();
    
        if (inspectionRecord.Mater_Visit_for_Res_Cluster_of_Visits__c == null) {
          childVisits = [SELECT Id FROM Inspection__c WHERE Mater_Visit_for_Res_Cluster_of_Visits__c = :inspectionRecord.Id];
        }
    
        Id selectedId;
        List<Inspection_Item__c> iiList = new List<Inspection_Item__c> ();
        Inspection_Item__c ii;
        Set<Id> siiD = new Set<Id> ();
        System.debug('Wrapper Map --->' + scrWrapperList);

        for (SCRWrapper scr : scrWrapperList) {
          //selectedId = scr.Id;
          System.debug('Initial --->' + scr.name + ' = ' + selectedTool + ' ' + scr.noRandomPerDomain);
          if (scr.name == selectedTool && scr.noRandomPerDomain == 0) {
            selectedId = scr.Id;
            for (SIIWrapper sii : scr.stiList) {
              System.debug('Wrapper Map123 --->' + sii);
              ii = new Inspection_Item__c();   
                if(standardVisitItem.contains(sii.Id)){
                    Inspection_Item__c prevItem = new Inspection_Item__c();
                    prevItem = eVItems.get(sii.Id);
                    if(prevItem.Inspection_Result__c != 'Non Assessed (tool abandoned)')
                    ii.Inspection_Result__c = prevItem.Inspection_Result__c;
                    ii.Observations__c = prevItem.Observations__c;
                    ii.Technical_Assistance__c = prevItem.Technical_Assistance__c;
                    deleteIItems.add(prevItem.Id);
                } 
              if(sii.moderank==null){
                ii.Visit_Mode_Ranking__c=999;
              }else{
                ii.Visit_Mode_Ranking__c= sii.Moderank;
              }
          system.debug('iiiiiii'+ii.Visit_Mode_Ranking__c+sii.Moderank); 
              ii.Inspection_No__c = inspectionRecord.Id;
              ii.Standard_Inspection_Item__c = sii.Id;
              ii.Non_Assessed_Item__c = sii.nonAccessedItem;
              ii.RecordTypeId = EEC_RecordTypeUtil.findByName('Inspection_Item__c.Standard_Item').Id;
              ii.Visit_Tool_Origin__c = selectedId;
              ii.Random_Item_from_Visit_Tool__c = sii.randomItem;
              if (!sii.randomItem)
              ii.Category_additional__c = sii.standardDomain;
              else
              ii.Category_additional__c = sii.randomItemDomain;
              iiList.add(ii);
              siiD.add(sii.Id);
            }
          }
          else if (scr.name == selectedTool && scr.noRandomPerDomain > 0) {
            selectedId = scr.Id;  
            Map<String, List<SIIWrapper>> lstSIIWrapper = new Map<String, List<SIIWrapper>> ();
            if (scr.stiList != null) {
              for (SIIWrapper sii : scr.stiList) {
                if (!sii.randomItem) {
                  ii = new Inspection_Item__c();
                  if(standardVisitItem.contains(sii.Id)){
                    Inspection_Item__c prevItem = new Inspection_Item__c();
                    prevItem = eVItems.get(sii.Id);
                    if(prevItem.Inspection_Result__c != 'Non Assessed (tool abandoned)')  
                    ii.Inspection_Result__c = prevItem.Inspection_Result__c;
                    ii.Observations__c = prevItem.Observations__c;
                    ii.Technical_Assistance__c = prevItem.Technical_Assistance__c;
                    deleteIItems.add(prevItem.Id);
                  }
                  if(sii.moderank==null){
                    ii.Visit_Mode_Ranking__c=999;
                     }else{
                    ii.Visit_Mode_Ranking__c= sii.Moderank;
                     }
          system.debug('iiiiiii'+ii.Visit_Mode_Ranking__c+sii.Moderank); 
                  ii.Inspection_No__c = inspectionRecord.Id;
                  ii.Standard_Inspection_Item__c = sii.Id;
                  ii.Non_Assessed_Item__c = sii.nonAccessedItem;
                  ii.RecordTypeId = EEC_RecordTypeUtil.findByName('Inspection_Item__c.Standard_Item').Id;
                  ii.Visit_Tool_Origin__c = selectedId;
                  ii.Random_Item_from_Visit_Tool__c = sii.randomItem;
                  if (!sii.randomItem)
                  ii.Category_additional__c = sii.standardDomain;
                  else
                  ii.Category_additional__c = sii.randomItemDomain;
                  iiList.add(ii);
                  siiD.add(sii.Id);
                }
                else {
                  List<SIIWrapper> tmp = lstSIIWrapper.get(sii.randomItemDomain);
                  if (tmp == null)
                    lstSIIWrapper.put(sii.randomItemDomain, new List<SIIWrapper> { sii });
                  else
                    tmp.add(sii);
                }
              }
    
              System.debug('Wrapper List --->' + lstSIIWrapper);
              System.debug('Domain Key Set --->' + lstSIIWrapper.keySet());
              for (String domain : lstSIIWrapper.keySet()) {
                Integer counter = 0;
                System.debug('Random Domain -->' + scr.noRandomPerDomain);
                while (counter < scr.noRandomPerDomain) {
                  List<SIIWrapper> lstSii = lstSIIWrapper.get(domain);
                  System.debug('List Size -->' + Integer.valueOf(lstSii.size()));
                  System.debug('Random Number -->' + Math.mod(Math.round(Math.random() * 1000), Integer.valueOf(lstSii.size())));
                  SIIWrapper sii = lstSii.get(Math.mod(Math.round(Math.random() * 1000), Integer.valueOf(lstSii.size())));
                  System.debug('Actuall Item -->' + sii);
                  ii = new Inspection_Item__c();
                  if(standardVisitItem.contains(sii.Id)){
                    Inspection_Item__c prevItem = new Inspection_Item__c();
                    prevItem = eVItems.get(sii.Id);
                    if(prevItem.Inspection_Result__c != 'Non Assessed (tool abandoned)')  
                    ii.Inspection_Result__c = prevItem.Inspection_Result__c;
                    ii.Observations__c = prevItem.Observations__c;
                    ii.Technical_Assistance__c = prevItem.Technical_Assistance__c;
                    deleteIItems.add(prevItem.Id);
                  } 
                  if(sii.moderank==null){
                    ii.Visit_Mode_Ranking__c=999;
                  }else{
                    ii.Visit_Mode_Ranking__c= sii.Moderank;
                  }
          system.debug('iiiiiii'+ii.Visit_Mode_Ranking__c+sii.Moderank); 
                  ii.Inspection_No__c = inspectionRecord.Id;
                  ii.Standard_Inspection_Item__c = sii.Id;
                  ii.Non_Assessed_Item__c = sii.nonAccessedItem;
                  ii.RecordTypeId = EEC_RecordTypeUtil.findByName('Inspection_Item__c.Standard_Item').Id;
                  ii.Visit_Tool_Origin__c = selectedId;
                  ii.Random_Item_from_Visit_Tool__c = sii.randomItem;
                  if (!sii.randomItem)
                  ii.Category_additional__c = sii.standardDomain;
                  else
                  ii.Category_additional__c = sii.randomItemDomain;
                  iiList.add(ii);
                  siiD.add(sii.Id);
                  counter++;
                }
              }
            }
            if (scr.copyNonComplainceInspectionItems && providerVisitNonCompliantItems.size() > 0) {
              System.debug('Non-Compliant Items----->' + providerVisitNonCompliantItems);
              for (Inspection_Item__c items : providerVisitNonCompliantItems) {
                if ((!siiD.contains(items.Standard_Inspection_Item__c) || items.Standard_Inspection_Item__c == null)
                    && items.Inspection_No__r.RecordType.Name != 'Legacy System Import Visit / Non Compliance') {
                  Inspection_Item__c i = new Inspection_Item__c();
                  i.RecordTypeId = items.RecordTypeId;
                  i.Associated_regulation__c = items.Associated_regulation__c;
                  i.Standard_Inspection_Item__c = items.Standard_Inspection_Item__c;
                  i.Additional_Inspection_Item_Name__c = items.Additional_Inspection_Item_Name__c;
                  i.Technical_Assistance__c = items.Technical_Assistance__c;
                  i.Inspection_No__c = inspectionRecord.Id;
                  i.Discussed__c = items.Discussed__c;
                  i.Visit_Tool_Origin__c = selectedId;
                  i.Random_Item_from_Visit_Tool__c = items.Random_Item_from_Visit_Tool__c;
                  i.Category_additional__c = items.Category_list__c;
                  iiList.add(i);
                }
              }
            }
          }
        }
        inspectionRecord.Previous_Visit_Tool_Used__c = inspectionRecord.Visit_Tool_Used__c;
        inspectionRecord.Visit_Tool_Used__c = selectedId;
        if(String.isBlank(inspectionRecord.Switch_Tool_Justification_1__c)){
            inspectionRecord.Switch_Tool_Justification_1__c = justificationText;
        }else{
            inspectionRecord.Switch_Tool_Justification_2__c = justificationText;
        }
        update inspectionRecord;
        if (iiList != null && iiList.size() > 0) {
          insert iiList;
        }
        if(deleteIItems.size() > 0){
            //System.debug('To Delete List--->' + deleteIItems);
            //List<Inspection_Item__c> dList = new List<Inspection_Item__c>();
            //for(Id iid : deleteIItems)
             //   dList.add(dVItems.get(iid));
            delete visitItems;
        }
        return(new PageReference('/' + inspectionRecord.Id));
  }
    
  public PageReference copyInspectionItems() {
    if(inspectionRecord.Visit_Tool_Used__c != null){
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'A Visit Tool has already been selected.'));
       return null; 
    }  
    else{
    Date d1 = date.today();
    Date d2 = d1.addMonths(- 14);
    providerVisitNonCompliantItems = [Select Id, Name, Inspection_No__r.Provider_No__c, Standard_Inspection_Item__c,
                                      RecordType.Name, Category_standard__c, Category_list__c, Inspection_Item_Name__c, Inspection_Item_Name_for_list__c, CreatedDate,
                                      Inspection_No__r.Name,Inspection_No__r.RecordType.Name, Inspection_No__r.Type_of_Visit__c, Associated_regulation__c,
                                      Inspection_No__r.Provider_No__r.Is_R_P__c, Associated_regulation__r.R_P_High_Risk_Reg__c,
                                      Inspection_No__r.Provider_No__r.Is_GSA__c, Associated_regulation__r.GSA_High_Risk_Reg__c,
                                      Inspection_No__r.Provider_No__r.Record_Type_Name__c, Associated_regulation__r.FCC_High_Risk_Reg__c,
                                      Associated_regulation__r.Name, RecordTypeId, Assessed_Date__c,Visit_Mode_Ranking__c,
                                      Additional_Inspection_Item_Name__c,
                                      Technical_Assistance__c, Visit_Tool_Origin__c,Visit_Tool_Origin__r.CopyNonComplainceVisitItems__c ,
                                      Inspection_No__c, Discussed__c, Random_Item_from_Visit_Tool__c,
                                      Standard_Inspection_Item__r.Category__c From Inspection_Item__c
                                      Where Inspection_No__c IN
    (Select Id From Inspection__c Where Provider_No__c = :inspectionRecord.Provider_No__c)
                                      AND Inspection_Result__c = 'Non-Compliant' AND Assessed_Date__c >= :d2 AND Assessed_Date__c <= :d1];

    PageReference resultPage = null;
    List<Inspection__c> childVisits = new List<Inspection__c> ();

    if (inspectionRecord.Mater_Visit_for_Res_Cluster_of_Visits__c == null) {
      childVisits = [SELECT Id FROM Inspection__c WHERE Mater_Visit_for_Res_Cluster_of_Visits__c = :inspectionRecord.Id];
    }

    Id selectedId;
    List<Inspection_Item__c> iiList = new List<Inspection_Item__c> ();
    Inspection_Item__c ii;
    Set<Id> siiD = new Set<Id> ();
    System.debug('Wrapper Map --->' + scrWrapperList);
    System.debug('***UnitTest-siiMaps: ' + siiMaps);
    if (selectedTool != null && recommendedTool != null && selectedTool == recommendedTool.Name) {
      scrWrapperList.add(new SCRWrapper(recommendedTool, siiMaps.get(recommendedTool.Id)));
    }
    
    for (SCRWrapper scr : scrWrapperList) {
      //selectedId = scr.Id;
      System.debug('Initial --->' + scr.name + ' = ' + selectedTool + ' ' + scr.noRandomPerDomain);
      if (scr.name == selectedTool && scr.noRandomPerDomain == 0) {
        selectedId = scr.Id;
        for (SIIWrapper sii : scr.stiList) {
          System.debug('Wrapper Map123 --->' + sii);
          ii = new Inspection_Item__c();
          ii.Inspection_No__c = inspectionRecord.Id;
          system.debug('value of STDI:'+sii.Standard_Inspection_Item);
          
          ii.Standard_Inspection_Item__c = sii.Id;
          if(nonApplicableInspectionsItems.size() > 0 && nonApplicableInspectionsItems != null){
                Inspection_Item__c item = nonApplicableInspectionsItems.get(sii.Id);
              	if(item != null){
                   ii.Inspection_Result__c = item.Inspection_Result__c;
                   ii.Observations__c = String.valueOf(item.INspection_No__r.Date_of_Visit__c) + ' - "' + item.Observations__c + '"';
              	}
          }
          
          if(sii.moderank==null){
           ii.Visit_Mode_Ranking__c=999;
          }else{
           ii.Visit_Mode_Ranking__c= sii.Moderank;
          }
          system.debug('iiiiiii'+ii.Visit_Mode_Ranking__c+sii.Moderank);
           
          ii.Non_Assessed_Item__c = sii.nonAccessedItem;
          ii.RecordTypeId = EEC_RecordTypeUtil.findByName('Inspection_Item__c.Standard_Item').Id;
          ii.Visit_Tool_Origin__c = selectedId;
          ii.Random_Item_from_Visit_Tool__c = sii.randomItem;
          if (!sii.randomItem)
          ii.Category_additional__c = sii.standardDomain;
          else
          ii.Category_additional__c = sii.randomItemDomain;
          iiList.add(ii);
          siiD.add(sii.Id);
          
        }
      }
      else if (scr.name == selectedTool && scr.noRandomPerDomain > 0) {
        selectedId = scr.Id;  
        Map<String, List<SIIWrapper>> lstSIIWrapper = new Map<String, List<SIIWrapper>> ();
        if (scr.stiList != null) {
          for (SIIWrapper sii : scr.stiList) {
            if (!sii.randomItem) {
              ii = new Inspection_Item__c();
              ii.Inspection_No__c = inspectionRecord.Id;
              ii.Standard_Inspection_Item__c = sii.Id;
              if(nonApplicableInspectionsItems.size() > 0 && nonApplicableInspectionsItems != null){
                Inspection_Item__c item = nonApplicableInspectionsItems.get(sii.Id);
              	if(item != null){
                   ii.Inspection_Result__c = item.Inspection_Result__c;
                   ii.Observations__c = String.valueOf(item.INspection_No__r.Date_of_Visit__c) + ' - "' + item.Observations__c + '"';
              	}
         	    } 
         	    if(sii.moderank==null){
                ii.Visit_Mode_Ranking__c=999;
              }else{
                ii.Visit_Mode_Ranking__c= sii.Moderank;
              }
              system.debug('iiiiiii'+ii.Visit_Mode_Ranking__c+sii.Moderank); 
              ii.Non_Assessed_Item__c = sii.nonAccessedItem;
              ii.RecordTypeId = EEC_RecordTypeUtil.findByName('Inspection_Item__c.Standard_Item').Id;
              ii.Visit_Tool_Origin__c = selectedId;
              ii.Random_Item_from_Visit_Tool__c = sii.randomItem;
              if (!sii.randomItem)
              ii.Category_additional__c = sii.standardDomain;
              else
              ii.Category_additional__c = sii.randomItemDomain;
              iiList.add(ii);
              siiD.add(sii.Id);
            } else {
              List<SIIWrapper> tmp = lstSIIWrapper.get(sii.randomItemDomain);
              if (tmp == null)
              lstSIIWrapper.put(sii.randomItemDomain, new List<SIIWrapper> { sii });
              else
              tmp.add(sii);
            }
          }

          System.debug('Wrapper List --->' + lstSIIWrapper);
          System.debug('Domain Key Set --->' + lstSIIWrapper.keySet());
          for (String domain : lstSIIWrapper.keySet()) {
            Integer counter = 0;
            System.debug('Random Domain -->' + scr.noRandomPerDomain);
            while (counter < scr.noRandomPerDomain) {
              List<SIIWrapper> lstSii = lstSIIWrapper.get(domain);
              System.debug('List Size -->' + Integer.valueOf(lstSii.size()));
              System.debug('Random Number -->' + Math.mod(Math.round(Math.random() * 1000), Integer.valueOf(lstSii.size())));
              SIIWrapper sii = lstSii.get(Math.mod(Math.round(Math.random() * 1000), Integer.valueOf(lstSii.size())));
              System.debug('Actuall Item -->' + sii);
              ii = new Inspection_Item__c();
              ii.Inspection_No__c = inspectionRecord.Id;
              ii.Standard_Inspection_Item__c = sii.Id;
                
              if(nonApplicableInspectionsItems.size() > 0 && nonApplicableInspectionsItems != null){
                Inspection_Item__c item = nonApplicableInspectionsItems.get(sii.Id);
              	if(item != null){
                   ii.Inspection_Result__c = item.Inspection_Result__c;
                   ii.Observations__c = String.valueOf(item.INspection_No__r.Date_of_Visit__c) + ' - "' + item.Observations__c + '"';
              	}
          	  }
              
              system.debug('value of STDI:'+sii.Standard_Inspection_Item);
              if(sii.moderank==null){
                ii.Visit_Mode_Ranking__c=999;
              }else{
                ii.Visit_Mode_Ranking__c= sii.Moderank;
             }
            system.debug('iiiiiii'+ii.Visit_Mode_Ranking__c+sii.Moderank);
              ii.Non_Assessed_Item__c = sii.nonAccessedItem;
              ii.RecordTypeId = EEC_RecordTypeUtil.findByName('Inspection_Item__c.Standard_Item').Id;
              ii.Visit_Tool_Origin__c = selectedId;
              ii.Random_Item_from_Visit_Tool__c = sii.randomItem;
              if (!sii.randomItem)
              ii.Category_additional__c = sii.standardDomain;
              else
              ii.Category_additional__c = sii.randomItemDomain;
              iiList.add(ii);
              siiD.add(sii.Id);
              counter++;
            }
          }
        }
        if (scr.copyNonComplainceInspectionItems && providerVisitNonCompliantItems.size() > 0) {
          System.debug('Non-Compliant Items----->' + providerVisitNonCompliantItems);
          for (Inspection_Item__c items : providerVisitNonCompliantItems) {
            if ((!siiD.contains(items.Standard_Inspection_Item__c) || items.Standard_Inspection_Item__c == null)
                && items.Inspection_No__r.RecordType.Name != 'Legacy System Import Visit / Non Compliance') {
              Inspection_Item__c i = new Inspection_Item__c();
              i.RecordTypeId = items.RecordTypeId;
              i.Associated_regulation__c = items.Associated_regulation__c;
              i.Standard_Inspection_Item__c = items.Standard_Inspection_Item__c;
              system.debug('value of STDI:'+items.Standard_Inspection_Item__c);
              if(nonApplicableInspectionsItems.size() > 0 && nonApplicableInspectionsItems != null){
                Inspection_Item__c item = nonApplicableInspectionsItems.get(items.Standard_Inspection_Item__c);
              	if(item != null){
                   i.Inspection_Result__c = items.Inspection_Result__c;
                   i.Observations__c = String.valueOf(items.Inspection_No__r.Date_of_Visit__c) + ' - "' + items.Observations__c + '"';
              	}
              }
              i.Additional_Inspection_Item_Name__c = items.Additional_Inspection_Item_Name__c;
              i.Technical_Assistance__c = items.Technical_Assistance__c;
              i.Inspection_No__c = inspectionRecord.Id;
              i.Discussed__c = items.Discussed__c;
              i.Visit_Tool_Origin__c = selectedId;
              i.Random_Item_from_Visit_Tool__c = items.Random_Item_from_Visit_Tool__c;
              i.Category_additional__c = items.Category_list__c;
              
              iiList.add(i);
            }
          }
        }
      }
    }


    inspectionRecord.Visit_Tool_Used__c = selectedId;

    if(inspectionRecord.First_Visit_Tool_Used__c == null) {     
        inspectionRecord.First_Visit_Tool_Used__c = selectedId;  
    }

    if (recommendedTool != null ) {
      inspectionRecord.Recommended_Tool__c = recommendedTool.Id;
    }

    if (String.isNotBlank(justificationText)) {
      inspectionRecord.Use_Non_Recommended_Tool_Justification__c = justificationText;
    } else {
      inspectionRecord.Use_Non_Recommended_Tool_Justification__c = null;
    }

    if (iiList != null && iiList.size() > 0) {
      //TO DO - Logic to identify and remove duplicate items - Qamar
      //Set<id> siiIdSet = (new Map<Id, Inspection_Item__c>(iiList)).keySet();
      insert iiList;
      update inspectionRecord;
    }
    if(isSF1()){
        sf1 = true;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'A Visit tool has been successfully selected! Please use the Cancel button to go back to the visit.'));
        return null;
    }    
    else    
        return(new PageReference('/' + inspectionRecord.Id));
    }    

  }
  public static Boolean isSF1(){
    if(String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
        String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
        ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
        (ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone') )
    ){
        return true;
    }else{
        return false;
    }
 }  

  public Boolean isSIISelected {
    get {
      isSIISelected = false;
      if (scrWrapperList != null && scrWrapperList.size() > 0) {
        for (SCRWrapper scr : scrWrapperList) {
          if (scr.selected) {
            isSIISelected = true;
            break;
          }
        }
      }
      return isSIISelected;
    }
    private set;
  }

  public Boolean getIsRecommendedToolAvailable() {
    if (recommendedTool != null) {
      return true;
    }
    return false;
  }

  public class SIIWrapper {
    public Id Id { get; set; }
    public String name { get; private set; }
    public Boolean nonAccessedItem { get; set; }
    public Boolean randomItem { get; set; }
    public String randomItemDomain { get; set; }
    public String standardDomain { get; set; }
    public Id Standard_Inspection_Item  {get; set;}
    public Decimal Moderank  {get; set;}

    public SIIWrapper(Junction_ChklInsp__c jci) {
      this.Id = jci.Standard_Inspection_Item__c;
      this.name = jci.Standard_Inspection_Item__r.name;
      this.nonAccessedItem = jci.Non_Assessed_Item__c;
      this.randomItem = jci.Random_Item__c;
      this.randomItemDomain = jci.Random_Item_Domain__c;
      this.standardDomain = jci.Standard_Inspection_Item__r.Category__c;
      this.Moderank = jci.Visit_Mode_Ranking__c;
     this.Standard_Inspection_Item  = jci.Standard_Inspection_Item__c ;
    }
  }

  public class SCRWrapper implements Comparable {
    public Standard_Checklist_Reference__c tool { get; set; }

    public Id Id { get; set; }
    public String name { get; private set; }
    public Boolean selected { get; set; }
    public Double noRandomPerDomain { get; set; }
    public List<SIIWrapper> stiList { get; set; }
    public boolean copyNonComplainceInspectionItems {get; set;}    

    public SCRWrapper(Standard_Checklist_Reference__c scr, List<SIIWrapper> stList) {
      this.tool = scr;
      this.Id = scr.Id;
      this.name = scr.name;
      this.selected = false;
      this.noRandomPerDomain = scr.No_of_Random_Items_Per_Domain_to_Pick__c;
      this.copyNonComplainceInspectionItems = scr.CopyNonComplainceVisitItems__c;
      this.stiList = stList;
  
    }

    // Compare members based on the Member__c Age.
    public Integer compareTo(Object compareTo) {
      // Cast argument to SCRWrapper
      SCRWrapper compareToTool = (SCRWrapper) compareTo;
      // The return value of 0 indicates that both elements are equal.
      Integer returnValue = 0;
      if (tool.Order__c > compareToTool.tool.Order__c) {
        // Set return value to a positive value.
        returnValue = 1;
      } else if (tool.Order__c < compareToTool.tool.Order__c) {
        // Set return value to a negative value.
        returnValue = - 1;
      }
      return returnValue;
    }
  }
}