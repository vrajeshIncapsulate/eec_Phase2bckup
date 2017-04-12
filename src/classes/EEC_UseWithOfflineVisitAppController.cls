public class EEC_UseWithOfflineVisitAppController {
    
    private final Inspection__c inspectionRecord;
    public boolean useOnOfflineVisitMode {get;set;}
    public EEC_UseWithOfflineVisitAppController(ApexPages.StandardController controller){
        useOnOfflineVisitMode = false;
        this.inspectionRecord = (Inspection__c) controller.getRecord();
    }
    public void updateOfflineVisitLock(){
        if(!inspectionRecord.Offline_Lock__c){
            useOnOfflineVisitMode = true;
            inspectionRecord.Offline_Lock__c = true;
            upsert inspectionRecord;
        }
        //return null;
    }
}