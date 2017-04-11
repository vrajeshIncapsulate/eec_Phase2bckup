public without sharing class EEC_ComplaintsProviderController extends EEC_BaseComplaintsController { 
      
    public Boolean showUnlicensed { get; set; }
    public Id selectedProvider { get; set; } 
    public List<EEC_Question> searchQuestions { get; set; }

    public List<Account> providers { get; set; }
    public EEC_ProviderSearchQueryBuilder providerSearch { get; set; }

    public EEC_ComplaintsProviderController() {  
        providerSearch = new EEC_ProviderSearchQueryBuilder();
        searchQuestions = EEC_QuestionService.providerSearchQuestions;
        showUnlicensed = complaint.Unlicensed_Provider_Name != NULL && complaint.AccountID == NULL;
        
        
        if(complaint.AccountId != NULL) {
            try {
                providers = Database.query(providerSearch.buildQuery(complaint.AccountId));
            } catch (Exception e) {
                System.debug('Account with ID ' + complaint.AccountId + ' could not be found');        
            }
        }
    }
 
    public override Boolean requireComplaint() {
        return false;
    }

    public PageReference unlicensedContinue() {
        complaint.AccountID = NULL;
        complaint.Origin = 'Web';
        try {
        	Case c = complaint.toCase();
            upsert c;
            PageReference pr = Page.EEC_ComplaintInformation;
            pr.getParameters().put('id', c.Id);
            return redirectTo(pr);
        }
        catch(DmlException e) {
            System.debug('Exception' + e.getMessage());
            return null;
		}
        //return redirectWithId(Page.EEC_ComplaintInformation);
    }

    public PageReference selectAndContinue() {  
        if (selectedProvider != NULL) {
            complaint.Unlicensed_Provider_Name = null;
            complaint.Unlicensed_Provider_Street = null;
            complaint.Unlicensed_Provider_City = null;
            complaint.Unlicensed_Provider_Zip_Code = null;
            complaint.Unlicensed_Provider_Phone = null;
            complaint.Unlicensed_Provider_Email = null;
            complaint.AccountId = selectedProvider;
            upsertComplaint();
            return redirectWithId(Page.EEC_ComplaintInformation);
        }

        return null;
    }

    public void search() {
        providers = new List<Account>();

        if(!providerSearch.hasFieldsSet()) {
            return;
        } 

        providers = Database.query(providerSearch.buildQuery()); 
        
        if(providers.size() > 0) {
            showUnlicensed = false;
        }
    }  
}