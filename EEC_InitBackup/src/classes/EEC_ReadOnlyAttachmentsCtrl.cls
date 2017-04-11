global class EEC_ReadOnlyAttachmentsCtrl {
  // General
  public AttachActionInterface aif { get; set; }
  public sObject obj { get; set; }
  public String fileToDelete { get; set; }
  public String generateFileId { get; set; }
  // Upload Variables.
  public String attachmentsJson { get; set; }
  public String bucketName { get; set; }
  public String bucketItemAccess { get; set; }
  public String accessKey { get; set; }

  private AWSKeys credentials { get; set; }
  private static final String AWSCredentialName = 'eec';

  public EEC_ReadOnlyAttachmentsCtrl() {
    credentials = new AWSKeys(AWSCredentialName);
    accessKey = credentials.key;
    bucketName = 'eec-lead-integration';
    bucketItemAccess = 'authenticated-read';
  }

  public PageReference deleteAttachment() {
    return aif.deleteAttachment(fileToDelete);
  }

  public String genetateS3Link() {
    return aif.genetateS3Link(generateFileId);
  }

  public void saveAttachmentsFromJson() {
    aif.saveAttachmentsFromJson(attachmentsJson, obj);
  }

  /**
     * generateMultiplePolicySignature
     * 
     * This function will call the S3ComponentCtrl to generate multiple or single policy and signature combos for specified files to upload to S3.
     * @author Darkis
     * @param String bucket The name of the bucket to save to.
     * @param String acl The permission level of the file. Typically this would be 'authenticated-read' for our purposes. 
     * @param String fileJson A JSON string of all the files to be uploaded from the Angular Controller.
     */
    @RemoteAction
    global static List<Map<String,String>> generateMultiplePolicySignature(String bucket, String acl, String fileJson) {
      List<Map<String,String>> returnJson = new List<Map<String,String>>();  
      List<EEC_S3ComponentCtrl.FileTypeJsonWrapper> fileTypeWrapperList = (List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>) JSON.deserialize(fileJson, List<EEC_S3ComponentCtrl.FileTypeJsonWrapper>.class);  
      // Loop through the files given and get all the necessary policy/sig combos.
      for (EEC_S3ComponentCtrl.FileTypeJsonWrapper wrapper : fileTypeWrapperList) {
        returnJson.add(EEC_S3ComponentCtrl.generatePolicySignature(bucket, acl, wrapper.filename, wrapper.type, null)); 
      }    
      return returnJson;
    }  
}