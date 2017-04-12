global class S3AngularSampleCtrl {
  
  public AWSKeys credentials {get;set;}
  public String portalUrl {get;set;}  
  public String fileUploaded {get;set;}
  public String key {get;set;}
  public String transactionNumber {get;set;}
    
  public String tempUrl {get;set;}
  public String formTarget {get;set;}
    
  // Variables that could be configed.
  public String bucketItemAccess {get;set;}
  public String bucketName {get;set;}
  private String AWSCredentialName = 'eec';
    
  public S3AngularSampleCtrl() {
    // Get current credentials and create an instance of the S3 component.                  
    AWSKeys credentials = new AWSKeys(AWSCredentialName);
    key = credentials.key;
    formTarget = '';
    transactionNumber = '';
      
    // Get the page url for form submit.
    String baseURL = URL.getSalesforceBaseUrl().toExternalForm(); // it will return: < https://cs14.salesforce.com >
    String PageURL = ApexPages.currentPage().getUrl();   // it will return: < /apex/myVFpage?id=906F00000008w9wIAA >
    portalUrl = baseURL + PageURL;
      
    bucketName = 'eec-lead';
    bucketItemAccess = 'authenticated-read';   

    if (ApexPages.currentPage().getParameters().get('target') != null) {
      formTarget = ApexPages.currentPage().getParameters().get('target');
    }
      
    if (ApexPages.currentPage().getParameters().get('ltId') != null) {
      transactionNumber = ApexPages.currentPage().getParameters().get('ltId');
    }
      
    if (ApexPages.currentPage().getParameters().get('key') != null) {
      System.debug('----> Filename Found.'); 
      fileUploaded = 'https://s3.amazonaws.com/eec-lead/' + ApexPages.currentPage().getParameters().get('key');
      tempUrl = EEC_S3ComponentCtrl.generateTempS3Url('eec-lead', ApexPages.currentPage().getParameters().get('key'));  
    }     
  }
  
  @RemoteAction
  global static Map<String, String> generatePolicySignature(String bucket, String acl, String filename, String type, String redirectUrl) {
    return EEC_S3ComponentCtrl.generatePolicySignature(bucket, acl, filename, type, redirectUrl);  
  }
    
  @RemoteAction
  global static List<Map<String,String>> generateMultiplePolicySignature(String bucket, String acl, String fileJson) {
    List<Map<String,String>> returnJson = new List<Map<String,String>>();  
    List<EEC_S3ComponentCtrl.FileTypeJsonWrapper> fileTypeWrapperList = (List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>) JSON.deserialize(fileJson, List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>.class);  
    
    for (EEC_S3ComponentCtrl.FileTypeJsonWrapper wrapper : fileTypeWrapperList) {
      returnJson.add(EEC_S3ComponentCtrl.generatePolicySignature(bucket, acl, wrapper.filename, wrapper.type, null)); 
    }  
    return returnJson;
  }  
    
  @RemoteAction
  global static String generateTempS3Url(String bucket, String filename) {
    return EEC_S3ComponentCtrl.generateTempS3Url(bucket, filename);      
  }
}