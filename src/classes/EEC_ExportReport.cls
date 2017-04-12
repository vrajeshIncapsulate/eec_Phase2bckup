public class EEC_ExportReport {
    public string fileName {get;set;}
	public String getReportData() {
        fileName = 'test.csv';
        Id reportId = (Id)ApexPages.currentPage().getParameters().get('id');
        String pv0 = ApexPages.currentPage().getParameters().get('pv0');
        if(reportId != null && reportId.getSobjectType() == Report.SobjectType) {
            PageReference ref = new PageReference('/'+reportId + '?pv0='+ pv0 + '&csv=1');
            return ref.getContent().toString();
        }
        return null;
    }

}