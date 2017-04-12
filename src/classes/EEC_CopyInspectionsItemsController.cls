public with sharing class EEC_CopyInspectionsItemsController {
	
	private final Inspection__c inspectionRecord;
	//public List<Standard_Inspection_Item__c> siiList {get;set;}
	public List<SCRWrapper> scrWrapperList {get;set;}
  public Boolean disableButton {get; set;}
  public Boolean allowCopyItems {get; set;}
	
	public EEC_CopyInspectionsItemsController(ApexPages.StandardController controller) {
		this.inspectionRecord = (Inspection__c) controller.getRecord();
    Inspection__c i = [SELECT Id, Visit_Tool_Used__c, Mater_Visit_for_Res_Cluster_of_Visits__c FROM Inspection__c WHERE id =: inspectionRecord.Id];
    if(i.Mater_Visit_for_Res_Cluster_of_Visits__c != null){
      disableButton = true;
      allowCopyItems = false;
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This visit has a master, please use the master to set the checklist to be used.'));
    } else if(i.Visit_Tool_Used__c != null){
      disableButton = true;
      allowCopyItems = false;
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A Visit Tool has already been used for this visit.'));
    } else {
      disableButton = false;
      allowCopyItems = true;
    }

	}
	
	public void populateLists() {
	 if(!allowCopyItems){
    System.debug('******* Copy items not allowed.');
    return;
   }
	 scrWrapperList = new List<SCRWrapper>();
	 if(inspectionRecord.Can_be_edited__c){
		/*List<License__c> licenseList = [select Id,RecordType.Name from License__c where Provider_No__c = :inspectionRecord.Provider_No__c and License_Status__c = 'Active'];
	 	if(licenseList != null && licenseList.size() > 0){
	 		License__c license = licenseList.get(0);*/
	 		String scrIds = '';
	 		String scrQuery = 'select Id,Name from Standard_Checklist_Reference__c where Active__c = true and Applicable_To__c includes (\''+inspectionRecord.Provider_No__r.RecordType.Name+'\')';
	 		List<Standard_Checklist_Reference__c> scrList = Database.Query(scrQuery);
	 		if(scrList != null && scrList.size() > 0){
	 			for(Standard_Checklist_Reference__c scr : scrList){
	 				scrIds = scrIds + '\''+ scr.Id + '\',';
	 			}
	 			
	 			scrIds = scrIds.subString(0,scrIds.length()-1);
	 			String jiQuery = 'Select Standard_Inspection_Item__c,Standard_Inspection_Item__r.name, Standard_Checklist_Reference__c, Non_Assessed_Item__c '+
	 							 'From Junction_ChklInsp__c  where Standard_Checklist_Reference__c in  ('+scrIds+') order by Name asc';
	 			/*String siiQuery = 'select Id,name,Applicable_To__c,Description__c from Standard_Inspection_Item__c where Id in '+
	 			                    '(select Standard_Inspection_Item__c from Junction_ChklInsp__c where Standard_Checklist_Reference__c in ('+scrIds+')) order by Name asc';
	 			*/
	 			List<Junction_ChklInsp__c> jciList = Database.Query(jiQuery);
	 			
	 			Map<Id, List<SIIWrapper>> siiMap = new Map<Id, List<SIIWrapper>>();
	 			List<SIIWrapper> siiMapList = null;
	 			if(jciList != null && jciList.size() > 0){
	 				for(Junction_ChklInsp__c jci : jciList){
	 					//siiWrapperList.add(new SIIWrapper(sii));
	 					if(siiMap.containsKey(jci.Standard_Checklist_Reference__c)){
	 						siiMap.get(jci.Standard_Checklist_Reference__c).add(new SIIWrapper(jci));
	 					}
	 					else{
	 						siiMapList = new List<SIIWrapper>();
	 						siiMapList.add(new SIIWrapper(jci));
	 						siiMap.put(jci.Standard_Checklist_Reference__c,siiMapList);
	 					}
	 				}
	 					 				
	 				for(Standard_Checklist_Reference__c scr : scrList){
	 					scrWrapperList.add(new SCRWrapper(scr,siiMap.get(scr.Id)));
	 				}
	 				System.debug('*********scrWrapperList*********'+scrWrapperList);
	 			}
	 			else{
	 				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no Standard Inspection items to copy.'));
	 			}
	 			
	 		}
	 		else{
	 			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no \'Active\' Standard check list for this Inspection.'));
	 		}
	 		
	 	/*}
	 	else{
	 		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no \'Active\' License for the Provider.'));
	 	}*/
	 }
	 else{
	 	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director.'));
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
    
    public PageReference copyInspectionItems(){
    	if(!allowCopyItems){
        System.debug('******* Copy items not allowed.');
        return null;
       }
    	PageReference resultPage = null;
        List<Inspection__c> childVisits = new List<Inspection__c>();
        
        if (inspectionRecord.Mater_Visit_for_Res_Cluster_of_Visits__c == null) {
          childVisits = [Select Id From Inspection__c Where Mater_Visit_for_Res_Cluster_of_Visits__c = :inspectionRecord.Id];                    
        }
    	
    	if(isSIISelected){
    		List<Inspection_Item__c> iiList = new List<Inspection_Item__c>();
    		Inspection_Item__c ii;
            for (SCRWrapper scr : scrWrapperList) {
            	if(scr.selected){
            		for(SIIWrapper sii : scr.stiList){
		            	ii = new Inspection_Item__c();
		            	ii.Inspection_No__c = inspectionRecord.Id;
		            	ii.Standard_Inspection_Item__c = sii.Id;
		            	ii.Non_Assessed_Item__c = sii.nonAccessedItem;
		            	ii.RecordTypeId = EEC_RecordTypeUtil.findByName('Inspection_Item__c.Standard_Item').Id;
		            	iiList.add(ii);
                        // If there are child visits to this portential master.
                        if (childVisits != null && childVisits.size() > 0) {
                          // Loop through the children.
                          for (Inspection__c child : childVisits) {
                            // Create a new item for the child entry.
                            ii = new Inspection_Item__c();
		            	    ii.Inspection_No__c = child.Id; 
		            	    ii.Standard_Inspection_Item__c = sii.Id;
		            	    ii.Non_Assessed_Item__c = sii.nonAccessedItem;
		            	    ii.RecordTypeId = EEC_RecordTypeUtil.findByName('Inspection_Item__c.Standard_Item').Id;
                            iiList.add(ii);
                          }  
                        }
            		}
            	}
                inspectionRecord.Visit_Tool_Used__c = scr.Id;
            }
            
            if(iiList != null && iiList.size() > 0){
            	insert iiList;
            }
            
            update inspectionRecord;
    		return (new PageReference('/'+inspectionRecord.Id));
    	}
    	else{
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Atleast one item should be selected.'));
    	}
    	
    	return resultPage;
    	
    }
    
     public class SIIWrapper{
     	
     	public Id Id {get;set;}
     	public String name {get; private set;}
     	public Boolean nonAccessedItem {get;set;}
     	public SIIWrapper(Junction_ChklInsp__c jci) {
     		this.Id = jci.Standard_Inspection_Item__c;
            this.name = jci.Standard_Inspection_Item__r.name;
            this.nonAccessedItem = jci.Non_Assessed_Item__c;
        }
        
     }
     
     public class SCRWrapper{
     	
     	public Id Id {get;set;}
     	public String name {get; private set;}
     	public Boolean selected {get; set;}
     	public List<SIIWrapper> stiList {get;set;}
     	
     	
     	public SCRWrapper(Standard_Checklist_Reference__c scr, List<SIIWrapper> stList) {
     		this.Id = scr.Id;
            this.name = scr.name;
            this.selected = false;
            this.stiList = stList;
        }
        
     }

}