public with sharing class EEC_GeneratePDFNCController {
    
    //private ApexPages.StandardController controller;
    public Inspection__c inspection {get;set;}
    public List<InspectionListWrapper> iiWrapperList {get;set;}
    public Id inspectionId {get;set;}
    
    
    public EEC_GeneratePDFNCController(){
        inspectionId = ApexPages.currentPage().getParameters().get('id');
        generateData();
    }

    public void generateData(){
        iiWrapperList = new List<InspectionListWrapper>();
        
        System.debug('********-- '+inspectionId);
        inspection = [SELECT Id,name,Date_of_Visit__c,Provider_No__c,Provider_No__r.name,Provider_No__r.Provider_Number__c,Provider_No__r.Provider_no__c,Provider_No__r.BillingStreet, 
                             Provider_No__r.BillingState,Provider_No__r.BillingPostalCode, Provider_No__r.BillingCountry, Provider_No__r.BillingCity,
                             Provider_No__r.Phone, Provider_No__r.Umbrella_Members__r.name, Provider_No__r.Umbrella_Members__r.Provider_no__c, Provider_No__r.Umbrella_Members__r.Current_License_Number__c,
                      		 Provider_No__r.Umbrella_Members__r.Use_Legacy_Prov_Number__c,Provider_No__r.Umbrella_Members__r.Provider_Number__c,
                             Address_1__c , Address_2__c, City__c, State__c, Zip_Code__c, Provider_No__r.Provider_Address_1__c, Provider_No__r.Provider_Address_2__c, Provider_No__r.Provider_City__r.Name,
                             Provider_No__r.State__c, Provider_No__r.Provider_Zip_Code__c,
                             Provider_No__r.Umbrella_Members__r.Phone,Provider_No__r.Umbrella_Members__r.BillingStreet, Provider_No__r.Umbrella_Members__r.BillingState, 
                             Provider_No__r.Umbrella_Members__r.BillingPostalCode, Provider_No__r.Umbrella_Members__r.BillingCountry, Provider_No__r.Umbrella_Members__r.BillingCity,
                             Provider_No__r.Owner.Name,Provider_No__r.Owner.Title, Provider_No__r.Current_License_Number__c,Provider_No__r.Use_Legacy_Prov_Number__c from Inspection__c where Id = :inspectionId];
        System.debug('********--****'+inspection);
        List<Inspection_Item__c> iiList = [select Id, name,RecordType.Name,Observations__c,Correction_Plan__c,Visit_Mode_Ranking__c,Date_Implemented__c,Standard_Inspection_Item__c,Associated_regulation__c,
                                                  Associated_regulation__r.name,Inspection_Result__c
                                           from Inspection_Item__c where Inspection_No__c = :inspection.Id and Inspection_Result__c = 'Non-Compliant' order by Visit_Mode_Ranking__c asc nulls last];
        
        Set<Id> siSet = new Set<Id>();
        if(iiList != null && iiList.size() > 0){
            for(Inspection_Item__c ii : iiList){
                if(ii.RecordType.Name == 'Standard Visit Item'){
                    siSet.add(ii.Standard_Inspection_Item__c);
                }
            }
            
            Map<Id,List<String>> iregulationMap = new Map<Id,List<String>>();
            List<String> jiList;
            for(Junction_InspReg__c jir : [select Id,Regulation__c,Regulation__r.name, Regulation__r.article__c,Standard_Inspection_Item__c from Junction_InspReg__c where Standard_Inspection_Item__c in :siSet]){
                if(iregulationMap.containsKey(jir.Standard_Inspection_Item__c)){
                    iregulationMap.get(jir.Standard_Inspection_Item__c).add(', ' + jir.Regulation__r.name);
                }
                else{
                    jiList = new List<String>();
                    jiList.add(jir.Regulation__r.name);
                    iregulationMap.put(jir.Standard_Inspection_Item__c,jiList);
                }
            }
            Boolean showII = false;
            
            for(Inspection_Item__c ii : iiList){
                System.debug('*****Record Type*** '+ii.RecordType.Name + ' **** '+ii.Standard_Inspection_Item__c + ' ** '+ii.Associated_regulation__c);
                showII = false;
                if(ii.RecordType.Name == 'Standard Visit Item' && String.isNotBlank(ii.Standard_Inspection_Item__c) && iregulationMap.get(ii.Standard_Inspection_Item__c) != null){
                    showII = true;
                }
                else if(ii.RecordType.Name == 'Additional Inspection Item' && String.isNotBlank(ii.Associated_regulation__c)){
                    showII = true;
                }
                
                if(showII || String.isNotBlank(ii.observations__c) || String.isNotBlank(ii.Correction_Plan__c) || ii.Date_Implemented__c != null){
                    iiWrapperList.add(new InspectionListWrapper(ii,iregulationMap));
                }
            }
        }
        
    }
    
    public class InspectionListWrapper{
        
        public Id Id {get;set;}
        public String name {get;set;}
        public String Type {get; private set;}
        public List<String> regulationList {get; set;}
        public String result {get;set;}
        public String observations {get;set;}
        public String correctionPlan {get;set;}
        public Date dateImplemented {get;set;}
        public Boolean showII {get;set;}
        
        public InspectionListWrapper(Inspection_Item__c insp,Map<Id, List<String>> iRegMap) {
            this.Id = insp.Id;
            this.name = insp.name;
            this.Type = insp.RecordType.Name;
            this.regulationList = null;
            
            if(this.Type == 'Standard Visit Item' && insp.Standard_Inspection_Item__c != null){
                this.regulationList = iRegMap.get(insp.Standard_Inspection_Item__c);
                this.showII = true;
            }
            else{
                this.regulationList = new List<String>();
                if(insp.Associated_regulation__c != null){
                    this.regulationList.add(insp.Associated_regulation__r.name);
                    this.showII = true;
                }
            }
            
            this.result = insp.Inspection_Result__c;
            this.observations = insp.observations__c;
            this.correctionPlan = insp.Correction_Plan__c;
            this.dateImplemented = insp.Date_Implemented__c;
         }
        
     }
    
    
    /*public pagereference GeneratePDF(){
        
        PageReference pagePdf = new PageReference('/apex/AttachPDFTerryTest');
          pagePdf.getParameters().put('id', idVal);
          pagePdf.getParameters().put('doSave', 'No');
          Blob pdfPageBlob;
          pdfPageBlob = pagePdf.getContentAsPDF();
                 
          Attachment a = new Attachment();
          a.Body = pdfPageBlob;
          a.ParentID = idVal;
          a.Name = 'TerryTestAttach1.pdf';
          a.Description = 'TestDescription1';
          insert a;
      return new PageReference('/' + idVal);
      
      
        Attachment att = new Attachment(name ='NonCompliant-'+inspection.name+'.pdf');
        PageReference invoicePage = Page.EEC_GeneratePDFNC;
        att.OwnerId = UserInfo.getUserId();
        att.body = invoicePage.getContent();
        //System.debug('***** '+invoicePage.getContent());
        att.parentid = inspection.id;
        //insert att;
        
        return new PageReference('/'+inspection.Id);
    }*/
}