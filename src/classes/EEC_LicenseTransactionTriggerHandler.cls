public with sharing class EEC_LicenseTransactionTriggerHandler {
    public static boolean alreadyRan = false;
    List<Licensing_Transaction__c> newList;
    Map<Id,Licensing_Transaction__c> newMap;
    Map<Id,Household_Member__c> hhMAP;
    Map<Id,Account> providerMap;
    Map<String,ID> strHHMap;
    //Map<Id,ID> providerLTMap;
    Map<Id,Set<String>> ltHHMap;
    public EEC_LicenseTransactionTriggerHandler(List<Licensing_Transaction__c> newLTList){
        this.newList = newLTList;
    }
    
    public static boolean checkRecursive(){
        if(!alreadyRan){
            alreadyRan=true;
            return false;
        }else{
            return true;
        }
    }
    
    public void bulkAfter(){
        Set<Id> accountSet = new Set<Id>();
        Map<Id,Licensing_Transaction__c> newLTMap = new Map<Id,Licensing_Transaction__c>();
        newMap = new Map<Id,Licensing_Transaction__c>();
        ltHHMap = new Map<Id,Set<String>>();
        strHHMap = new Map<String, Id>();
        //providerLTMap = new Map<Id,Id>();
        
        for(Licensing_Transaction__c lt : newList){
            System.debug('*********** -- '+lt.Status__c);
            if(String.isNotBlank(lt.Status__c) && lt.Status__c == 'Submitted' && lt.RecordType.DeveloperName != 'FCC_Change_of_Name'){
                accountSet.add(lt.provider__c);
                newLTMap.put(lt.Id,lt);
            }
        }
        if(newLTMap != null && newLTMap.size() > 0){
            providerMap = new Map<Id,Account>([select Id, RecordType.DeveloperName from Account where Id in :accountSet]);
            newMap = new Map<Id,Licensing_Transaction__c>([select Id,RecordType.DeveloperName, Provider__c,(select Id,BRC_Required__c,First_Name__c,Last_Name__c,Date_of_Birth__c,Age_At_Submission__c,BRC_Consent_Status__c from Household_Member__r where Age_At_Submission__c >= 15) 
                                                           from Licensing_Transaction__c where Id in :newLTMap.KeySet()]);
            hhMAP = new Map<Id,Household_Member__c>([select Id,First_Name__c,Last_Name__c,Date_of_Birth__c,Provider__c,BRC_Consent_Status__c,Age_At_Submission__c from Household_Member__c where Provider__c = :accountSet 
                                                   and  Licensing_Transactions__c not in :newLTMap.KeySet()]);
            
            if(hhMAP != null){                                     
                for(Household_Member__c hh : hhMAP.Values()){
                    if(ltHHMap.containsKey(hh.Provider__c)){
                        ltHHMap.get(hh.Provider__c).add(hh.First_Name__c+'-'+hh.Last_Name__c+'-'+hh.Date_of_Birth__c);
                    }
                    else{
                        ltHHMap.put(hh.Provider__c,new Set<String>{hh.First_Name__c+'-'+hh.Last_Name__c+'-'+hh.Date_of_Birth__c});
                    }
                    strHHMap.put(hh.First_Name__c+'-'+hh.Last_Name__c+'-'+hh.Date_of_Birth__c,hh.Id);
                }
            }
            
            /*if(providerLTMap != null && providerLTMap.size() > 0){
                for(Household_Member__c hm :[select Id,Name,First_Name__c,First_Name__c,First_Name__c,BRC_Required__c,Licensing_Transactions__c from Household_Member__c where Licensing_Transactions__c in :providerLTMap.Values() and BRC_Required__c = true]){
                    if(ltHHMap.containsKey(hm.Licensing_Transactions__c)){
                        ltHHMap.get(hm.Licensing_Transactions__c).add(hm.First_Name__c+'-'+hm.Last_Name__c+'-'+hm.Date_of_Birth__c);
                    }
                    else{
                        ltHHMap.put(hm.Licensing_Transactions__c,new Set<String>{hm.First_Name__c+'-'+hm.Last_Name__c+'-'+hm.Date_of_Birth__c});
                    }
                }
            }*/
           
        }
        
    }
    
    public void updateHouseHoldMembers(){
        if(newMap != null && newMap.size() > 0){
            Account provider;
            Id tLTId;
            Set<String> tLTSet;
            List<Household_Member__c> hmList = new List<Household_Member__c>();
            String tStr = '';
            Boolean isBRCSet = false;
            
            for(Licensing_Transaction__c lt : newMap.values()){
                provider = providerMap.get(lt.Provider__c);
                if(provider.RecordType.DeveloperName == 'FCC'){
                    if((lt.RecordType.DeveloperName == 'FCC_New_License' || lt.RecordType.DeveloperName == 'FCC_Renewal')){
                        if(lt.Household_Member__r != null && lt.Household_Member__r.size() > 0){
                            for(Household_Member__c hm : lt.Household_Member__r){
                                hm.BRC_Required__c = true;
                                hmList.add(hm);
                            }
                        }
                    }
                    else if(lt.RecordType.DeveloperName == 'FCC_License_Upgrade' || lt.RecordType.DeveloperName == 'Change_of_Address'|| lt.RecordType.DeveloperName == 'FCC_Change_of_Household'){
                        Household_Member__c phm;
                        if(ltHHMap != null && ltHHMap.size()>0){
                            tLTSet = ltHHMap.get(lt.Provider__c);
                        }
                        for(Household_Member__c hm : lt.Household_Member__r){
                            isBRCSet = false;
                            if(tLTSet != null && tLTSet.size()>0){
                                tStr = hm.First_Name__c+'-'+hm.Last_Name__c+'-'+hm.Date_of_Birth__c;
                                Id hhId = strHHMap.get(tStr);
                                if(String.isNotBlank(hhId)){
                                    phm = hhMAP.get(hhId);
                                }
                                //System.debug('********** 3 -- '+ tLTSet + ' -- '+tStr + ' -- '+phm.Age_At_Submission__c + ' -- '+phm.BRC_Consent_Status__c);
                                if(tLTSet.contains(tStr) && phm != null && (/*phm.Age_At_Submission__c < 15 ||*/ (String.isNotBlank(phm.BRC_Consent_Status__c) && phm.BRC_Consent_Status__c == 'Completed'))){
                                    hm.BRC_Required__c = false;
                                    isBRCSet = true;
                                    hmList.add(hm);
                                }
                            }
                            if(!isBRCSet){
                                if(hm.Age_At_Submission__c >= 15 ){
                                    hm.BRC_Required__c = true;
                                    hmList.add(hm);
                                }
                            }
                        }
                    }
                }
            }
            System.debug('hmList' + hmList);
            if(hmList != null && hmList.size() > 0){
                update hmList;
            }
        }
    }
}