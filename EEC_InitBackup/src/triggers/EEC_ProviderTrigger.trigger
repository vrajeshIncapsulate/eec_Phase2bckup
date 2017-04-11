trigger EEC_ProviderTrigger on Account (before update, before insert) {
    
    EEC_ProviderTriggerHandler th = new EEC_ProviderTriggerHandler(Trigger.New, Trigger.isUpdate ? Trigger.oldMap : new Map<Id, Account>());
    th.updateConfigRecord();
    th.updateProviderRegion();
}