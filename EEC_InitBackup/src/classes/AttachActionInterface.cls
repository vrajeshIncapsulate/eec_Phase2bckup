public interface AttachActionInterface {
    PageReference deleteAttachment(String filename);
    String genetateS3Link(String fileId);
    void saveAttachmentsFromJson(String json, sObject obj);
    PageReference refreshAttachmentsList();
}