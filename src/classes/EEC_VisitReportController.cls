public class EEC_VisitReportController {
    
    String visitID {get; private set;}
    String accountId {get; private set;}
    public String pageID {get; set;}
    public String investId {get;set;}
    public Inspection__c inspection {get; private set;}
    public List<Inspection_Item__c> nonComplianceInspectionItem {get; private set;}
    public List<Inspection_Item__c> commentInspectionItem {get; private set;}
    public List<Inspection_Item__c> technicalInspectionItem {get; private set;}
    public List<Visit_Best_Practices__c> visitBestPractices {get; private set;}
    public Account account {get; private set;}
    public Attachment coverLetter {get; private set;}
    public Attachment nonComplianceLetter {get; private set;}   
    public Attachment visitCheckListReport {get; private set;}
    public Attachment visitReportReport {get; private set;}
    public String memberId {get;set;}
        
    public EEC_VisitReportController(){
        visitID = ApexPages.currentPage().getParameters().get('visitID');
        memberId = ApexPages.currentPage().getParameters().get('member');
        if(String.isNotBlank(memberId)){
           accountid = memberId;
        }else{
            List<Account> tempAccount = [Select Id From Account Where ID in (Select Accountid From User Where id = :Userinfo.getUserId()) Limit 1];
            if (tempAccount != null && tempAccount.size() == 1) {
              accountid = tempAccount.get(0).Id;    
            }
        }
        pageID = ApexPages.currentPage().getParameters().get('pageID');
        investId = ApexPages.currentPage().getParameters().get('investId');

        if(accountid != null)
        	account = [SELECT Id,Name,Restraint_Method__c,Record_Type_Name__c FROM Account WHERE Id =: accountId];
        if(visitID != null)
        {
        	getVisitReportByID();
        	getNonComplianceInspectionItem();
            getCommentInspectionItem();
            
            getTechnicalAssistanceInspectionItem();
            getVisitBestPractices();
        }
    }
    
    public void getVisitReportByID()
    {
        inspection = [SELECT Activity_Summary__c,Address_1__c,Address_2__c,
                                          Announced_Visit_Remainder__c,Announced__c,Assigned_To_Email__c,
                                          Assigned_To_Id__c,Assigned_To_Manager__c,Assigned_To_Phone__c,
                                          Cancellation__c,Can_be_Edited__c,Checklist_Summary_issue_date__c,
                                          City__c,Closed_Cancellation_Date__c,Comments__c,
                                          Corrective_Action_Deadline__c,Corrective_Action_Required__c,
                                          Cover_Letter_Issue_Date__c,Cover_Letter_Narrative__c,
                                          CreatedById,CreatedDate,Date_of_Visit__c,Email_Alert_Main_Recipient__c,
                                          Email_Alert_Secondary_Recipient__c,Estimated_Deadline__c,Id,
                                          Inspector_del__r.Name,InvestigationId__c,Investigation__c,
                                          LastReferencedDate,LastViewedDate,License_Number__c,
                                          Name,No_Birth_Mothers_Making_Adoption_Plan__c,
                                          No_Birth_Mothers_Receiving_Services__c,
                                          No_Families_Receiving_Info_and_Referral__c,
                                          No_Families_Rec_Home_Stdy_Serv_Only__c,
                                          No_Indiv_Rec_Search_and_or_Reunion_Serv__c,
                                          No_of_Families_Rec_Case_Mgmt_Services__c,
                                          NumberOfChildrenPlacedInCare__c,
                                          Number_of_Adoptive_Placements__c,Number_of_Child_Assessments__c,
                                          Number_of_compliant_items__c,Number_of_days_to_receive_response__c,
                                          Number_of_Foster_Homes__c,Number_of_Home_Study_Services__c,
                                          Number_of_items_to_assess__c,
                                          Number_of_Items_with_Corrective_Actions__c,
                                          Number_of_non_applicable_items__c,Number_of_non_assessed_items__c,
                                          Number_of_non_compliant_items__c,Number_of_Reunions_Facilitated__c,
                                          Number_of_visit_items__c,Number_of_Waiting_Families__c,
                                          Original_Visit__c,ProviderId__c,Provider_No__c,Provider_Owner__c,
                                          Provider_Type__c,RecordTypeId,Remarks_and_Notes__c,Sent_date__c,
                                          Specific_Visit_Requirements__c,Statement_of_non_compliance__c,
                                          State__c,Status__c,SystemModstamp,Tech_Assist_Recommendations_Comments__c,
                                          Time_of_visit__c,Total_Capacity__c,Type_of_Visit__c,
                                          Updates_Changes__c,Visit_Address_Full_Email__c,Visit_Narrative_Issue_Date__c,
                                          Zip_Code__c FROM Inspection__c WHERE ID =: visitID];
         
        Attachment[] letters;
        letters = [SELECT Id, Name, parent.Id, parent.Name, parent.Type FROM Attachment 
                      WHERE parent.Id =: visitID AND Name like '%CoverLetter%' ORDER BY LastModifiedDate Desc LIMIT 1];
        if(letters != null && letters.size() > 0)
            coverLetter = letters[0];

    	letters = [SELECT Id, Name, parent.Id, parent.Name, parent.Type FROM Attachment 
                      WHERE parent.Id =: inspection.Id AND Name like '%StatementNonCompliance%' ORDER BY LastModifiedDate Desc LIMIT 1];
        if(letters != null && letters.size() > 0)
            nonComplianceLetter = letters[0];

        letters = [SELECT Id, Name, parent.Id, parent.Name, parent.Type FROM Attachment 
                      WHERE parent.Id =: inspection.Id AND Name like '%CheckList%' ORDER BY LastModifiedDate Desc LIMIT 1];
        if(letters != null && letters.size() > 0)
            visitCheckListReport = letters[0];

        letters = [SELECT Id, Name, parent.Id, parent.Name, parent.Type FROM Attachment 
                      WHERE parent.Id =: inspection.Id AND Name like '%Narrative%' ORDER BY LastModifiedDate Desc LIMIT 1];
    	if(letters != null && letters.size() > 0)
            visitReportReport = letters[0];

	}
    
    public void getNonComplianceInspectionItem()
    {
        List<Inspection_Item__c> items = new List<Inspection_Item__c>();
        items = [SELECT Category_additional__c,Category_list__c,Category_standard__c,
                          Correction_Plan__c,Corrective_Actions_Submitter__c,
                          Date_Corrective_Actions_Received__c,Date_Implemented__c,
                          Id,Inspection_Item_Name_for_list__c,Inspection_Item_Name__c,
                          Inspection_No__c,Inspection_Result__c,Inspection_Standard_Id__c,
                          Name,Non_Assessed_Item__c,Observations__c,Visit_Mode_Ranking__c,
                          Standard_Inspection_Item__c, Technical_Assistance__c
                          FROM Inspection_Item__c WHERE Inspection_No__c =: visitID AND Inspection_Result__c = 'Non-Compliant' order by Visit_Mode_Ranking__c ASC nulls first];
        
        if(items != null && items.size() > 0){
            nonComplianceInspectionItem = items;
        }
    
    }
    
    public void getVisitBestPractices(){
        visitBestPractices = new List<Visit_Best_Practices__c>();
        
        for(Visit_Best_Practices__c item : [SELECT Id, Associated_Visit__c,Best_Practice__c,
                                            Best_Practice__r.Name,
                                            Best_Practice_Guidance__c, Observation__c,
                                            Visit_Provider_Type__c 
                                            FROM Visit_Best_Practices__c
                                            WHERE Associated_Visit__c =: visitID]){
               system.debug('MMMMm'+item.id+item.Best_Practice__r.Name);
                                                
              visitBestPractices.add(item);      
              system.debug('MMMM'+visitBestPractices.size());                           
        }
    }
    
    public void getCommentInspectionItem()
    {
        //Since the Longtext area can not be filtered a using a query call. 
        //Iterate through each element to see if the Observation__c is empty
        
        commentInspectionItem = new List<Inspection_Item__c>();
        for(Inspection_Item__c items : [SELECT 
                          Category_additional__c,Category_list__c,Category_standard__c,
                          Correction_Plan__c,Corrective_Actions_Submitter__c,
                          Date_Corrective_Actions_Received__c,Date_Implemented__c,
                          Id,Inspection_Item_Name_for_list__c,Inspection_Item_Name__c,
                          Inspection_No__c,Inspection_Result__c,Inspection_Standard_Id__c,
                          Name,Non_Assessed_Item__c,Observations__c,Visit_Mode_Ranking__c,
                          Standard_Inspection_Item__c, Technical_Assistance__c
                          FROM Inspection_Item__c WHERE Inspection_No__c =: visitID and Inspection_Result__c = 'Compliant' order by Visit_Mode_Ranking__c ASC nulls first])
        {
        	if(String.isNotBlank(items.Observations__c)){
            	commentInspectionItem.add(items);
            }
        }
    }
    
    public void getTechnicalAssistanceInspectionItem()
    {
        technicalInspectionItem = new List<Inspection_Item__c>();
        for(Inspection_Item__c item : [SELECT 
                          Category_additional__c,Category_list__c,Category_standard__c,
                          Correction_Plan__c,Corrective_Actions_Submitter__c,
                          Date_Corrective_Actions_Received__c,Date_Implemented__c,
                          Id,Inspection_Item_Name_for_list__c,Inspection_Item_Name__c,
                          Inspection_No__c,Inspection_Result__c,Inspection_Standard_Id__c,
                          Name,Non_Assessed_Item__c,Observations__c,Visit_Mode_Ranking__c,
                          Standard_Inspection_Item__c, Technical_Assistance__c
                          FROM Inspection_Item__c WHERE Inspection_No__c =: visitID order by Visit_Mode_Ranking__c ASC nulls first])
        {
            if(item.Technical_Assistance__c != null)
            {
                technicalInspectionItem.add(item);
            }
        }
    }
    public PageReference returnProvider() {
        PageReference pPage = page.EEC_PortalProviderPage;
        if(memberId != null)  
           pPage.getParameters().put('member',EEC_Util.encryptGetParam(memberId));
        return pPage;
  	}

}