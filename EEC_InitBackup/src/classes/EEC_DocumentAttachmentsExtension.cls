public class EEC_DocumentAttachmentsExtension extends BaseAttachmentsExtension implements AttachActionInterface {
    
  public EEC_DocumentAttachmentsExtension(ApexPages.StandardController std){   
    super(std);
  }
    
  /**
   * getCtrlInstance
   * 
   * This function will return an instance of this controller with interface reference.
   * @author Darkis
   * @return EEC_DocumentsAttachmentsExtension
   */
  public EEC_DocumentAttachmentsExtension getCtrlInstance() {
    return this;
  }
}