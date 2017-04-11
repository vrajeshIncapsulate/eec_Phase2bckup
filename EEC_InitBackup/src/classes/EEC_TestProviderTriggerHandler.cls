@isTest
public with sharing class EEC_TestProviderTriggerHandler {

    @isTest static void testUpdateConfigRecordInsert(){
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        Lead_Configuration__c lc = EEC_TestUtil.mockLeadConfig(null, '');
        
        a = [SELECT Config_Record__r.Name, RecordType.Name FROM Account WHERE Id = :a.Id]; 
        User usr = EEC_TestUtil.mockUser();
        a.OwnerId = usr.Id;
        update a;
        
    }

    @isTest static void testUpdateConfigRecordUpdate(){
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        
        Lead_Configuration__c lc = EEC_TestUtil.mockLeadConfig('Group Care', '');
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName='Group_Care' AND sObjectType='Account'].Id;
        a.Restraint_Method__c = 'TCI';
        update a;
        a = [SELECT Config_Record__r.Name, RecordType.Name FROM Account WHERE Id = :a.Id]; 
        
        System.assertEquals(a.Config_Record__r.Name, lc.Name);
    }

    @isTest static void testUpdateConfigRecordUpdateUmbrella(){
        Account a = EEC_TestUtil.mockProvider(EEC_TestUtil.mockCity());
        
        Lead_Configuration__c lc = EEC_TestUtil.mockLeadConfig('Group Care', '');
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName='Umbrella' AND sObjectType='Account'].Id;
        
        a = [SELECT Config_Record__r.Name, RecordType.Name FROM Account WHERE Id = :a.Id]; 
        
        System.assertEquals(a.Config_Record__r, null);
    }
}