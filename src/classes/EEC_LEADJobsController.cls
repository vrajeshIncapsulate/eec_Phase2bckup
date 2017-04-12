public with sharing class EEC_LEADJobsController {
	
	 //Process LM 2010 Visit/ FCC Mobile Header Data
        public void processLegacyVisits() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyVisits(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Visits...Please wait... !!!'));
         }  
         
         //Process FCC Mobile Visit Item Data
        public void processLegacyVisitItems() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyVisitItems(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing Legacy Visit Items...Please wait... !!!'));
         } 
         
         
          //Process EECRs Non-Complaince Visits Data
        public void processLegacyNonComplianceVisits() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyNonCompVisits(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing EECRs Non-compliance Visits...Please wait... !!!'));
         } 
         
            //Process EECRs Non-Complaince Visit Items Data
        public void processLegacyNonComplianceVisitItems() {
            Database.executeBatch(new EEC_Batch_ProcessLegacyNonCompVisitItems(),1);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Processing EECRs Non-compliance visit items...Please wait... !!!'));
         } 
            //This is to clear all staging data if there are any issues with import and need to start over. Qamar
        public void clearAllStagingRecords() {
            List<EEC_HistoricalVisitSubItemStaging__c> hvList1 = [SELECT ID FROM EEC_HistoricalVisitSubItemStaging__c];
            delete hvList1;

            List<EEC_HistoricalVisitItemStaging__c> hvList2 = [SELECT ID FROM EEC_HistoricalVisitItemStaging__c];
            delete hvList2;

            List<EEC_HistoricalVisitStaging__c> hvList3 = [SELECT ID FROM EEC_HistoricalVisitStaging__c];
            delete hvList3;

            List<EEC_HistoryOfNonComplianceStaging__c> hvList4 = [SELECT ID FROM EEC_HistoryOfNonComplianceStaging__c];
            delete hvList4;
        } 

        public void deleteAllLegacyVisits() {
            List<Inspection__c> vList = [SELECT ID FROM Inspection__c WHERE RecordType.Name = 'Legacy System Import Visit / Non Compliance'];
            delete vList;
        } 

        public void deleteAllLegacyInvestigations() {
            List<Investigation__c> vList = [SELECT ID FROM Investigation__c WHERE isLegacyInvestigation__c = true];
            delete vList;
        } 

}