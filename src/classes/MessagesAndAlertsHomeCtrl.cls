public class MessagesAndAlertsHomeCtrl {
    
  public String alertMsg { get; set; }
  
  public MessagesAndAlertsHomeCtrl() {
    this.alertMsg = '';
    List<LEAD_Configuration__c> availableMsgConfigs = [Select Id, Messages_Alerts_Known_Issues__c, RecordType.Name, CreatedDate From LEAD_Configuration__c Where RecordType.Name = 'Messages and Alerts' Order By CreatedDate DESC];  
    
    if (availableMsgConfigs.size() > 0) {
      this.alertMsg = availableMsgConfigs.get(0).Messages_Alerts_Known_Issues__c;            
    }  
  }
}