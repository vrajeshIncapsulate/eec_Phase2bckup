public class EEC_ComplaintsIntroController extends EEC_BaseComplaintsController { 
 
    public PageReference reportAComplaint() {
        return redirectWithId(Page.EEC_ComplaintsProviderInfo);
    }
 
    public override Boolean requireComplaint() {
        return false;
    }
}