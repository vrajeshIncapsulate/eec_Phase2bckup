public abstract with sharing class BaseAttachmentsExtension {
  protected String id { get; set; }
  public List<S3_File__c> attachments { get; set; }
  public List<FileMap__c> attachmentsMapList { get; set; }
  public Map<Id, String> attachmentsMapUrls { get; set; }

  public BaseAttachmentsExtension(ApexPages.StandardController std) {
    try {
      // Create a new map with the urls.
      attachmentsMapUrls = new Map<Id, String> ();
      id = convertId(std.getId());
      System.debug('-----> Id: ' + id);
      // Get all the attachments.
      refreshAttachmentsList();
      attachmentsMapList = [Select Id, S3_File__r.Id, S3_File__r.Filename__c, S3_File__r.Bucket__c, S3_File__r.Content_Type__c, S3_File__r.Prefix__c From FileMap__c Where Object_Id__c = :id];

      for (FileMap__c fileMap : attachmentsMapList) {
        String filename = (!String.isBlank(fileMap.S3_File__r.Prefix__c) ? fileMap.S3_File__r.Prefix__c + '/' + fileMap.S3_File__r.Filename__c : fileMap.S3_File__r.Filename__c);
        String url = EEC_S3ComponentCtrl.generateTempS3Url(fileMap.S3_File__r.Bucket__c, filename);
        attachmentsMapUrls.put(fileMap.Id, url);
      }
    } catch(Exception e) {
      System.debug('----> Error: ' + e.getMessage());
    }
  }

  /**
   * refreshAttachmentsList
   * 
   * This function will collect all the attachments for the transaction and store them into a list for use on the attachment page.
   * @author Darkis 
   */
  public PageReference refreshAttachmentsList() {
    attachments = new List<S3_File__c> ();
    List<FileMap__c> fileMappings = [Select Id, S3_File__r.Id, S3_File__r.CreatedDate, S3_File__r.Filename__c, S3_File__r.Prefix__c, S3_File__r.Bucket__c From FileMap__c Where Object_Id__c = :id];
    System.debug('----> File Mappings: ' + fileMappings);
    if (fileMappings != null && fileMappings.size() > 0) {
      Set<Id> fileIds = new Set<Id> ();

      for (FileMap__c filemap : fileMappings) {
        fileIds.add(filemap.S3_File__r.Id);

        String filename = (!String.isBlank(fileMap.S3_File__r.Prefix__c) ? fileMap.S3_File__r.Prefix__c + '/' + fileMap.S3_File__r.Filename__c : fileMap.S3_File__r.Filename__c);
        String url = EEC_S3ComponentCtrl.generateTempS3Url(fileMap.S3_File__r.Bucket__c, filename);
        attachmentsMapUrls.put(fileMap.Id, url);
      }
      attachments = [Select Id, Bucket__c, Filename__c, CreatedDate From S3_File__c Where Id IN :fileIds];
      System.debug('----> All Files: ' + attachments);
      //return attachments;
    } else {
      //attachmentsJson = '';
    }
    return null;
  }

  /**
   * deleteAttachment
   * 
   * This function will delete the FileMap__c and S3_File__c record for a specified file along with trigger an async function to delete the file from S3.
   * @author Darkis
   * @param String fileToDelete The name of the file to delete from the UI.
   */
  public PageReference deleteAttachment(String fileToDelete) {
    // Delete the FileMap and S3_File Records.
    FileMap__c fileMap = [Select Id, S3_File__r.Filename__c From FileMap__c Where Object_Id__c = :id AND S3_File__r.Filename__c = :fileToDelete LIMIT 1];
    delete fileMap;
    // Delete the S3_File reference in Sforce.
    S3_File__c file = [Select Id, Bucket__c From S3_File__c Where Id = :fileMap.S3_File__c LIMIT 1];
    delete file;
    // Invoke the future method to delete the object in S3 using the SOAP API.
    deleteS3FileReference(file.Bucket__c, id + '/' + fileToDelete);
    // Re-map the mappings to remove the attachment.
    refreshAttachmentsList();
    return null;
  }

  /**
   * @future
   * deleteS3FileReference
   * 
   * This future function will do a SOAP callout to S3 to delete the file reference provided. 
   * @author Darkis
   * @param String bucketName The name of the bucket the file resides in.
   * @param String filename The name of the file along with any prefixs necessary.
   */
  @future(callout = true)
  public static void deleteS3FileReference(String bucketName, String filename) {
    // Delete the file from S3 using the SOAP API.  
    EEC_S3ComponentCtrl.deleteFile(bucketName, filename);
  }

  /**
   * generateS3Link
   * 
   * This function will accept a param and generate the necessary link for presenting the S3 file.
   * @author Darkis
   * @param String fileId The file ID that needs to be generated.
   */
  public String genetateS3Link(String fileId) {
    String filename = '';
    S3_File__c file = [Select Id, Filename__c, Prefix__c, Bucket__c From S3_File__c Where Id = :fileId];

    if (!String.isBlank(file.Prefix__c)) {
      filename += file.Prefix__c + '/';
    }
    filename += file.Filename__c;

    return EEC_S3ComponentCtrl.generateTempS3Url(file.Bucket__c, filename);
  }

  public String convertID(String id) {
    if (id.length() == 18) return id;

    String suffix = '';
    for (Integer i = 0; i < 3; i++) {
      Integer flags = 0;

      for (Integer j = 0; j < 5; j++) {
        String c = id.substring(i * 5 + j, i * 5 + j + 1);
        if (c.compareTo('A') >= 0 && c.compareTo('Z') <= 0) {
          flags += 1 < < j;
        }
      }

      if (flags <= 25) {
        suffix += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(flags, flags + 1);
      } else {
        suffix += '012345'.substring(flags - 26, flags - 26 + 1);
      }
    }

    return id + suffix;
  }

  /**
   * saveAttachmentsFromJson
   * 
   * This function will accept a json parameter of files decriptions to save to the transaction object.
   * @author Darkis
   */
  public void saveAttachmentsFromJson(String attachmentsJson, sObject obj) {
    try {
      // List of S3Objects. 
      if (!String.isBlank(attachmentsJson)) {
        // Convert the json into S3_Files.
        List<S3_File__c> s3FilesList = (List<S3_File__c>) JSON.deserialize(attachmentsJson, List<S3_File__c>.class);
        upsert s3FilesList;
        // Get all the current FileMap records for the object and ensure we don't create any duplicates.  
        Set<Id> fileMappingIds = (new Map<Id, FileMap__c> ([Select S3_File__c From FileMap__c Where Object_Id__c = :obj.Id])).keySet();
        List<FileMap__c> filesToMap = new List<FileMap__c> ();
        // Loop through all the files in the list and verify any that are new to be added. 
        for (S3_File__c file : s3FilesList) {
          if (!fileMappingIds.contains(file.Id)) {
            filesToMap.add(new FileMap__c(
                                          Object_Name__c = String.valueOf(obj.getSObjectType()),
                                          Object_Id__c = obj.Id,
                                          S3_File__c = file.Id
            ));
          }
        }
        // Insert the new files that need to be mapped.   
        insert filesToMap;
      }
    } catch(Exception e) {
      System.debug('-----> Error: ' + e.getMessage());
      ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error occurred ! Please contact your System Administrator - ' + e.getMessage());
      ApexPages.addMessage(errMsg);
    }
  }
}