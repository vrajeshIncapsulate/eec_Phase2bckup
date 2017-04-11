public with sharing class EEC_RegulationViewController {
    
    public List<Regulation__c> childregs{get;set;}
    public Regulation__c regulation {get;set;}
    public ID regId {get;set;}
    //public ID insId {get;set;}
    public EEC_RegulationViewController(){       
       regId = ApexPages.currentPage().getParameters().get('id');
       //insId = ApexPages.currentPage().getParameters().get('inId');
       if(String.isNotBlank(regId)){
             regulation = [select Id,Name,Parent_Regulation__r.Name,Applicable_To__c,article__c from Regulation__c where Id = :regId];
             if (regulation != null ) 
             	getchildregs();
       }
       
    }
    
    public void getchildregs(){
    
       childregs = [select id,Name,Article__c from Regulation__c where Parent_Regulation__c = :regId];
          
    
    }
}