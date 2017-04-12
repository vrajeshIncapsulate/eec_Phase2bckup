public without sharing abstract class EEC_BaseComplaintsController {
 
    private String GLOBAL_CONFIG_NAME = 'Global';
    private Set<String> INVALID_PROVIDER_TYPES = new Set<String>{ 'Umbrella', 'Unlicensed Provider', 'FCC Assistant' };
    public EEC_Complaint complaint { get; set; }

    public EEC_BaseComplaintsController() { 
        complaint = EEC_Complaint.fromCase(ApexPages.currentPage().getParameters().get('id'));
    } 
    public List<EEC_Question> getQuestions() {
        return EEC_QuestionService.unlicensedComplaintQuestions;
    }

    public LEAD_Configuration__c conf = [
        SELECT 
            Complaints_Introduction__c, Complaint_Form_Redirect__c, Complaints_Confirmation__c 
        FROM 
            LEAD_Configuration__c 
        WHERE 
            Name = :GLOBAL_CONFIG_NAME
    ];
 

    public Date getOneMonthAgo() {
        return Date.today().addMonths(-1);
    }

    public LEAD_Configuration__c getConf() {
        return conf;
    }

    public PageReference noComplaintRedirect() {
        if(ApexPages.currentPage().getParameters().get('id') == NULL && requireComplaint()) {
            return redirectTo(Page.EEC_ComplaintsProviderInfo);
        }
        
        return NULL;
    }

    public virtual Boolean requireComplaint() {
        return true;
    }

    public PageReference back() {
        if(complaint.Id != NULL) {
            upsertComplaint();
        }
        
        return redirectWithId(backPage());
    }
    
    public virtual PageReference backPage() {
        return Page.EEC_ComplaintsIntro;
    }
    
    public PageReference cancel() {
        if(complaint.Id != null) {
            delete complaint.toCase();
        }
        
        return homeRedirect();
    }
    
    public PageReference homeRedirect() { 
        return new PageReference(conf.Complaint_Form_Redirect__c);
    }

    protected void upsertComplaint() {
        Case c = complaint.toCase();
        upsert c;
        complaint = EEC_Complaint.fromCase(c.Id);
    }

    protected PageReference redirectWithId(PageReference pr) {  
        pr.getParameters().put('id', complaint.Id);
        return redirectTo(pr);
    } 

    protected PageReference redirectTo(PageReference pr) {
        pr.setRedirect(true);
        return pr;
    }

}