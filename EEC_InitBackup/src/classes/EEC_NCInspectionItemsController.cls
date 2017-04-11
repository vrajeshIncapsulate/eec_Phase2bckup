public with sharing class EEC_NCInspectionItemsController {

  private final Inspection__c inspectionRecord;

  public String recordTypeName { get; set; }

  public EEC_NCInspectionItemsController(ApexPages.StandardController controller) {
    //this.inspectionRecord = (Inspection__c) controller.getRecord();
    this.inspectionRecord = [
                             SELECT
                             Provider_No__c,
                             Provider_No__r.RecordTypeId,
                             CreatedDate, Date_of_Visit__c,
                             Original_Visit__r.Date_of_Visit__c
                             FROM Inspection__c WHERE Id = :controller.getId()
                            ];
  }

  public List<Inspection_Item__c> getNCInspItemList() {
    List<Inspection_Item__c> iItemList;
    Set<Id> inspectionSet = new Set<Id> ();

    String inspDateQuery = '';
    System.debug('*******1***** ' + inspectionRecord.Provider_No__c);
    String pRecordType = EEC_RecordTypeUtil.findById(inspectionRecord.Provider_No__r.RecordTypeId).DeveloperName;
    DateTime dateHist = (inspectionRecord.Date_of_Visit__c != null) ? inspectionRecord.Date_of_Visit__c : inspectionRecord.CreatedDate;

    if (pRecordType == 'FCC') {
      dateHist = dateHist.addYears(- 6);
    } else {
      dateHist = dateHist.addYears(- 4);
    }

    String whereClause = '';
    if (inspectionRecord.Original_Visit__c != null) {
      if ((inspectionRecord.Date_of_Visit__c != null && inspectionRecord.Original_Visit__r.Date_of_Visit__c != null)) {
        Date tDate = inspectionRecord.Original_Visit__r.Date_of_Visit__c;
        String calenderDate = datetime.newInstance(tDate.year(), tDate.month(), tDate.day()).format('yyyy-MM-dd');
        whereClause = ' and Date_of_Visit__c > ' + calenderDate;
      }
    } else {
      whereClause = ' and Status__c = \'Closed\' and Date_of_Visit__c >= ' + dateHist.format('yyyy-MM-dd') + ' and Date_of_Visit__c < ' + DateTime.now().AddDays(1).format('yyyy-MM-dd');
    }

    String iiQuery = 'select Id from Inspection__c where Provider_No__c != null AND Provider_No__c = \'' + inspectionRecord.Provider_No__c + '\' ' + whereClause;
    System.debug('***********iiQuery** ' + iiQuery);
    List<Inspection__c> inspList = Database.Query(iiQuery);
    // TODO: Switch this to just pull the keys into a map back into the set instead. 
    for (Inspection__c insp : inspList) {
      inspectionSet.add(insp.Id);
    }
    iItemList = [select Id, Inspection_No__c, Inspection_No__r.name, Inspection_No__r.Date_of_Visit__c, Name, Inspection_Item_Name_for_list__c, Category_list__c,
                 Description_of_inspection__c, Correction_Plan__c, Observations__c,Key_Indicator__c from Inspection_Item__c
                 where Inspection_No__c in :inspectionSet AND Inspection_No__c != :inspectionRecord.Id AND Inspection_Result__c = 'Non-Compliant' order by Inspection_No__r.Date_of_Visit__c desc];
    return iItemList;
  }

  public List<Non_Compliant__c> getNonCompliantItemList() {
    String pRecordType = EEC_RecordTypeUtil.findById(inspectionRecord.Provider_No__r.RecordTypeId).DeveloperName;
    Integer numOfYears = 4;

    if (pRecordType == 'FCC') {
      numOfYears = 6;
    }
    Date d1 = Date.today();
    Date d2 = d1.addYears(- numOfYears);
    List<Non_Compliant__c> ncList = new List<Non_Compliant__c>();
    System.debug('----> Date 1: ' + d1);
    System.debug('----> Date 2: ' + d2);  
      
    ncList = [Select Id, Name, CreatedDate, Investigation__r.Name, Correction_Plan__c, 
                                 Investigation__r.Provider_No__r.Is_R_P__c, Investigation__r.Provider_No__r.Is_GSA__c,
                                 Investigation__r.Provider_No__r.Record_Type_Name__c, Observations__c,Key_Indicator__c,
                                 Investigation__r.Investigation_Type__c From Non_Compliant__c Where Investigation__c IN
                                 (Select Id From Investigation__c Where Provider_No__c = :inspectionRecord.Provider_No__c)
                                 AND DAY_ONLY(convertTimezone(CreatedDate)) <= :d1 AND DAY_ONLY(convertTimezone(CreatedDate)) >= :d2 order by CreatedDate desc];
    System.debug('----> ncList: ' + ncList);
    return ncList;
  }

	public List<NCInspectionItemsWrapper> getAllNonCompliantItemsCombined() {
    	List<NCInspectionItemsWrapper> ncCombinedWrapper = new List<NCInspectionItemsWrapper>();
    	List<Inspection_Item__c> inspItems = getNCInspItemList();
    	List<Non_Compliant__c> ncItems = getNonCompliantItemList();
	    for (Inspection_Item__c item : inspItems)
      		ncCombinedWrapper.add(new NCInspectionItemsWrapper(item, null));
	 	for (Non_Compliant__c item : ncItems) 
      		ncCombinedWrapper.add(new NCInspectionItemsWrapper(null, item));
    	ncCombinedWrapper.sort();
    	return ncCombinedWrapper;
  	}

   	public class NCInspectionItemsWrapper implements Comparable {
    	public Inspection_Item__c inspItem{get;set;}
    	public Non_Compliant__c ncItem{get;set;}
    	public Boolean IsInspectionItem{get;set;}
    	public Boolean KeyIndicator{get;set;}
    	public datetime dt{get;set;}
	
    	public Integer compareTo(Object compareTo){
        	NCInspectionItemsWrapper NCWrapCompare = (NCInspectionItemsWrapper)compareTo;
        	if(dt>NCWrapCompare.dt)
                return -1;
           	else if(dt<NCWrapCompare.dt)
                return 1;
            else{
                if(KeyIndicator)
                    return -1;
               	else if(NCWrapCompare.KeyIndicator)
                    return 1;
                else
                	return 0;	
            }
    	}    
		public NCInspectionItemsWrapper(Inspection_Item__c inspItem, Non_Compliant__c ncItem) {
			this.inspItem = inspItem;
      		this.ncItem = ncItem;
      		dt=inspItem!=null?inspItem.Inspection_No__r.Date_of_Visit__c:ncItem.CreatedDate;
      		if(this.inspItem != null) 
     			this.KeyIndicator = inspitem.Key_Indicator__c;
    		else
     			this.KeyIndicator = ncitem.Key_Indicator__c;
    		if(this.inspItem != null)
				this.IsInspectionItem = true;
			else
        		this.IsInspectionItem = false;
    	}
  	}
}