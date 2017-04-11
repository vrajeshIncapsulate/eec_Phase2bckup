public with sharing class EEC_RestraintReport {

  public List<Restraint_Report__c> restraintReport { get; private set; }
  public boolean isNew { get; private set; }
  public Restraint_Report__c rReport { get; private set; }
  public Account account { get; set; }
  public Contact contact { get; set; }
  String accountId { get; private set; }
  public String reportID { get; private set; }
  public Integer count { get; set; }
  public String actionResult { get; private set; }
  public String restraintAccountID { get; set; }
  public String memberId { get; set; }

  Public String Calendar_Year { get; set; }
  Public String Contact_Submitted_By { get; set; }
  Public String CreatedById { get; set; }
  Public Integer Floor_Both_Prone_and_Supine_0_5 { get; set; }
  Public Integer Floor_Both_Prone_and_Supine_6_10 { get; set; }
  Public Integer Floor_Both_Prone_and_Supine_11_20 { get; set; }
  Public Integer Floor_Both_Prone_and_Supine_21_30 { get; set; }
  Public Integer Floor_Both_Prone_and_Supine_31_40 { get; set; }
  Public Integer Floor_Both_Prone_and_Supine_41_50 { get; set; }
  Public Integer Floor_Both_Prone_and_Supine_51_60 { get; set; }
  Public Integer Floor_Both_Prone_and_Supine_60 { get; set; }
  Public Integer Floor_Prone_0_5 { get; set; }
  Public Integer Floor_Prone_6_10 { get; set; }
  Public Integer Floor_Prone_11_20 { get; set; }
  Public Integer Floor_Prone_21_30 { get; set; }
  Public Integer Floor_Prone_31_40 { get; set; }
  Public Integer Floor_Prone_41_50 { get; set; }
  Public Integer Floor_Prone_51_60 { get; set; }
  Public Integer Floor_Prone_60 { get; set; }
  Public Integer Floor_Supine_0_5 { get; set; }
  Public Integer Floor_Supine_6_10 { get; set; }
  Public Integer Floor_Supine_11_20 { get; set; }
  Public Integer Floor_Supine_21_30 { get; set; }
  Public Integer Floor_Supine_31_40 { get; set; }
  Public Integer Floor_Supine_41_50 { get; set; }
  Public Integer Floor_Supine_51_60 { get; set; }
  Public Integer Floor_Supine_60 { get; set; }
  Public Integer Injured_Residents_Minor_Injury { get; set; }
  Public Integer Injured_Residents_Serious_Injury { get; set; }
  Public Integer Injured_Staff_Minor_Injury { get; set; }
  Public Integer Injured_Staff_Serious_Injury { get; set; }
  Public Integer No_Restraints_Leading_to_Res_Injury { get; set; }
  Public Integer No_Restraints_Leading_to_Staff_Injury { get; set; }
  Public Integer Physical_holds_Only_0_5 { get; set; }
  Public Integer Physical_Holds_Only_6_10 { get; set; }
  Public Integer Physical_Holds_Only_11_20 { get; set; }
  Public Integer Physical_Holds_Only_21_30 { get; set; }
  Public Integer Physical_Holds_Only_31_40 { get; set; }
  Public Integer Physical_Holds_Only_41_50 { get; set; }
  Public Integer Physical_Holds_Only_51_60 { get; set; }
  Public Integer Physical_Holds_Only_60 { get; set; }
  Public Integer Physical_Mechanical_0_5 { get; set; }
  Public Integer Physical_Mechanical_6_10 { get; set; }
  Public Integer Physical_Mechanical_11_20 { get; set; }
  Public Integer Physical_Mechanical_21_30 { get; set; }
  Public Integer Physical_Mechanical_31_40 { get; set; }
  Public Integer Physical_Mechanical_41_50 { get; set; }
  Public Integer Physical_Mechanical_51_60 { get; set; }
  Public Integer Physical_Mechanical_60 { get; set; }
  Public String Provider { get; set; }
  Public String Quarter { get; set; }
  Public Integer Sitting_0_5 { get; set; }
  Public Integer Sitting_6_10 { get; set; }
  Public Integer Sitting_11_20 { get; set; }
  Public Integer Sitting_21_30 { get; set; }
  Public Integer Sitting_31_40 { get; set; }
  Public Integer Sitting_41_50 { get; set; }
  Public Integer Sitting_51_60 { get; set; }
  Public Integer Sitting_60 { get; set; }
  Public Integer Standing_0_5 { get; set; }
  Public Integer Standing_6_10 { get; set; }
  Public Integer Standing_11_20 { get; set; }
  Public Integer Standing_21_30 { get; set; }
  Public Integer Standing_31_40 { get; set; }
  Public Integer Standing_41_50 { get; set; }
  Public Integer Standing_51_60 { get; set; }
  Public Integer Standing_60 { get; set; }
  Public Date Submitted_Date { get; set; }
  Public Integer Total_Bed_Days_Utilized_this_Quarter { get; set; }
  Public Integer Total_Injured { get; set; }
  Public Integer Unduplicated_Count_of_Residents_Served { get; set; }
  Public Integer Unduplicated_Count_of_Residents_Restraind { get; set; }

  public EEC_RestraintReport() {
    count = 0;
    memberId = ApexPages.currentPage().getParameters().get('member');
    if (String.isNotBlank(memberId)) {
      accountId = memberId;
    } else {
      List<Account> tempAccount = [Select Id From Account Where ID in(Select Accountid From User Where id = :Userinfo.getUserId()) Limit 1];
      if (tempAccount != null && tempAccount.size() == 1) {
        accountId = tempAccount.get(0).Id;
      }
    }

    if (accountId == null) {
      accountId = ApexPages.currentPage().getParameters().get('accountId');
    }
    reportID = ApexPages.currentPage().getParameters().get('Id');

    if (reportID != null) {
      account = [SELECT Id, Name, Restraint_Method__c, Record_Type_Name__c FROM Account WHERE Id = :accountId];
      getRestraintReportByID(reportID);
    } else {
      account = [SELECT Id, Name, Restraint_Method__c, Record_Type_Name__c FROM Account WHERE Id = :accountId];
      getRestraintReport(accountId);
    }
    System.debug('----> Account: ' + account);
  }

  public void getRestraintReport(String accountId) {
    try {
      restraintReport = [SELECT Id, Name, Calendar_Year__c, Quarter__c, Provider__c, CreatedDate, Contact_Submitted_By__r.Name, Restraint_Method2__c, Contact_Submitted_By__c, Submitted_Date__c
                         FROM Restraint_Report__c WHERE Provider__c = :accountId Order By CreatedDate desc];
    } catch(exception ex) {
      ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexcpected error');
      ApexPages.addMessage(errMsg);
    }
  }
  public void getRestraintReportByID(String reportId) {
    try {
      rReport = [SELECT Calendar_Year__c, Contact_Submitted_By__c, CreatedById, CreatedDate,
                 Floor_Both_Prone_and_Supine_0_5__c, Floor_Both_Prone_and_Supine_6_10__c, Floor_Both_Prone_and_Supine_11_20__c,
                 Floor_Both_Prone_and_Supine_21_30__c, Floor_Both_Prone_and_Supine_31_40__c, Floor_Both_Prone_and_Supine_41_50__c,
                 Floor_Both_Prone_and_Supine_51_60__c, Floor_Both_Prone_and_Supine_60__c, Floor_Prone_0_5__c, Floor_Prone_6_10__c,
                 Floor_Prone_11_20__c, Floor_Prone_21_30__c, Floor_Prone_31_40__c, Floor_Prone_41_50__c, Floor_Prone_51_60__c,
                 Floor_Prone_60__c, Floor_Supine_0_5__c, Floor_Supine_6_10__c, Floor_Supine_11_20__c, Floor_Supine_21_30__c,
                 Floor_Supine_31_40__c, Floor_Supine_41_50__c, Floor_Supine_51_60__c, Floor_Supine_60__c, Grand_Total__c, Id,
                 Injured_Residents_Minor_Injury__c, Injured_Residents_Serious_Injury__c, Injured_Staff_Minor_Injury__c,
                 Injured_Staff_Serious_Injury__c, IsDeleted, LastModifiedById, LastModifiedDate, Name,
                 No_Restraints_Leading_to_Res_Injury__c, No_Restraints_Leading_to_Staff_Injury__c, Physical_holds_Only_0_5__c,
                 Physical_Holds_Only_6_10__c, Physical_Holds_Only_11_20__c, Physical_Holds_Only_21_30__c, Physical_Holds_Only_31_40__c,
                 Physical_Holds_Only_41_50__c, Physical_Holds_Only_51_60__c, Physical_Holds_Only_60__c, Physical_Mechanical_0_5__c,
                 Physical_Mechanical_6_10__c, Physical_Mechanical_11_20__c, Physical_Mechanical_21_30__c, Physical_Mechanical_31_40__c,
                 Physical_Mechanical_41_50__c, Physical_Mechanical_51_60__c, Physical_Mechanical_60__c, Provider__c, Quarter__c,
                 RecordTypeId, Restraint_Method2__c, Sitting_0_5__c, Sitting_6_10__c, Sitting_11_20__c, Sitting_21_30__c,
                 Sitting_31_40__c, Sitting_41_50__c, Sitting_51_60__c, Sitting_60__c, Standing_0_5__c, Standing_6_10__c,
                 Standing_11_20__c, Standing_21_30__c, Standing_31_40__c, Standing_41_50__c, Standing_51_60__c, Standing_60__c,
                 Submitted_Date__c, SystemModstamp, Total_Bed_Days_Utilized_this_Quarter__c, Total_Injured__c,
                 Unduplicated_Count_of_Residents_Served__c, Unduplicated_Count_of_Residnts_Restraind__c, Contact_Submitted_By__r.Name
                 FROM Restraint_Report__c WHERE Id = :reportId limit 1];

    } catch(exception ex) {
      ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexcpected error');
      ApexPages.addMessage(errMsg);
    }
  }

  public PageReference save() {
    try {
      User user = [SELECT ContactId FROM User WHERE Id = :userinfo.getuserid()];
      List<RecordType> rTypes = [Select Id, Name, DeveloperName From RecordType Where SobjectType = 'Restraint_Report__c' and isActive = true];
      String accRestraintMethod = account.Restraint_Method__c;

      rReport = new Restraint_Report__c();
      rReport.Submitted_Date__c = Date.today();

      if (rTypes != null && rTypes.size() > 0) {
        for (RecordType rt : rTypes) {
          if (accRestraintMethod != '' && accRestraintMethod != null)	{
	          if (rt.Name.contains(accRestraintMethod)) {
	            rReport.RecordTypeId = rt.Id;
	          }
          }
        } //end for
        if (rReport.RecordTypeId == null) {
          rReport.RecordTypeId = [Select Id, Name, DeveloperName From RecordType Where SobjectType = 'Restraint_Report__c' And isActive = true And Name = 'Other Restraint'].Id;
        }
      }

      rReport.Provider__c = accountId;
      rReport.Quarter__c = Quarter;
      rReport.Calendar_Year__c = Calendar_Year;
      rReport.Contact_Submitted_By__c = user.ContactId;
      rReport.Floor_Both_Prone_and_Supine_0_5__c = Floor_Both_Prone_and_Supine_0_5;
      rReport.Floor_Both_Prone_and_Supine_6_10__c = Floor_Both_Prone_and_Supine_6_10;
      rReport.Floor_Both_Prone_and_Supine_11_20__c = Floor_Both_Prone_and_Supine_11_20;
      rReport.Floor_Both_Prone_and_Supine_21_30__c = Floor_Both_Prone_and_Supine_21_30;
      rReport.Floor_Both_Prone_and_Supine_31_40__c = Floor_Both_Prone_and_Supine_31_40;
      rReport.Floor_Both_Prone_and_Supine_41_50__c = Floor_Both_Prone_and_Supine_41_50;
      rReport.Floor_Both_Prone_and_Supine_51_60__c = Floor_Both_Prone_and_Supine_51_60;
      rReport.Floor_Both_Prone_and_Supine_60__c = Floor_Both_Prone_and_Supine_60;
      rReport.Floor_Prone_0_5__c = Floor_Prone_0_5;
      rReport.Floor_Prone_6_10__c = Floor_Prone_6_10;
      rReport.Floor_Prone_11_20__c = Floor_Prone_11_20;
      rReport.Floor_Prone_21_30__c = Floor_Prone_21_30;
      rReport.Floor_Prone_31_40__c = Floor_Prone_31_40;
      rReport.Floor_Prone_41_50__c = Floor_Prone_41_50;
      rReport.Floor_Prone_51_60__c = Floor_Prone_51_60;
      rReport.Floor_Prone_60__c = Floor_Prone_60;
      rReport.Floor_Supine_0_5__c = Floor_Supine_0_5;
      rReport.Floor_Supine_6_10__c = Floor_Supine_6_10;
      rReport.Floor_Supine_11_20__c = Floor_Supine_11_20;
      rReport.Floor_Supine_21_30__c = Floor_Supine_21_30;
      rReport.Floor_Supine_31_40__c = Floor_Supine_31_40;
      rReport.Floor_Supine_41_50__c = Floor_Supine_41_50;
      rReport.Floor_Supine_51_60__c = Floor_Supine_51_60;
      rReport.Floor_Supine_60__c = Floor_Supine_60;
      rReport.Injured_Residents_Minor_Injury__c = Injured_Residents_Minor_Injury;
      rReport.Injured_Residents_Serious_Injury__c = Injured_Residents_Serious_Injury;
      rReport.Injured_Staff_Minor_Injury__c = Injured_Staff_Minor_Injury;
      rReport.Injured_Staff_Serious_Injury__c = Injured_Staff_Serious_Injury;
      rReport.No_Restraints_Leading_to_Res_Injury__c = No_Restraints_Leading_to_Res_Injury;
      rReport.No_Restraints_Leading_to_Staff_Injury__c = No_Restraints_Leading_to_Staff_Injury;
      rReport.Physical_holds_Only_0_5__c = Physical_holds_Only_0_5;
      rReport.Physical_Holds_Only_6_10__c = Physical_Holds_Only_6_10;
      rReport.Physical_Holds_Only_11_20__c = Physical_Holds_Only_11_20;
      rReport.Physical_Holds_Only_21_30__c = Physical_Holds_Only_21_30;
      rReport.Physical_Holds_Only_31_40__c = Physical_Holds_Only_31_40;
      rReport.Physical_Holds_Only_41_50__c = Physical_Holds_Only_41_50;
      rReport.Physical_Holds_Only_51_60__c = Physical_Holds_Only_51_60;
      rReport.Physical_Holds_Only_60__c = Physical_Holds_Only_60;
      rReport.Physical_Mechanical_0_5__c = Physical_Mechanical_0_5;
      rReport.Physical_Mechanical_6_10__c = Physical_Mechanical_6_10;
      rReport.Physical_Mechanical_11_20__c = Physical_Mechanical_11_20;
      rReport.Physical_Mechanical_21_30__c = Physical_Mechanical_21_30;
      rReport.Physical_Mechanical_31_40__c = Physical_Mechanical_31_40;
      rReport.Physical_Mechanical_41_50__c = Physical_Mechanical_41_50;
      rReport.Physical_Mechanical_51_60__c = Physical_Mechanical_51_60;
      rReport.Physical_Mechanical_60__c = Physical_Mechanical_60;
      rReport.Sitting_0_5__c = Sitting_0_5;
      rReport.Sitting_6_10__c = Sitting_6_10;
      rReport.Sitting_11_20__c = Sitting_11_20;
      rReport.Sitting_21_30__c = Sitting_21_30;
      rReport.Sitting_31_40__c = Sitting_31_40;
      rReport.Sitting_41_50__c = Sitting_41_50;
      rReport.Sitting_51_60__c = Sitting_51_60;
      rReport.Sitting_60__c = Sitting_60;
      rReport.Standing_0_5__c = Standing_0_5;
      rReport.Standing_6_10__c = Standing_6_10;
      rReport.Standing_11_20__c = Standing_11_20;
      rReport.Standing_21_30__c = Standing_21_30;
      rReport.Standing_31_40__c = Standing_31_40;
      rReport.Standing_41_50__c = Standing_41_50;
      rReport.Standing_51_60__c = Standing_51_60;
      rReport.Standing_60__c = Standing_60;
      rReport.Total_Bed_Days_Utilized_this_Quarter__c = Total_Bed_Days_Utilized_this_Quarter;
      rReport.Unduplicated_Count_of_Residents_Served__c = Unduplicated_Count_of_Residents_Served;
      rReport.Unduplicated_Count_of_Residnts_Restraind__c = Unduplicated_Count_of_Residents_Restraind;
      System.debug('----> rReport: ' + rReport);

      count = [SELECT count()
               FROM Restraint_Report__c WHERE Calendar_Year__c = :Calendar_Year AND Quarter__c = :Quarter AND Provider__c = :accountId];

      if (count == 0) {
        System.debug('Data Saved');
        insert rReport;
        System.debug('Insert done');
        actionresult = '<strong>Success! </strong>Your restraint report has been saved successfully!';
        getRestraintReport(accountId);
      }
      else
      actionResult = '<strong>Error! </strong>A Restraint Report already exists for the specified year and quarter';

    } catch(DMLException e) {
      actionResult = e.getMessage();
      ApexPages.addMessages(e);
    }
    if (memberId != null)
    ApexPages.currentPage().getParameters().put('member', EEC_Util.encryptGetParam(memberId));
    return null;
  }
  public PageReference returnProvider() {
    PageReference pPage = page.EEC_PortalProviderPage;
    if (memberId != null)
    pPage.getParameters().put('member', EEC_Util.encryptGetParam(memberId));
    return pPage;
  }
}