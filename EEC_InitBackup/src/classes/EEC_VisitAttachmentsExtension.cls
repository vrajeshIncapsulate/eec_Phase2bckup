public class EEC_VisitAttachmentsExtension extends BaseAttachmentsExtension implements AttachActionInterface {

  public Boolean restrictHeight { get; set; }
  public Boolean uploadOnly { get; set; }
    
  public EEC_VisitAttachmentsExtension(ApexPages.StandardController std) {
    super(std);

    this.restrictHeight = (ApexPages.currentpage().getparameters().get('restrictHeight') != null ? Boolean.valueOf(ApexPages.currentpage().getparameters().get('restrictHeight')) : true);
    this.uploadOnly = (ApexPages.currentpage().getparameters().get('uploadOnly') != null ? Boolean.valueOf(ApexPages.currentpage().getparameters().get('uploadOnly')) : false);
  }

  /**
   * getCtrlInstance
   * 
   * This function will return an instance of this controller with interface reference.
   * @author Darkis
   * @return EEC_VisitAttachmentsExtension
   */
  public EEC_VisitAttachmentsExtension getCtrlInstance() {
    return this;
  }
}