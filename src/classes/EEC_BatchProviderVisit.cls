global class EEC_BatchProviderVisit implements Database.Batchable <sObject>{
    String pQuery = '';
    global EEC_BatchProviderVisit(String query)
    {
        this.pQuery =  query;
    }
    global EEC_BatchProviderVisit()
    {
        //Updated query to filter results to only those where need_a_licensing_visit__c field has a value. Qamar Islam
        this.pQuery =  'SELECT Id,Is_Residential__c,Is_R_P__c,Is_GSA__c,Provider_Address_1__c,Provider_Address_2__c,Provider_Zip_Code__c,Config_Record__c,Config_Record__r.Lic_Anniversary_Visit_Estimated_Deadline__c,Config_Record__r.Nb_Days_Prior_to_Lic_Anniv_to_Create_Vis__c,Provider_City__r.Name,Need_a_licensing_visit__c,License_Status__c,Renewal_date__c,OwnerId,Provider_Status__c FROM Account WHERE Need_a_licensing_visit__c <> null';
    }
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(pQuery);
    }
    global void execute(Database.BatchableContext BC, List <Account> providerList)
    {
        
        List<Inspection__c> providerVisit = new List<Inspection__c>();
        for(Account provider : providerList){
            System.debug('----------> Provider: ' + provider);
            Integer vis = [SELECT Count() FROM Inspection__c WHERE Count_Visit_For_Visit_Creation_Batch__c = true AND Provider_No__c =: provider.Id];
           	//System.debug('Visit Count----->' + vis);
            if(provider.Need_a_licensing_visit__c != null && vis < 1)
            {
                Inspection__c insp = new Inspection__c();
                if(provider.Is_R_P__c){
                    if(provider.Need_a_licensing_visit__c == 'Monitoring')
                        insp.Announcement_Type__c = 'Semi-Announced';
                    else
                        insp.Announcement_Type__c = 'Unannounced';
                    if(provider.Is_Residential__c){
                        insp.RecordTypeId = Schema.SObjectType.Inspection__c.getRecordTypeInfosByName().get('Residential Licensing Visit').getRecordTypeId();
                    }
                    else{
                        insp.RecordTypeId = Schema.SObjectType.Inspection__c.getRecordTypeInfosByName().get('Placement Licensing Visit').getRecordTypeId();
                    }
                }
                else{
                    insp.Announcement_Type__c = 'Unannounced';
                    if(provider.Is_GSA__c)
                        insp.RecordTypeId = Schema.SObjectType.Inspection__c.getRecordTypeInfosByName().get('GSA Licensing Visit').getRecordTypeId();
                    else
                        insp.RecordTypeId = Schema.SObjectType.Inspection__c.getRecordTypeInfosByName().get('FCC Licensing Visit').getRecordTypeId();
                }
                insp.Inspector_del__c = provider.OwnerId; 
                insp.Provider_No__c = provider.Id;
                insp.Address_1__c = provider.Provider_Address_1__c;
                insp.Address_2__c = provider.Provider_Address_2__c;
                insp.City__c = provider.Provider_City__r.Name;
                insp.Zip_Code__c = provider.Provider_Zip_Code__c;
                insp.Status__c = 'To be scheduled';
                insp.Visit_Created_By_Batch__c = true;
                insp.Licensing_Transaction__c = null;
                insp.Type_of_Visit__c = provider.Need_a_licensing_visit__c;
                if(provider.Need_a_licensing_visit__c.containsIgnoreCase('Renewal') ){
                    insp.Estimated_Deadline__c = provider.Renewal_date__c;
                } else {
                    Date pDate = Date.today();
                    insp.Estimated_Deadline__c = pDate.addDays(Integer.valueOf(provider.Config_Record__r.Nb_Days_Prior_to_Lic_Anniv_to_Create_Vis__c + provider.Config_Record__r.Lic_Anniversary_Visit_Estimated_Deadline__c));
                }
                
                providerVisit.add(insp);    
            //}
          }
        }
        if(providerVisit <> null && providerVisit.size() > 0)
        	Database.insert(providerVisit);
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }


}