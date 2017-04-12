/**
 * EEC_Util
 * 
 * This class is a place meant for all generic functions that will be shared accross the application.
 * @author Darkis
 * @testClass EEC_TestUtil
 */ 
public class EEC_Util {
    
  private static final Blob cryptoKey = Blob.valueOf('HZxE4kqHZg5RQbQA');

  public static String encryptGetParam(String param) {
    return EncodingUtil.urlEncode(EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES128', EEC_Util.cryptoKey, Blob.valueOf(param))),'UTF-8');     
  }
    
 	public static String decryptGetParam(String param) {
         Blob paramBlob = EncodingUtil.base64Decode(param);
         return Crypto.decryptWithManagedIV('AES128', EEC_Util.cryptoKey, paramBlob).toString();
     }
  
	//Email notification when a Batch job processes
	public static void batchEmailSuccess(Database.BatchableContext apexJob, string apexJobName){
        
        string messageBody;
        string messageSubject;
        messageSubject = 'Apex Batch Job '+ apexJobName + ' is Complete';
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                     TotalJobItems, CreatedBy.Email
                                     from AsyncApexJob where Id =:apexJob.getJobId()];
            
        messageBody ='<html><body><h2>The batch apex job '+ apexJobName +' processed successfully.</h2><br/><br/>';
        messageBody = messageBody + 'Job Id:- '+ a.Id +'<br/>';
        messageBody = messageBody + 'No of Errors:- '+ a.NumberOfErrors +'<br/>';
        messageBody = messageBody + 'Job Items Processed:- '+ a.JobItemsProcessed + '<br/>';
        messageBody = messageBody + 'Total Job Items:- '+ a.TotalJobItems + '<br/></body></html>';
              
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
        String[] toAddresses = new String[]{a.CreatedBy.Email};

      
            if (toAddresses.size() > 0){
              mail.setToAddresses(toAddresses);
            }
        mail.setSubject(messageSubject);
        mail.setHtmlBody(messageBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});    
     } 
             


}