public class EEC_NavBarController {
    
  public Account acc;
    
  public Account getAcc() {
    try {  
    acc = [SELECT Id, Name, Recordtype.Name, OwnerId FROM Account 
                   WHERE ID in (SELECT AccountId FROM USER WHERE id = :Userinfo.getUserId()) LIMIT 1];
      return acc; 
    }    
    catch(Exception e) {
      return acc;  
    }
  }  
    
  public String getLicensorEmail() {
    try {
      System.debug('----> Account: ' + acc);
      if (acc != null) {
        return processAccount(acc);   
      }
      
      acc = getAcc();
      return processAccount(acc);   
    } catch(Exception e) {
      return '';  
    }
  }
    
  private String processAccount(Account acc) {
    if (acc <> null ){       
      if (acc.Recordtype.Name.contains('Umbrella')){
        return 'commissioners.office@state.ms.us';
      }else{
        User licensor = [Select Id, Name, Email From User Where Id = :acc.OwnerId Limit 1];     
        return licensor.Email;
      }
    }
    return '';
  }

}