//Author - Latha Davuluri
global class Batch_CleanRestraintReportTemp implements Database.Batchable<sObject>{
    global final String Query;
    global Batch_CleanRestraintReportTemp(String q){
        Query=q;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,List<RestraintReportTemp__c> scope){
        delete scope;
    }

    global void finish(Database.BatchableContext BC){}
    
}