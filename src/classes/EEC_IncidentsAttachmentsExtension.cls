public class EEC_IncidentsAttachmentsExtension extends BaseAttachmentsExtension implements AttachActionInterface {
    
  public EEC_IncidentsAttachmentsExtension(ApexPages.StandardController std){   
    super(std);
  }
    
  /**
   * getCtrlInstance
   * 
   * This function will return an instance of this controller with interface reference.
   * @author Darkis
   * @return EEC_IncidentsAttachmentsExtension
   */
  public EEC_IncidentsAttachmentsExtension getCtrlInstance() {
    return this;
  }
}