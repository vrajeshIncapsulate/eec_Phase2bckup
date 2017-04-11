public with sharing class EEC_CorrectiveActionReviewController {

        private final Inspection__c inspectionRecord;
        public List<InspectionListWrapper> iiWrapperList {get;set;}
        private String sortDirection = 'ASC';
        private String sortExp = 'RecordTypeId';
        public list<Submission_History__c> SHlist{get;set;}
        public set<id> itemid= new set<id>();
        
        
        public EEC_CorrectiveActionReviewController(ApexPages.StandardController controller) {
            this.inspectionRecord = (Inspection__c) controller.getRecord();
            getInspectionItemData();
            getSHlist();
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
                 sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
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
        public void getSHlist(){
         SHlist=new list<Submission_History__c>([select id,name,Visit_Item__c from Submission_History__c where Visit_Item__c IN: itemid]);
        system.debug('MMMM'+shlist.size());
        }
        
        public PageReference getInspectionItemData(){
            //numberItemsNonSelected = 0;
            string sortFullExp = sortExpression  + ' ' + sortDirection;
            iiWrapperList = new List<InspectionListWrapper>();
            //If investigation visit, CAP can be reviewed even when visit closed. BMMS-127
            if(inspectionRecord.Can_be_edited__c || inspectionRecord.Type_of_Visit__c == 'Investigation'){
                //String filterWhere = '';
                /*if(String.isNotBlank(selectedResultFilter)){
                    filterWhere = ' and Inspection_Result__c = null';
                }*/
                
                /*if(String.isNotBlank(selectedCategoryFilter)){
                    if(selectedCategoryFilter == 'NS'){
                        filterWhere = filterWhere + ' and Category_list__c = null';
                    }else{
                        filterWhere = filterWhere+ ' and Category_list__c = \''+selectedCategoryFilter+'\'';
                    }
                    
                }*/
                
                //System.debug('****selectedResultFilter - '+selectedResultFilter+' *****selectedCategoryFilter - '+selectedCategoryFilter);
                //System.debug('****filterWhere - '+filterWhere);
                
                String iiQuery = 'SELECT Id, name, RecordType.Name,Associated_regulation__c,Associated_regulation__r.name,Associated_regulation__r.article__c,Category_list__c,'+
                                 'Inspection_Item_Name__c,Additional_Inspection_Item_Name__c,Standard_Inspection_Item__c,Description_of_inspection__c,Inspection_Result__c,'+
                                 'Discussed__c, Observations__c,Correction_Plan_Status__c,Technical_assistance__c,Correction_Plan__c, Corrective_Actions_Submitter__c,Date_Implemented__c,Corrective_Action_EEC_Feedback__c  from Inspection_Item__c where Inspection_No__c = \''+inspectionRecord.Id +'\' and Inspection_Result__c = \'Non-Compliant\' order by '+sortFullExp;
                List<Inspection_Item__c> iiList = Database.query(iiQuery);
                Set<Id> siSet = new Set<Id>();
                if(iiList != null && iiList.size() > 0){
                    
                    for(Inspection_Item__c ii : iiList){
                        itemid.add(ii.id);
                        if(ii.RecordType.Name == 'Standard Visit Item'){
                            siSet.add(ii.Standard_Inspection_Item__c);
                        }
                    }
                    
                    Map<Id,Map<String,Id>> iregulationMap = new Map<Id,Map<String,String>>();
                    Map<String,String> jiMap;
                    for(Junction_InspReg__c jir : [select Id,Regulation__c,Regulation__r.name, Regulation__r.article__c,Standard_Inspection_Item__c from Junction_InspReg__c where Standard_Inspection_Item__c in :siSet]){
                        if(iregulationMap.containsKey(jir.Standard_Inspection_Item__c)){
                            iregulationMap.get(jir.Standard_Inspection_Item__c).put(jir.Regulation__r.name+',', jir.Regulation__c);
                        }
                        else{
                            jiMap = new Map<String,String>();
                            jiMap.put(jir.Regulation__r.name+',', jir.Regulation__c);
                            iregulationMap.put(jir.Standard_Inspection_Item__c,jiMap);
                        }
                    }
                    Integer rowIndex = 0;
                    for(Inspection_Item__c ii : iiList){
                        /*if(ii.Inspection_Result__c == null || ii.Inspection_Result__c == ''){
                            numberItemsNonSelected = numberItemsNonSelected + 1;
                        }*/
                        iiWrapperList.add(new InspectionListWrapper(rowIndex,ii,iregulationMap));
                        rowIndex = rowIndex + 1;
                    }
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This view is not available as there is no non-compliant item associated to this visit.'));
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director.'));
            }
            return null;
        }
        
        public PageReference Save(){
            saveInspectionItems();
            return null;
        }
        
        public PageReference SaveAndCloseVisitMode(){
            saveInspectionItems();
            return (new PageReference('/'+inspectionRecord.Id));
        }
        
        
        private void saveInspectionItems(){
            List<Inspection_Item__c> updateiiList = new List<Inspection_Item__c>();
            List<Inspection_Item__c> deleteiiList = new List<Inspection_Item__c>();
            //numberItemsNonSelected = 0;
            if(iiWrapperList != null){
                Inspection_Item__c iItem;
                for(InspectionListWrapper ilw : iiWrapperList){
                    iItem = new Inspection_Item__c();
                    if(ilw.isDeleted){
                        iItem.Id = ilw.Id;
                        deleteiiList.add(iItem);
                    }
                    else{
                        iItem.Id = ilw.Id;
                        //iItem.Inspection_Result__c = ilw.result;
                        //iItem.Discussed__c = ilw.discussion;
                        //iItem.Technical_Assistance__c = ilw.techAssistance;
                        iItem.observations__c = ilw.observations;
                        iItem.correction_plan__c = ilw.correctionPlan;
                        iItem.Date_Implemented__c = ilw.inspItem.Date_Implemented__c;
                        if((String.isBlank(ilw.correctionPlan) || String.isBlank(ilw.submitter)) 
                                && String.isNotBlank(ilw.feedback)){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Feedback can only be provided if Correction Plan is submitted'));
                            return;  
                        }
                        if(ilw.selectTOAccept){
                            iItem.Correction_Plan_Status__c = 'EEC Accepted';
                        }
                        iItem.Corrective_Action_EEC_Feedback__c = ilw.feedback;
                        updateiiList.add(iItem);
                    }
                    
                }
                
                System.debug('******Deleting Inspected Items --- '+deleteiiList);
                System.debug('******Updating Inspected Items --- '+updateiiList);
                if(deleteiiList.size() > 0){
                    delete deleteiiList;
                }
                if(updateiiList.size() > 0){
                    try{
                      update updateiiList;
                    } catch (Exception e){
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() ));
                        return;
                    }
                }
                getInspectionItemData();
            }
        }
        
        /*public PageReference SaveAndAddNewVisitItem(){
            saveInspectionItems();
            PageReference returnURL;
            //returnURL = new PageReference('/a05/e');
            //returnURL.getParameters().put('ent', '01Ij000000103LX');
            returnURL = new PageReference('/setup/ui/recordtypeselect.jsp');
            returnURL.getParameters().put('ent', '01Ij000000103LX');
            //returnURL.getParameters().put('cancelURL', '/apex/InspectVisitMode?id='+inspectionRecord.Id);
            //returnURL.getParameters().put('retURL', '/apex/InspectVisitMode?id='+inspectionRecord.Id);
            //returnURL.getParameters().put('retURL', '/a05/e');
            returnURL.getParameters().put('CF00Nj0000006QWNK',inspectionRecord.name);
            returnURL.getParameters().put('save_new_url', '/a05/e?retURL=apex/InspectVisitMode?id='+inspectionRecord.Id+'&saveURL=apex/InspectVisitMode?id='+inspectionRecord.Id);
            //returnURL.getParameters().put('save_new_url', '/apex/InspectVisitMode?id='+inspectionRecord.Id);
            
            return returnURL;
        }
        
        public PageReference MarkCompliant(){
            
            for(InspectionListWrapper iiw : iiWrapperList){
                if(iiw.result == null || iiw.result == ''){
                    iiw.result = 'Compliant';
                }
            }
            
            return null;
        }
        
        public PageReference DeleteInspectionItem(){
            String deleteIndex = ApexPages.currentPage().getParameters().get('deleteIndex');
            String deleteId = ApexPages.currentPage().getParameters().get('deleteId');
            if(String.isNotBlank('deleteIndex')){
                InspectionListWrapper ilw = iiWrapperList.get(Integer.valueOf(deleteIndex));
                ilw.isDeleted = true;
            }
            return null;
        }*/
        /*public void acceptStatus(){
            string inspId = apexPages.currentPage.getParameters.get('EECAccep');
            
        }*/
        public void bulkSelect(){
            for(InspectionListWrapper ilw : iiWrapperList){
                if(ilw.selectToAcceptRendered){
                    ilw.selectTOAccept = true;
                }
            }
            
        }
        
        
        public class InspectionListWrapper{
            
            public Id Id {get;set;}
            public String name {get;set;}
            public Integer rowIndex { get; set; }
            public String Type {get; private set;}
            public Map<String,Id> regulationMap {get; set;}
            public String iCategory {get;set;}
            public String itemName {get;set;}
            public String itemid{get;set;}
            public String description {get;set;}
            public String result {get;set;}
            public Boolean discussion {get;set;}
            public String techAssistance {get;set;}
            public String observations {get;set;}
            public String correctionPlan {get;set;}
            public String status{get;set;}
            public Boolean selectToAccept{get;set;}
            public Boolean selectToAcceptRendered{get;set;}
            public String submitter {get; set;}
            public Inspection_Item__c inspItem {get;set;}
            public Boolean isDeleted {get;set;}
            public String feedback {get; set;}
            
            
            public InspectionListWrapper(Integer rowIndex, Inspection_Item__c insp,Map<Id, Map<String,String>> iRegMap) {
                this.Id = insp.Id;
                this.name = insp.name;
                this.rowIndex = rowIndex;
                this.Type = insp.RecordType.Name;
                this.regulationMap = null;
                this.status = insp.Correction_Plan_Status__c;
                this.selectToAccept =false;
                this.selectToAcceptRendered = false;
                if(this.status== 'Provider Submitted, EEC to Review'){
                    this.selectToAcceptRendered = true;
                }
                if(this.Type == 'Standard Visit Item' && insp.Standard_Inspection_Item__c != null){
                    this.regulationMap = iRegMap.get(insp.Standard_Inspection_Item__c);
                    this.itemName = insp.Inspection_Item_Name__c;
                    this.itemid = insp.Id;
                }
                else{
                    this.itemName = insp.Additional_Inspection_Item_Name__c;
                    this.regulationMap = new Map<String,Id>();
                    if(insp.Associated_regulation__c != null){
                        this.regulationMap.put(insp.Associated_regulation__r.name,insp.Associated_regulation__c);
                    }
                }
                System.debug('********regulationMap-- '+this.regulationMap);
                this.iCategory = insp.Category_list__c;
                this.description = insp.Description_of_inspection__c;
                this.result = insp.Inspection_Result__c;
                this.discussion = insp.Discussed__c;
                this.techAssistance = insp.technical_assistance__c;
                this.observations = insp.observations__c;
                this.correctionPlan = insp.correction_plan__c;
                this.submitter = insp.Corrective_Actions_Submitter__c;
                this.feedback = insp.Corrective_Action_EEC_Feedback__c;
                this.inspItem = insp;
                this.isDeleted = false;
            }
            
         }
        
    }