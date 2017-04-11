public with sharing class InspectVisitModeController {

  private final Inspection__c inspectionRecord;
  public List<InspectionListWrapper> iiWrapperList { get; set; }
  private String sortDirection = 'ASC';
  private String sortExp = 'RecordTypeId';
  public Integer numberItemsNonSelected { get; set; }
  public String selectedResultFilter { get; set; }
  public String selectedCategoryFilter { get; set; }
  public String errorMessage { get; set; }
  Public Set<Id> inspectionItemsWithAttachments { get; set; }
  public String activeFilter { get; set; }
  public Boolean resultFilterActive { get; set; }
  public Set<String> resultFilterMap = new Set<String> { 'Observation', 'TechAssistance', 'Compliant', 'Non-Compliant', 'non-assessed', 'KeyIndicators','non-selected', 'all' };
  public Boolean dateAI { get; set; }
  public Attachment tAttachment { get; set; }
  public Boolean allItemsAssesed { get; set; }
  public List<SelectOption> allDomainList { get; set; }
  public List<SelectOption> activeDomainBPList { get; set; }
  public List<Visit_Best_Practices__c> visitBPList { get; set; }
  private Map<String, List<Standard_Best_Practices__c>> stdBestPractMapByName { get; set; }
  private List<String> applicableDomains { get; set; }
  public String lockedByUserName {get; set;}
  public Boolean disableButton {get; set;}
  public Boolean visitModeLocked {get; set;}
  public String additionalItemRtId {get; set;}  
  public String ToolName {get; set;}
  public String bulkPickVal{get;set;}
  public String bulkObservation {get; set;}
  public String filterCriteria {get; set;}

  public InspectVisitModeController(ApexPages.StandardController controller) {
    this.inspectionRecord = (Inspection__c) controller.getRecord();
    
    this.activeFilter = ApexPages.currentPage().getParameters().get('filter');
    this.resultFilterActive = !String.isBlank(activeFilter) ? resultFilterMap.contains(activeFilter) : true;
    System.debug('inspectionRecord--->' + inspectionRecord); 
    this.tAttachment = new Attachment();
    this.applicableDomains = new List<String>();
    this.allDomainList = new List<SelectOption>();
    this.activeDomainBPList = new List<SelectOption>();
    this.stdBestPractMapByName = new Map<String, List<Standard_Best_Practices__c>>();
    inspectionItemsWithAttachments = new Set<Id> ();
    additionalItemRtId = (String)[select id from RecordType where DeveloperName = 'Additional_Inspection_Item'].id;  
    lockedByusername = '';
    visitModeLocked = false;
    filterCriteria = null;
    checkForAttachments();
    getInspectionItemData();
    getVisitBestPractices();
    setToolName();
    //filterCriteria = '';
  }
  public void  setToolName(){
  Inspection__c ins = [Select Visit_Mode_Lock__c,Visit_Tool_Used__c,Visit_Tool_Used__r.name, Visit_Mode_Locked_By__c ,Offline_Lock__c FROM Inspection__c Where Id =: inspectionRecord.id];
  Toolname=ins.Visit_Tool_Used__r.name;
  system.debug('MMMMM'+ToolName);
  //return Toolname;
  }

  public void lockVisitMode(){

    Inspection__c i = [Select Visit_Mode_Lock__c, Visit_Mode_Locked_By__c ,Offline_Lock__c FROM Inspection__c Where Id =: inspectionRecord.id];
    if(i.Offline_Lock__c){
      disableButton = true;
      return;
    }
    visitModeLocked = i.Visit_Mode_Lock__c;
    if(visitModeLocked){
        lockedByUserName = i.Visit_Mode_Locked_By__c;
        if(lockedByUserName != UserInfo.getUserName()){
          system.debug('**** IN lockVisitMode***');
            disableButton = true;
            String visitLockError = 'This is view-only visit mode as this visit is currently locked for editing by ' + lockedByUserName;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, visitLockError));
        } else {
            disableButton = false;
        }
    } else {
      system.debug('**** IN lockVisitMode***');
      i.Visit_Mode_Lock__c = true;
      i.Visit_Mode_Locked_By__c = UserInfo.getUserName();
      //Mod by LD - Fix for BMMS-223
      lockedByUserName = UserInfo.getUserName();
      visitModeLocked = true;
      // Fix ends here..
      
      disableButton = false;
   
      try{
        update i;
      } catch (exception e){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, e.getMessage()));
      }
    }
  }

  public String sortExpression
  {
    get
    {
      return sortExp;
    }
    set
    {
      if (value == sortExp)
      sortDirection = (sortDirection == 'ASC') ? 'DESC' : 'ASC';
      else
      sortDirection = 'ASC';
      sortExp = value;
    }
  }

  public String getSortDirection()
  {
    if (sortExpression == null || sortExpression == '')
    return 'ASC';
    else
    return sortDirection;
  }

  public void setSortDirection(String value)
  {
    sortDirection = value;
  }

  public List<SelectOption> getFilterOptions() {
    List<SelectOption> fiterOptions = new List<SelectOption> ();
    fiterOptions.add(new SelectOption('', 'All'));
    fiterOptions.add(new SelectOption('NoneSelected', 'None Selected (except Non Assessed)'));
    fiterOptions.add(new SelectOption('NonAssessed', 'Non Assessed Items Only'));
    fiterOptions.add(new SelectOption('KeyIndicators', 'Key Indicator Only'));
    fiterOptions.add(new SelectOption('NotAssessed', 'Not Assessed Items Only'));
    fiterOptions.add(new SelectOption('Non-Compliant', 'Non-Compliant Items Only'));
    fiterOptions.add(new SelectOption('NotApplicable', 'Not Applicable Items Only'));
    fiterOptions.add(new SelectOption('Compliant', 'Compliant Items Only'));
    return fiterOptions;
  }

  public List<SelectOption> getCatFilterOptions() {
    List<SelectOption> fiterOptions = new List<SelectOption> ();
    Set<String> foSet = new Set<String> ();
    fiterOptions.add(new SelectOption('', 'All'));
    fiterOptions.add(new SelectOption('NS', 'None Selected'));
    //Schema.DescribeFieldResult fieldResult = Standard_Inspection_Item__c.Category__c.getDescribe();
    //List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

    for (Inspection_Item__c ii :[select Category_list__c from Inspection_Item__c where Inspection_No__c = :inspectionRecord.Id and Category_list__c != null])
    {
      foSet.add(ii.Category_list__c);
    }
    for (String str : foSet) {
      fiterOptions.add(new SelectOption(str, str));
    }

    return fiterOptions;
  }

  public List<SelectOption> getStdBestPractices() {
    List<SelectOption> options = new List<SelectOption>();
    List<Standard_Best_Practices__c> stdBestPracList = [Select Id, Name, Best_Practice_Guidance__c From Standard_Best_Practices__c ORDER BY Best_Practice_Guidance__c Asc];

    for (Standard_Best_Practices__c stdBestPract : stdBestPracList) {
      options.add(new SelectOption(stdBestPract.Id, stdBestPract.Best_Practice_Guidance__c));
    }

    return options;
  }

  private Map<String, List<Standard_Best_Practices__c>> retrieveBestPractices(List<String> applicableDomains) {
    List<Standard_Best_Practices__c> inspectionBestPractices = [Select Id, Name, Domain__c, Best_Practice_Guidance__c From Standard_Best_Practices__c Where Domain__c IN :applicableDomains AND Applicable_To__c INCLUDES(:inspectionRecord.Provider_No__r.RecordType.Name)];
        System.debug('----> inspectionBestPractices: ' + applicableDomains);
    System.debug('----> inspectionBestPractices: ' + inspectionRecord.Provider_No__r.RecordType.Name ); 
    System.debug('----> inspectionBestPractices: ' + inspectionBestPractices);
    Map<String, List<Standard_Best_Practices__c>> stdBestPractMapByName = new Map<String, List<Standard_Best_Practices__c>>();
    for (Standard_Best_Practices__c stdBestPract : inspectionBestPractices) {
      if (stdBestPractMapByName.containsKey(stdBestPract.Domain__c)) {
        stdBestPractMapByName.get(stdBestPract.Domain__c).add(stdBestPract);
      } else {
        List<Standard_Best_Practices__c> tempList = new List<Standard_Best_Practices__c>();
        tempList.add(stdBestPract);
        stdBestPractMapByName.put(stdBestPract.Domain__c, tempList);
      }
    }
    System.debug('----> stdBestPractMapByName: ' + stdBestPractMapByName);
    return stdBestPractMapByName;
  }

  public void getVisitBestPractices() {
    // Query all the BP's from the visit. 
    visitBPList = [Select Id, Name, Observation__c, Best_Practice_Guidance__c, Best_Practice__r.Domain__c From Visit_Best_Practices__c Where Associated_Visit__c = :inspectionRecord.Id];
  }

  public PageReference getInspectionItemData() {
    numberItemsNonSelected = 0;
    string sortFullExp = sortExpression + ' ' + sortDirection;
    iiWrapperList = new List<InspectionListWrapper> ();
    string str;
    if (inspectionRecord.Can_be_edited__c && inspectionRecord.Status__c != 'Closed' && inspectionRecord.Status__c != 'Cancelled') {
          String filterWhere = ''; 
          if (String.isNotBlank(selectedResultFilter)) {
            System.debug('-----> selectedResultFilter: ' + selectedResultFilter);
            if (selectedResultFilter == 'NoneSelected') {
              filterWhere = ' and Inspection_Result__c = null and Non_Assessed_Item__c = false';
            }
            else if (selectedResultFilter == 'NonAssessed') {
              String strNA = 'Non Assessed (tool abandoned)';
              filterWhere = ' and Inspection_Result__c =: strNA';
            }
            else if (selectedResultFilter == 'KeyIndicators') {
              filterWhere = ' and Key_Indicator__c = true';
            }
            else if (selectedResultFilter == 'NotAssessed') {
              str = 'Not Assessed';
              filterWhere = ' and Inspection_Result__c =: str';
              system.debug('filter value '+filterWhere);
            }else if (selectedResultFilter == 'Non-Compliant') {
              str = 'Non-Compliant';
              filterWhere = ' and Inspection_Result__c =: str';
              system.debug('filter value3 '+filterWhere);
            }else if (selectedResultFilter == 'NotApplicable') {
              str = 'Not Applicable';
              filterWhere = ' and Inspection_Result__c =: str';
              system.debug('filter value2 '+filterWhere);
            }else if (selectedResultFilter == 'Compliant') {
              str = 'Compliant';
              filterWhere = ' and Inspection_Result__c =: str';
              system.debug('filter value2 '+filterWhere);
            }
          }
    
          if (String.isNotBlank(selectedCategoryFilter)) {
            if (selectedCategoryFilter == 'NS') {
              filterWhere = filterWhere + ' and Category_list__c = null';
            } else {
              filterWhere = filterWhere + ' and Category_list__c = \'' + selectedCategoryFilter + '\''; 
            }
          }
    
          //System.debug('****selectedResultFilter - ' + selectedResultFilter+' *****selectedCategoryFilter - '+selectedCategoryFilter);
          //System.debug('****filterWhere - ' + filterWhere);
    
          String iiQuery = 'SELECT Id, name,Assessed_Date__c, Category_standard__c, Correction_Plan__c ,Date_Implemented__c, RecordType.Name,Associated_regulation__c,Associated_regulation__r.name,Associated_regulation__r.article__c,Category_list__c,' +
          'Inspection_Item_Name__c,Additional_Inspection_Item_Name__c,Standard_Inspection_Item__c,Description_of_inspection__c,Visit_Mode_Ranking__c,Inspection_Result__c, ' +
          'Discussed__c, Observations__c,Technical_assistance__c,Key_Indicator__c,Non_Assessed_Item__c,Description_of_inspection_list__c,Standard_Inspection_Item__r.Guidance__c from Inspection_Item__c where Inspection_No__c = \'' + inspectionRecord.Id + '\'' + filterWhere + ' order by Visit_Mode_Ranking__c ASC nulls first,Key_Indicator__c DESC,Random_Item_from_Visit_Tool__c, name ASC,' + sortFullExp;
    
        system.debug('query result value '+iiQuery);
        
          List<Inspection_Item__c> iiList = Database.query(iiQuery);
          Set<Id> siSet = new Set<Id> ();
          if (iiList != null && iiList.size() > 0) {
            for (Inspection_Item__c ii : iiList) {
              if (ii.RecordType.Name == 'Standard Visit Item') {
                siSet.add(ii.Standard_Inspection_Item__c);
              }
            }
    
            Map<Id, Map<String, Id>> iregulationMap = new Map<Id, Map<String, String>> ();
            Map<String, String> jiMap;
            for (Junction_InspReg__c jir :[select Id, Regulation__c, Regulation__r.name, Regulation__r.article__c, Standard_Inspection_Item__c from Junction_InspReg__c where Standard_Inspection_Item__c in :siSet]) {
              if (iregulationMap.containsKey(jir.Standard_Inspection_Item__c)) {
                iregulationMap.get(jir.Standard_Inspection_Item__c).put(jir.Regulation__r.name + ',', jir.Regulation__c);
              }
              else {
                jiMap = new Map<String, String> ();
                jiMap.put(jir.Regulation__r.name + ',', jir.Regulation__c);
                iregulationMap.put(jir.Standard_Inspection_Item__c, jiMap);
              }
            }
            // Get all the applicable domains to the visit items along with a unique mapping of them.
            Map<String, String> uniqueDomainMap = new Map<String, String>();
            for (Inspection_Item__c ii : iiList) {
              if (ii.Category_list__c != null) {
                applicableDomains.add(ii.Category_list__c);
                // Check if the domain has been added to the map yet. If not then add it.
                if (!uniqueDomainMap.containsKey(ii.Category_list__c)) {
                  uniqueDomainMap.put(ii.Category_list__c, ii.Category_list__c);
                }
              }
            }
            // Create the all domains list for the bp modal.
            allDomainList.add(new SelectOption('', ''));
            if (uniqueDomainMap != null && uniqueDomainMap.size() > 0) {
              for (String domain : uniqueDomainMap.values()) {
                allDomainList.add(new SelectOption(domain, domain));
              }
            }
            // Get the best practices.
            stdBestPractMapByName = retrieveBestPractices(applicableDomains);
    
            Integer rowIndex = 0;
            for (Inspection_Item__c ii : iiList) {
              if (ii.Inspection_Result__c == null || ii.Inspection_Result__c == '') {
                numberItemsNonSelected = numberItemsNonSelected + 1;
              }
              System.debug('System Result---->' + ii.Inspection_Result__c);
              // Create a new wrapper for the inspection item.
              InspectionListWrapper newWrapper = new InspectionListWrapper(rowIndex, ii, iregulationMap);
              // Verify if the inspection item has an attachment.
              if (inspectionItemsWithAttachments.contains(ii.Id)) {
                newWrapper.hasAttachment = true;
              }
              System.debug('----> Item Catagory Standard: ' + ii.Category_list__c);
              // Add the standard best practice list for the item to the wrapper. 
              if (stdBestPractMapByName.containsKey(ii.Category_list__c)) {
                System.debug('----> Attaching Best Practice items List');
                System.debug('----> Item Name: ' + ii.Inspection_Item_Name__c);
                newWrapper.processStdBestPractices(stdBestPractMapByName.get(ii.Category_list__c));
              }
              // Add to the list.
              iiWrapperList.add(newWrapper);
              rowIndex = rowIndex + 1;
            }
          }
          else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no Visit Items for this Visit.'));
          }
    }
    else {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director.'));
    }
    return null;
  }


  public PageReference getInspItemDataTabletView() {
    iiWrapperList = new List<InspectionListWrapper> ();

    if (inspectionRecord.Can_be_edited__c) {

      String iiQuery = 'SELECT Id, name,Assessed_Date__c, Category_standard__c, Correction_Plan__c , Date_Implemented__c, RecordType.Name,Associated_regulation__c,Associated_regulation__r.name,Associated_regulation__r.article__c,Category_list__c,' +
      'Inspection_Item_Name__c,Additional_Inspection_Item_Name__c,Standard_Inspection_Item__c,Description_of_inspection__c,Inspection_Result__c, ' +
      'Discussed__c, Observations__c,Technical_assistance__c,Key_Indicator__c,Non_Assessed_Item__c,Description_of_inspection_list__c,Standard_Inspection_Item__r.Guidance__c from Inspection_Item__c where Inspection_No__c = \'' + inspectionRecord.Id + '\'';

      List<Inspection_Item__c> iiList = Database.query(iiQuery);
      Set<Id> siSet = new Set<Id> ();
      if (iiList != null && iiList.size() > 0) {
        for (Inspection_Item__c ii : iiList) {
          if (ii.RecordType.Name == 'Standard Visit Item') {
            siSet.add(ii.Standard_Inspection_Item__c);
          }
        }

        Map<Id, Map<String, Id>> iregulationMap = new Map<Id, Map<String, String>> ();
        Map<String, String> jiMap;
        for (Junction_InspReg__c jir :[select Id, Regulation__c, Regulation__r.name, Regulation__r.article__c, Standard_Inspection_Item__c from Junction_InspReg__c where Standard_Inspection_Item__c in :siSet]) {
          if (iregulationMap.containsKey(jir.Standard_Inspection_Item__c)) {
            iregulationMap.get(jir.Standard_Inspection_Item__c).put(jir.Regulation__r.name + ',', jir.Regulation__c);
          }
          else {
            jiMap = new Map<String, String> ();
            jiMap.put(jir.Regulation__r.name + ',', jir.Regulation__c);
            iregulationMap.put(jir.Standard_Inspection_Item__c, jiMap);
          }
        }
        // Get all the applicable domains to the visit items along with a unique mapping of them.
        Map<String, String> uniqueDomainMap = new Map<String, String>();
        for (Inspection_Item__c ii : iiList) {
          applicableDomains.add(ii.Category_list__c);
          // Check if the domain has been added to the map yet. If not then add it.
          if (!uniqueDomainMap.containsKey(ii.Category_list__c)) {
            uniqueDomainMap.put(ii.Category_list__c, ii.Category_list__c);
          }
        }
        // Create the all domains list for the bp modal.
        allDomainList.add(new SelectOption('', ''));
        for (String domain : uniqueDomainMap.values()) {
          if(domain != null)  
            allDomainList.add(new SelectOption(domain, domain));
        }
        // Get the best practices.
        stdBestPractMapByName = retrieveBestPractices(applicableDomains);

        Integer rowIndex = 0;
        for (Inspection_Item__c ii : iiList) {
          // Create a new wrapper for the inspection item.
          InspectionListWrapper newWrapper = new InspectionListWrapper(rowIndex, ii, iregulationMap);
          // Verify if the inspection item has an attachment.
          if (inspectionItemsWithAttachments.contains(ii.Id)) {
            newWrapper.hasAttachment = true;
          }
          System.debug('----> Item Catagory Standard: ' + ii.Category_list__c);
          // Add the standard best practice list for the item to the wrapper. 
          if (stdBestPractMapByName.containsKey(ii.Category_list__c)) {
            System.debug('----> Attaching Best Practice items List');
            newWrapper.processStdBestPractices(stdBestPractMapByName.get(ii.Category_list__c));
          }
          // Add to the list.
          System.debug('----> ilw from getList: ' + newWrapper);
          iiWrapperList.add(newWrapper);
          rowIndex = rowIndex + 1;
        }
      }
      else {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no Visit Items for this Visit.'));
      }
    }
    else {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director.'));
    }
    return null;
  }

  public void checkForAttachments() {
    // Get all the inspection items ids in one query.
    List<Inspection_Item__c> inspectionItemsList = [Select Id From Inspection_Item__c Where Inspection_No__c = :inspectionRecord.Id];
    Set<Id> inspectionItemsIdList = (new Map<Id, SObject> (inspectionItemsList)).keySet();
    // Get all the attachments.
    List<Attachment> inspectionItemsAttachments = [Select Id, Name, ParentId From Attachment Where ParentId IN :inspectionItemsIdList];
    // Loop through all the attachments for inspection items and make a mapping of it.
    for (Attachment a : inspectionItemsAttachments) {
      inspectionItemsWithAttachments.add(a.ParentId);
    }
  }

  public PageReference retrieveBestPracticeListForDomain() {
    String domain = ApexPages.currentPage().getParameters().get('domain');
    List<Standard_Best_Practices__c> bpList = stdBestPractMapByName.get(domain);
        System.debug('Domain---->' + domain);
    System.debug('bpList---->' + bpList);
    if (bpList != null && bpList.size() > 0) {
      activeDomainBPList = processStdBestPractices(bpList);
    } else {
      activeDomainBPList = null;
    }
    return null;
  }
  public PageReference markBulkAssessForDomain() {
    if(filterCriteria != null && filterCriteria != 'all'){
      filterCriteria = filterCriteria.substring(1, filterCriteria.length());
    }
    System.debug('-------> Filter Criteria: ' + filterCriteria);
    List<Inspection_Item__c> iiToBeUpdated = new List<Inspection_Item__c>();
    if (filterCriteria != null) {
      getInspItemDataTabletView();
      for (InspectionListWrapper ilw : iiWrapperList) {
        System.debug('-----> ilw: ' + ilw);
        if ( ilw.result == null && !ilw.nonAssessed && ( 
              filterCriteria == 'all' || filterCriteria == 'non-selected' || 
              ilw.iCategory.contains(filterCriteria))){
          System.debug('------> filter criteria matched');
          Inspection_Item__c ii = new Inspection_Item__c();
          ii.Id = ilw.id;
          ii.Inspection_Result__c = bulkPickVal;
          ii.observations__c = String.isNotBlank(bulkObservation) ? bulkObservation : null;
          iiToBeUpdated.add(ii);
        } 
      }
      if(iiToBeUpdated != null && iiToBeUpdated.size() > 0){
        update iiToBeUpdated;
        getInspItemDataTabletView();
      }
    }
    return null;
  }

  public void unLockVisitMode(){
    Inspection__c v = [Select Visit_Mode_Lock__c From Inspection__c Where Id =:inspectionRecord.Id];
    v.Visit_Mode_Lock__c = false;
    update v;
  }

  public PageReference Save() {
    System.debug('**************11' + visitModeLocked + 'lockedByusername' + lockedByUserName);
    
    saveInspectionItems();
    return null; 
  }

  public PageReference SaveReason() {
    String reason = ApexPages.currentPage().getParameters().get('reason');
    String mode = ApexPages.currentPage().getParameters().get('mode');  
    if (iiWrapperList != null) {
      for (InspectionListWrapper ilw : iiWrapperList) {
        if ((String.isBlank(ilw.result) || ilw.result == null) && !ilw.nonAssessed) {
          ilw.result = 'Non Assessed (tool abandoned)';
        }
      }
      inspectionRecord.Abandon_Tool_Reason__c = reason;
      update inspectionRecord;
      saveInspectionItems();
    }
    if(String.isBlank(mode)) {   
        PageReference fPage= new PageReference('/apex/InspectVisitMode?id=' + inspectionRecord.Id);
        fPage.setRedirect(true);
        return fPage;  
    }
    else return null;
  }

  public PageReference SaveAndCloseVisitMode() {
    System.debug('-----> VisitModeLock: ' + visitModeLocked);
    if(visitModeLocked && STRING.isNotBlank(lockedByUserName) && UserInfo.getUserName() != lockedByUserName){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This is view-only visit mode and is locked for editing.'));
      return null;
    }
    if(saveInspectionItems()){
      //Mod by LD - Below method as a fix for BMMS-117
        unLockVisitMode();
        return (new PageReference('/'+inspectionRecord.Id));
    }
    return null;
  }

  public PageReference CancelAndCloseVisitMode(){
       //System.debug('Inspect Modes before cancel and close' + defaultIIWrapperList); 
       //iiWrapperList = defaultIIWrapperList;
       //System.debug('Initial Pass--->'+ initialPass);
       //System.debug('iiWrapperList--->'+ iiWrapperList);
       //System.debug('defaultIIWrapperList--->'+ defaultIIWrapperList); 
      if(visitModeLocked && UserInfo.getUserName() == lockedByUserName){
          //Mod by LD - Below method as a fix for BMMS-327
        unLockVisitMode();
      }
      return (new PageReference('/'+inspectionRecord.Id));  
    }

  public PageReference SaveAndAddNewVisitItem() {
    if(visitModeLocked && UserInfo.getUserName() != lockedByUserName){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This is view-only visit mode and is locked for editing.'));
      return null;
    }
    if (saveInspectionItems()) {
      PageReference returnURL;
      //returnURL = new PageReference('/a05/e');
      //returnURL.getParameters().put('ent', '01Ij000000103LX');
      returnURL = new PageReference('/setup/ui/recordtypeselect.jsp');
      returnURL.getParameters().put('ent', '01Ij000000103LX');
      //returnURL.getParameters().put('cancelURL', '/apex/InspectVisitMode?id='+inspectionRecord.Id);
      //returnURL.getParameters().put('retURL', '/apex/InspectVisitMode?id='+inspectionRecord.Id);
      //returnURL.getParameters().put('retURL', '/a05/e');
      returnURL.getParameters().put('CF00Nj0000006QWNK', inspectionRecord.name);
      returnURL.getParameters().put('save_new_url', '/a05/e?retURL=apex/InspectVisitMode?id=' + inspectionRecord.Id + '&saveURL=apex/InspectVisitMode?id=' + inspectionRecord.Id);
      //returnURL.getParameters().put('save_new_url', '/apex/InspectVisitMode?id='+inspectionRecord.Id);

      return returnURL;
    }
    return null;
  }
  public PageReference SaveAndAddNewBP() {
    if(visitModeLocked && UserInfo.getUserName() != lockedByUserName){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This is view-only visit mode and is locked for editing.'));
      return null;
    }
    if (saveInspectionItems()) {
      PageReference returnURL;
      Schema.DescribeSObjectResult r = Visit_Best_Practices__c.sObjectType.getDescribe(); 
      String keyPrefix = r.getKeyPrefix();  
      keyPrefix = '/' + keyPrefix + '/e';   
      returnURL = new PageReference(keyPrefix); 
      returnURL.getParameters().put('ent', '01I21000000CjHt');
      returnURL.getParameters().put('CF00Ng0000001jhor', inspectionRecord.name);
      returnURL.getParameters().put('cancelURL', '/apex/InspectVisitMode?id='+inspectionRecord.Id);
      returnURL.getParameters().put('saveURL', '/apex/InspectVisitMode?id='+inspectionRecord.Id);  

      return returnURL;
    }
    return null;
  }  
  private Boolean saveInspectionItems() {
    Inspection__c insp = [SELECT Id, Can_be_edited__c, Offline_Lock__c FROM Inspection__c WHERE Id =: inspectionRecord.Id LIMIT 1];  
    List<Inspection_Item__c> updateiiList = new List<Inspection_Item__c> ();
    List<Inspection_Item__c> deleteiiList = new List<Inspection_Item__c> ();
    Boolean setStartTime = false;
    numberItemsNonSelected = 0;
    if (iiWrapperList != null && insp.Can_be_Edited__c && !insp.Offline_Lock__c) {
      Inspection_Item__c iItem;
      for (InspectionListWrapper ilw : iiWrapperList) {
        iItem = new Inspection_Item__c();
        if (ilw.isDeleted) {
          iItem.Id = ilw.Id;
          deleteiiList.add(iItem);
        }
        else {
          System.debug('**************14 ' + ilw.Id + '--' + ilw.correctionPlan + ' -- ' + ilw.observations);
          iItem.Id = ilw.Id;
          System.debug('**************Result ' + ilw.result);
          iItem.Inspection_Result__c = ilw.result;
          iItem.Discussed__c = ilw.discussion;
          iItem.Technical_Assistance__c = ilw.techAssistance;
          iItem.Key_Indicator__c = ilw.Keyindicator;
          iItem.observations__c = ilw.observations;
          iItem.Correction_Plan__c = ilw.correctionPlan;
          if (String.isNotBlank(ilw.correctionPlan) && iItem.Date_Implemented__c == null) {
            System.debug('Correction Plan ---- >' + ilw.correctionPlan);
            iItem.Date_Implemented__c = date.today();
          }
          else {
            iItem.Date_Implemented__c = null;
            iItem.Corrective_Actions_Submitter__c = null;
            iItem.Date_Corrective_Actions_Received__c = null;
          }
          if (String.isNotBlank(ilw.correctionPlan) && ilw.result != 'Non-Compliant') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Corrective Action should only be captured on non-compliant item. Please review before saving.'));
            return false;
          }
          if ((ilw.result == 'Non-Compliant'||ilw.result == 'Not Assessed'||ilw.result == 'Not Applicable') && String.isBlank(ilw.observations)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Observations should be provided for non-compliant, not assessed and not applicable items as it will be used in Non-Compliant, Not Assessed and Not Applicable statements.'));
            return false;
            //break;
          }
          if (ilw.Result == null || ilw.Result == '') {
            numberItemsNonSelected = numberItemsNonSelected + 1;
          }
          if (ilw.Result != null || ilw.Result != '') {
            setStartTime = true;
          }
          updateiiList.add(iItem);
        }
      }
      if (setStartTime && inspectionRecord.Start_Time__c == null) {
        inspectionRecord.Start_Time__c = datetime.now();
        update inspectionRecord;
      }

      System.debug('******Deleting Inspected Items --- ' + deleteiiList);
      System.debug('******Updating Inspected Items --- ' + updateiiList);
      if (deleteiiList.size() > 0) {
        delete deleteiiList;
      }
      if (updateiiList.size() > 0) {
        System.debug('-------> Inspection Item list to be updated: ' + updateiiList);
         update updateiiList;
      }
  
      getInspectionItemData();
    }
    else {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director.'));
                return false;
    }
    return true;
  }

  public PageReference MarkCompliant() {
    for (InspectionListWrapper iiw : iiWrapperList) {
      if ((iiw.result == null || iiw.result == '') && !iiw.nonAssessed) {
        iiw.result = 'Compliant';
      }
    }
    return null;
  }
  
  public PageReference MarkBulkAssess() {

    for (InspectionListWrapper iiw : iiWrapperList) {
      if ((iiw.result == null || iiw.result == '') && !iiw.nonAssessed) {
        iiw.result = bulkPickVal;
        iiw.observations = bulkObservation ;
      }
    }
    return null;
  }


  public PageReference DeleteInspectionItem() {
    String deleteIndex = ApexPages.currentPage().getParameters().get('deleteIndex');
    String deleteId = ApexPages.currentPage().getParameters().get('deleteId');

    if (String.isNotBlank(deleteIndex)) {
      InspectionListWrapper ilw = iiWrapperList.get(Integer.valueOf(deleteIndex));
      ilw.isDeleted = true;
    }
    return null;
  }


  /*
   * The following methods are used for rendering and updates of records 
   * when the visit mode is displayed/used via a Tablet device.
   * For performance and ease of access the methods have been modified
   * 
   */

  //Create new visit item tablet-view
  public PageReference NewVisitItemTabletView() {
    PageReference returnURL;
    returnURL = new PageReference('/setup/ui/recordtypeselect.jsp');
    returnURL.getParameters().put('ent', '01Ij000000103LX');
    returnURL.getParameters().put('CF00Nj0000006QWNK', inspectionRecord.name);
    returnURL.getParameters().put('save_new_url', '/a05/e?retURL=apex/EEC_VisitModeTabletVersion?id=' + inspectionRecord.Id + '&saveURL=apex/EEC_VisitModeTabletVersion?id=' + inspectionRecord.Id);

    return returnURL;
  }

  //SaveItems for when items are displayed on a tablet device and saved individually
  public PageReference SaveItems() {
    errorMessage = '';
    String correctionPlan = ApexPages.currentPage().getParameters().get('correctionPlan');
    String observations = ApexPages.currentPage().getParameters().get('observations');
    String techAssistance = ApexPages.currentPage().getParameters().get('techAssistance');
    String result = ApexPages.currentPage().getParameters().get('result');
    String itemId = ApexPages.currentPage().getParameters().get('itemId');
    String fileContent = ApexPages.currentPage().getParameters().get('att');
    String fileName = ApexPages.currentPage().getParameters().get('fileName');

    saveInspectionItem(correctionPlan, observations, techAssistance, itemId, result, fileContent, fileName);
    getInspItemDataTabletView();

    return null;
  }

  public Boolean saveInspectionItem(String correctionPlan, String observations, String techAssistance, String itemId, String result, String fileContent, String fileName) {
    Inspection_Item__c item = [SELECT Id, Corrective_Actions_Submitter__c, Date_Corrective_Actions_Received__c,
                               Correction_Plan__c, Date_Implemented__c, Observations__c,
                               Technical_assistance__c, Inspection_Result__c, Inspection_No__r.Status__c
                               FROM Inspection_Item__c WHERE Id = :itemId];

    if (item != null && item.Inspection_No__r.Status__c != 'Closed' && item.Inspection_No__r.Status__c != 'Cancelled')
    {
      item.Correction_Plan__c = correctionPlan;
      if (String.isNotBlank(correctionPlan)){
        item.Date_Implemented__c = date.today();
      }
      else {
        item.Date_Implemented__c = null;
        item.Corrective_Actions_Submitter__c = null;
        item.Date_Corrective_Actions_Received__c = null;
      }
      item.Observations__c = observations;
      item.Technical_assistance__c = techAssistance;
      item.Inspection_Result__c = result;
      System.debug('File Content:' + fileContent);
      if (fileName != '') {
        System.debug('File Name:' + fileName);
        Attachment a = new Attachment();
        if (fileContent != null) {
          a.Body = EncodingUtil.base64Decode(fileContent);
          a.OwnerId = UserInfo.getUserId();
          a.parentId = itemId;
          a.Name = fileName;
          this.tAttachment.Body = null;

          Database.Insert(a);
        }
      }
      update item;
    }
    return true;
  }
  /**
   * Update Visit Start Time
   * 
   **/

  public PageReference StartTimer() {
    String inspID = ApexPages.currentPage().getParameters().get('inspID');
    if (inspectionRecord != null) {
      inspectionRecord.Start_Time__c = datetime.now();
      update inspectionRecord;
    }
    if (ApexPages.currentPage().getParameters().get('id') != null)
        return new PageReference('/apex/InspectVisitMode?scontrolCaching=1&id=' + inspID);
    else
        return null;
  }

  public PageReference EndTimer() {
    String inspID = ApexPages.currentPage().getParameters().get('inspID');
    if (inspectionRecord != null) {
      inspectionRecord.End_Time__c = datetime.now();
      update inspectionRecord;
    }
    if (ApexPages.currentPage().getParameters().get('id') != null)
        return new PageReference('/apex/InspectVisitMode?scontrolCaching=1&id=' + inspID);
    else
        return null;
  }

  //Tablet mode mark compliant
  public PageReference MarkCompliantTabletView() {
    for (InspectionListWrapper iiw : iiWrapperList) {
      if ((iiw.result == null || iiw.result == '') && !iiw.nonAssessed) {
        iiw.result = 'Compliant';
      }
    }
    Save();
    return null;
  }

  public String selectedIds { get; set; }
  public PageReference MarkSelectionCompliant() {
    List<Inspection_Item__c> lstCompliantItems = new List<Inspection_Item__c>();
    String ids = ApexPages.currentPage().getParameters().get('ids');
    if (ids != null) {
      Set<string> allIds = new Set<String> (ids.split(','));
        for(Inspection_Item__c item : [SELECT Id,Non_Assessed_Item__c,Key_Indicator__c, Inspection_Result__c  
                                       FROM Inspection_Item__c WHERE Id IN: allIds]){
            if((item.Inspection_Result__c  == null || item.Inspection_Result__c  == '') && !item.Non_Assessed_Item__c){
                item.Inspection_Result__c  = 'Compliant';
                lstCompliantItems.add(item);
            }
        }
        if(lstCompliantItems.size() > 0)
            update lstCompliantItems;
    }
    return null;
  }
  public Pagereference showDesc() {
    return null;
  }

  public PageReference uploadAttachment() {

    return null;
  }

  public PageReference SaveBP() {
    String bpID = ApexPages.currentPage().getParameters().get('bpID');
    String observationText = ApexPages.currentPage().getParameters().get('optObservation');
    String vbpId = ApexPages.currentPage().getParameters().get('vbpId'); 

    try {
      Visit_Best_Practices__c newVBP = new Visit_Best_Practices__c(
        Observation__c = observationText
      );
        
      if (!String.isBlank(vbpId)) {
      System.debug('----> UPDATE!');
        newVBP.Id = vbpId;      
      }  else {
        System.debug('----> NEW!');
        newVBP.Associated_Visit__c = inspectionRecord.Id;
        newVBP.Best_Practice__c = bpID;  
      }
      upsert newVBP;
      getVisitBestPractices();
    } catch (Exception e) {
      System.debug('-----> Exception: ' + e.getMessage());  
    }
    return null;
  }

  public PageReference DeleteBP() {
    String bpID = ApexPages.currentPage().getParameters().get('bpID');

    if (!String.isBlank(bpID)) {
      Visit_Best_Practices__c vbpToDelete = null;
      List<Visit_Best_Practices__c> updatedVBPList = new List<Visit_Best_Practices__c>();

      for (Visit_Best_Practices__c vbp : visitBPList) {
        if (bpID.equalsIgnoreCase(vbp.Id)) {
          vbpToDelete = vbp;
        } else {
          updatedVBPList.add(vbp);
        }
      }
      if (vbpToDelete != null) {
        delete vbpToDelete;
      }
      System.debug('----> Update VBP List: ' + updatedVBPList);
      getVisitBestPractices();
    }
    return null;
  }

  public List<SelectOption> processStdBestPractices(List<Standard_Best_Practices__c> stdBestPractList) {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', ''));
      for (Standard_Best_Practices__c stdBestPract : stdBestPractList) {
        options.add(new SelectOption(stdBestPract.Id, stdBestPract.Best_Practice_Guidance__c));
      }
    return options;
  }

  public class InspectionListWrapper {
    public Id Id { get; set; }
    public String name { get; set; }
    public Integer rowIndex { get; set; }
    public String Type { get; private set; }
    public Map<String, Id> regulationMap { get; set; }
    public String iCategory { get; set; }
    public String itemName { get; set; }
    public String description { get; set; }
    public String result { get; set; }
    public Boolean discussion { get; set; }
    public String techAssistance { get; set; }
    public String observations { get; set; }
    public Boolean isDeleted { get; set; }
    public Boolean nonAssessed { get; set; }
    public Boolean Keyindicator { get; set; }
    public Boolean hasAttachment { get; set; }
    public String correctionPlan { get; set; }
    public Boolean dateAI { get; set; }
    public List<SelectOption> itemBestPracticesOptions { get; set; }
    public String guidance { get; set; }  

    public InspectionListWrapper(Integer rowIndex, Inspection_Item__c insp, Map<Id, Map<String, String>> iRegMap) {
      this.Id = insp.Id;
      this.name = insp.name;
      this.rowIndex = rowIndex;
      this.Type = insp.RecordType.Name;
      this.regulationMap = null;
      if (this.Type == 'Standard Visit Item' && insp.Standard_Inspection_Item__c != null) {
        this.regulationMap = iRegMap.get(insp.Standard_Inspection_Item__c);
        this.itemName = insp.Inspection_Item_Name__c;
        this.guidance = insp.Standard_Inspection_Item__r.Guidance__c;  
      } else {
        this.itemName = insp.Additional_Inspection_Item_Name__c;
        this.regulationMap = new Map<String, Id> ();
        if (insp.Associated_regulation__c != null) {
          this.regulationMap.put(insp.Associated_regulation__r.name, insp.Associated_regulation__c);
        }
        system.debug(this.regulationMap+'MMMMMM'+this.name);
      }
      this.iCategory = insp.Category_list__c;
      this.description = insp.Description_of_inspection_list__c;
      this.result = insp.Inspection_Result__c;
      this.discussion = insp.Discussed__c;
      this.techAssistance = insp.technical_assistance__c;
      this.observations = insp.observations__c;
      this.nonAssessed = insp.Non_Assessed_Item__c;
      this.KeyIndicator = insp.Key_Indicator__c;
      system.debug('MMMMM'+this.nonAssessed+this.Id);
      this.isDeleted = false;
      if (insp.Date_Implemented__c != null) {
        DateTime impDate = insp.Assessed_Date__c;
        if (Date.newInstance(impDate.year(), impDate.month(), impDate.day()) == insp.Date_Implemented__c) {
          this.dateAI = true;
        } else {
         this.dateAI = false;
        }
      } else {
        this.dateAI = false;
      }
      if (insp.Correction_Plan__c != null)
      this.correctionPlan = insp.Correction_Plan__c;
    }

    public void processStdBestPractices(List<Standard_Best_Practices__c> stdBestPractList) {
      List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption('', ''));
      for (Standard_Best_Practices__c stdBestPract : stdBestPractList) {
        options.add(new SelectOption(stdBestPract.Id, stdBestPract.Best_Practice_Guidance__c));
      }
      itemBestPracticesOptions = options;
    }
  }
}