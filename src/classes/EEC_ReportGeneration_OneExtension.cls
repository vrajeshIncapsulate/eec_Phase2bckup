public class EEC_ReportGeneration_OneExtension {
 
  private PageReference pageRef = ApexPages.currentPage();  
  public Inspection__c inspRecord { get; set; }
  public String toastType { get; set; }
  public String toastMsg { get; set; }
  public String inspId {get; set;}  

  public EEC_ReportGeneration_OneExtension(ApexPages.StandardController stdController) {
    inspRecord = (Inspection__c) stdController.getRecord();
    inspId = stdController.getId();  
    toastMsg = '';
    toastType = '';
  }

  public PageReference processNaraitiveDefault() {
    Boolean isMasterVisit = (inspRecord.Mater_Visit_for_Res_Cluster_of_Visits__c != null ? false : true);
    System.debug('----> inspRecord: ' + inspRecord);
    if (isMasterVisit) {
      if (inspRecord.Status__c == 'Visit Completed' || inspRecord.Status__c == 'Report to be sent to Provider') {
        if (inspRecord.Cover_Letter_Narrative__c == null || inspRecord.Cover_Letter_Narrative__c == '') {
          System.debug('----> inspRecord.ProviderId__c: ' + inspRecord.ProviderId__c);
          Account provider = [SELECT Id, Name, RecordTypeId, RecordType.DeveloperName, 
                              RecordType.Name, Provider_City__r.Name, ShippingStreet, 
                              ShippingCity, ShippingState, ShippingPostalCode, 
                              Provider_Address_1__c, State__c, Provider_Zip_Code__c, 
                              OwnerId, Owner.FirstName, Owner.LastName, Owner.Phone, 
                              Umbrella_Members__c, Umbrella_Members__r.Name, 
                              Umbrella_Members__r.ShippingStreet, 
                              Umbrella_Members__r.ShippingState, 
                              Umbrella_Members__r.ShippingPostalCode, 
                              Umbrella_Members__r.ShippingCity 
                              FROM Account 
                              WHERE Id = :inspRecord.Provider_No__c];
          System.debug('----> provider: ' + provider);
          String rtypeName = provider.RecordType.DeveloperName;
          String rtypeLabel = provider.RecordType.Name;
          Contact director = null;
          Contact mainContact = null;

          if (provider.Umbrella_Members__c != null) {
            director = [SELECT Salutation, FirstName, LastName FROM Contact WHERE AccountID = :provider.Umbrella_Members__c AND Role__c = 'Director' LIMIT 1];
            mainContact = [SELECT Salutation, FirstName, LastName FROM Contact WHERE AccountID = :provider.Umbrella_Members__c AND Role__c = 'Main Contact / Licensee' LIMIT 1];
          }
          List<Inspection__c> vList = [SELECT Id, Number_of_non_compliant_items__c 
                                       FROM Inspection__c 
                                       WHERE Id = :inspRecord.Id 
                                       AND Number_of_non_compliant_items__c > 0 
                                       ORDER BY createddate DESC];
          Integer numOfChildVisits = [SELECT Count() 
                                      FROM Inspection__c 
                                      WHERE Mater_Visit_for_Res_Cluster_of_Visits__c = :inspRecord.Id];
          User assignedTo;

          if (inspRecord.Inspector_del__c != null) {
            assignedTo = [SELECT FirstName, LastName, Title FROM User WHERE Id = :inspRecord.Inspector_del__c];
          }

          String directorFullName;
          String mainContactFullName;
          // Setup director and main contact name variables.
          if (director != null) {
            directorFullName = director.Salutation + ' ' + director.FirstName + ' ' + director.LastName;
          }

          if (mainContact != null) {
            mainContactFullName = mainContact.Salutation + ' ' + mainContact.FirstName + ' ' + mainContact.LastName;
          }

          String cln = '';

          if (director != null && rtypeName != 'FCC' && numOfChildVisits > 0) {
            if (directorFullName != null) {
              cln += directorFullName + '<br/>';
            } else {
              cln += (provider.Umbrella_Members__r.Name != null ? provider.Umbrella_Members__r.Name + '<br/>' : '');
            }
          }

          if (mainContact != null && rtypeName != 'FCC' && numOfChildVisits == 0) {
            if (mainContactFullName != null) {
              cln += mainContactFullName + '<br/>';
            } else {
              cln += (provider.Name != null ? provider.Name + '<br/>' : '');
            }
          }

          if (rtypeName == 'FCC') {
            cln += provider.Name + '<br/>';
          }

          if (numOfChildVisits == 0) {
            cln = cln + (provider.ShippingStreet != null ? provider.ShippingStreet : provider.Provider_Address_1__c) + '<br/>';
            cln = cln + (
                         provider.ShippingStreet != null
                         ? (provider.ShippingCity + ', ' + provider.ShippingState + ', ' + provider.ShippingPostalCode)
                         : (provider.Provider_City__r.Name + ', ' + provider.State__c + ', ' + provider.Provider_Zip_Code__c)
            ) + '<br/><br/>';
          } else {
            cln = cln + (provider.Umbrella_Members__c != null && provider.Umbrella_Members__r.ShippingStreet != null ? provider.Umbrella_Members__r.ShippingStreet : provider.Provider_Address_1__c) + '<br/>';
            cln = cln + (
                         provider.Umbrella_Members__c != null && provider.Umbrella_Members__r.ShippingStreet != null
                         ? (provider.Umbrella_Members__r.ShippingCity + ', ' + provider.Umbrella_Members__r.ShippingState + ', ' + provider.Umbrella_Members__r.ShippingPostalCode)
                         : (provider.Provider_City__r.Name + ', ' + provider.State__c + ', ' + provider.Provider_Zip_Code__c)
            ) + '<br/><br/>';
          }

          cln += '<div>Re: Visit conducted ';

          String dateStr = String.valueOf(inspRecord.Date_of_Visit__c);
          if (dateStr != '') {
            cln += 'on&nbsp;' + inspRecord.Date_of_Visit__c;
          }

          if (rtypeName != 'FCC') {
            cln += ' for ' + provider.Name + '</div><br/>';
          } else {
            cln += '</div><br/>';
          }

          if (rtypeName == 'FCC') {
            cln += 'Dear ' + provider.Name + ',<br/><br/>';
          } else {
            if (numOfChildVisits > 0) {
              cln += (directorFullName != '' ? 'Dear ' + directorFullName : 'Dear Provider') + ',<br/><br/>';
            } else {
              cln += (mainContactFullName != '' ? 'Dear ' + mainContactFullName : 'Dear Provider') + ',<br/><br/>';
            }
          }

          if (rtypeName == 'FCC') {
            cln = cln + 'Attached please find the results from my recent ' + inspRecord.Type_of_Visit__c + ' visit to your ' + rtypeLabel + ' program.<br/><br/>';
          } else {
            cln = cln + 'Attached please find the report resulting from my recent ' + inspRecord.Type_of_Visit__c + ' visit to your ' + rtypeLabel + ' program.<br/><br/>';
          }

          if (vList != null && vList.size() > 0) {
            cln = cln + 'As you will note, there are non-compliances which must be corrected. Therefore please read carefully the attached report and submit required corrective action by ' + inspRecord.Corrective_Action_Deadline__c + '.<br/>';

            if (inspRecord.Type_of_Visit__c == 'Pre-Licensing' || inspRecord.Type_of_Visit__c == 'Provisional License Renewal' || inspRecord.Type_of_Visit__c == 'Renewal' || inspRecord.Type_of_Visit__c == 'Change of Location' || inspRecord.Type_of_Visit__c == 'License Upgrade' || inspRecord.Type_of_Visit__c == 'Capacity Increase') {
              cln = cln + 'Following receipt of an acceptable corrective action plan and assuming all other required documentation has been received, your new license will be issued.<br/><br/>';
            }
          } else {
            cln = cln + 'There are no non-compliances which need to be corrected.';

            if (inspRecord.Type_of_Visit__c == 'Pre-Licensing' || inspRecord.Type_of_Visit__c == 'Provisional License Renewal' || inspRecord.Type_of_Visit__c == 'Renewal' || inspRecord.Type_of_Visit__c == 'Change of Location' || inspRecord.Type_of_Visit__c == 'License Upgrade' || inspRecord.Type_of_Visit__c == 'Capacity Increase') {
              cln = cln + 'Therefore assuming all required documentation has been received, your new license will be issued and sent via U.S Mail.';
            }
            cln = cln + ' Please keep this report for your records.<br/><br/>';
          }

          cln = cln + 'If you have any questions regarding this report, please feel free to contact me at the address: ' + inspRecord.Assigned_To_Email__c + ' or by phone: ' + inspRecord.Assigned_To_Phone__c + '.<br/><br/>Respectfully,<br/>';

          if (assignedTo != null) {
            cln = cln + assignedTo.FirstName + ' ' + assignedTo.LastName + '<br/>';
            cln = cln + (assignedTo.Title != null ? assignedTo.Title : '') + '<br/>';
          }

          try {
            inspRecord.Cover_Letter_Narrative__c = cln;
            update inspRecord;

            toastMsg = 'Default Narrative has been set for this visit.';
            toastType = 'success';
          } catch(Exception e) {
            toastMsg = e.getMessage();
            toastType = 'error';
          }
        } else {
          System.debug('Cover Letter Narrative is not empty. If you want to use this functionality, empty the field prior clicking on this button');
          toastMsg = 'Cover Letter Narrative is not empty. If you want to use this functionality, empty the field prior clicking on this button';
          toastType = 'error';
        }
      } else {
        System.debug('This functionality is only available if the visit is in status "Visit Completed" or "Report to be sent to Provider"');
        toastMsg = 'This functionality is only available if the visit is in status "Visit Completed" or "Report to be sent to Provider"';
        toastType = 'error';
      }
    } else {
      System.debug('This visit has a master, please use the master to set the defaults');
      toastMsg = 'This visit has a master, please use the master to set the defaults';
      toastType = 'error';
    }
    return null;
  }

  public PageReference publishReportOnPortal() {
    Inspection__c insp = [SELECT Id,Provider_No__r.Electronic_Communication__c,
                          Checklist_Summary_issue_date__c,
                          Visit_Narrative_Issue_Date__c,
                          Created_on_the_Web__c,Cover_Letter_Issue_Date__c
                          FROM Inspection__c 
                          WHERE Id = : inspId
                         ];  
    try {
      if (!insp.Provider_No__r.Electronic_Communication__c) {
        throw new EEC_CustomException('This provider does not use electronic communication');
      }

      if (insp.Checklist_Summary_issue_date__c == null && insp.Visit_Narrative_Issue_Date__c == null) {
        throw new EEC_CustomException('Checklist Summary or Visit Narrative has not been issued. Please generate one of these reports before publishing.');
      }

      if (insp.Cover_Letter_Issue_Date__c == null) {
        throw new EEC_CustomException('Cover Letter has not been issued. Please generate the letter before publishing.');
      }
        
      if (insp.Created_on_the_Web__c) {
        throw new EEC_CustomException('This visit has already been published.');
      }

      inspRecord.Created_on_the_Web__c = true;
      update inspRecord;
      // Inform the user.
      toastMsg = 'Visit has been published to the web.';
      toastType = 'success';
    } catch(Exception e) {
      toastMsg = e.getMessage();
      toastType = 'error';
    }
    return null;
  }

  public PageReference generateAllReports() {
    String reportType = ApexPages.currentPage().getParameters().get('reportType');
    if (!String.isBlank(reportType) && (inspRecord.Status__c == 'Visit Completed' || inspRecord.Status__c == 'Report Sent to Provider, Awaiting feedback')) {
      // Create an instance of a standard controller using the existing record.
      ApexPages.StandardController inspStdController = new ApexPages.StandardController(inspRecord);
      // Generate the main 3 reports.
      try {
        if (reportType.equalsIgnoreCase('coverletter')) {
          EEC_AttachGeneratedCoverLetterPDF agc = new EEC_AttachGeneratedCoverLetterPDF(inspStdController);  
          agc.savePDF();
          agc.updateObjectAfterCoverLetter(inspRecord);
          toastMsg = 'Cover Letter generated. See Notes and Attachments to view the report.';
          toastType = 'success';
        } else if (reportType.equalsIgnoreCase('checklist')) {
          new EEC_AttachGeneratedVisitChecklistPDF(inspStdController).savePDF();
          toastMsg = 'Visit Summary generated. See Notes and Attachments to view the report.';
          toastType = 'success';
        } else if (reportType.equalsIgnoreCase('narrative')) {
          new EEC_AttachGeneratedNarrativePDF(inspStdController).savePDF();
          toastMsg = 'Visit Narrative generated. See Notes and Attachments to view the report.';
          toastType = 'success';
        } else if (reportType.equalsIgnoreCase('nc')) {
          // Verify if the 4th can be generated.
          if (inspRecord.Can_be_Edited__c) {
            if (inspRecord.Status__c == 'Visit completed, Report to Prepare' || inspRecord.Status__c == 'Report to be approved' || inspRecord.Status__c == 'Report sent for approval') {
              toastMsg = 'This Inspection status is not allowed to generate a PDF';
              toastType = 'error';
            } else {
              Integer numOfInspectionItems = [Select count() From Inspection_Item__c Where Inspection_No__c = :inspRecord.Id AND Inspection_Result__c = 'Non-Compliant'];

              if (numOfInspectionItems > 0) {
                new EEC_GenerateNonCompPDFController(inspStdController).GeneratePDF();
                toastMsg = 'Non-Compliance report generated. See Notes and Attachments to view the report.';
                toastType = 'success';
              } else {
                toastMsg = 'Unable to generate report. No "Non-Compliant" items for the Inspection.';
                toastType = 'error';
              }
            }
          } else {
            toastMsg = 'This functionality is not available for a Closed or Cancelled Visit, Visit must first be re-opened by a Supervisor or Director';
            toastType = 'error';
          }
        }
      } catch(Exception e) {
        toastMsg = 'There was a problem generating the report. Please try again later.';
        toastType = 'error';
      }
    } else {
      toastMsg = 'Report Narrative can only be generated if the Visit is Completed, and not Closed';
      toastType = 'error';
    }
    
    return null;
  }
}