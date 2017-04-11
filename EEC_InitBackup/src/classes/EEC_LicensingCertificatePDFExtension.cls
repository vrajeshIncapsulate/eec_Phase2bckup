public class EEC_LicensingCertificatePDFExtension {
    
    protected final Licensing_Transaction__c trans;
    public Licensing_Transaction__c lt {get;set;}
    public List<Conditions_and_Limitations__c> lstConditions {get;set;}
    
    public EEC_LicensingCertificatePDFExtension(ApexPages.StandardController ctr){
        this.trans = (Licensing_Transaction__c) ctr.getRecord();
        getProviderConditions();
    }
	
    public List<Conditions_and_Limitations__c> getProviderConditions()
    {
        Licensing_Transaction__c lt = [SELECT Id,Capacity__c, Date_Closed__c FROM Licensing_Transaction__c
                                      WHERE Id =: trans.Id];
        lstConditions = [SELECT Conditions__c,Condition_Additional_Information__c,
                         Condition_Name__c,Condition_On_License__c,CreatedById,
                         CreatedDate,Current__c,Expiration_Date__c,Id,
                         Name,Provider__c,Source_Transaction__c,
                         Start_Date__c FROM Conditions_and_Limitations__c 
                         WHERE Provider__c =: trans.Provider__c 
                         AND 
                         (
                             (Start_Date__c <=: lt.Date_Closed__c AND Expiration_Date__c >=: lt.Date_Closed__c) 
                          OR 
                             (Expiration_Date__c = null AND Start_Date__c <=: lt.Date_Closed__c)
                         )];
        
        
        return lstConditions;
    }
}