<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_1st_Escalation_Approver_Regarding_Rejection</fullName>
        <description>Email 1st Escalation Approver Regarding Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>X1st_Escalation_Approver_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X21_Case_Escalated_Rejected_info_to_initial_requestor</template>
    </alerts>
    <alerts>
        <fullName>Email_Case_Owner_Regarding_Rejection</fullName>
        <description>Email Case Owner Regarding Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X21_Case_Escalated_Rejected_info_to_initial_requestor</template>
    </alerts>
    <alerts>
        <fullName>Email_Reporter_of_Case_Closed_Not_Regulatory_in_Nature</fullName>
        <description>Email Reporter of Case Closed-Not Regulatory in Nature</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X7_Notification_to_reporter_a_complaint_is_not_under_authority_of_EEC</template>
    </alerts>
    <alerts>
        <fullName>Email_submitter_that_non_compliance_injury_closure_was_rejected</fullName>
        <description>Email submitter that non-compliance injury closure was rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X16_SLGSA_case_with_no_noncompliance_Rejected_and_go_to_Triage_docx</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Case_Contact_Email_when_a_new_Case_is_created</fullName>
        <description>Email to Case Contact Email when a new Case is created</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X5b_Notification_to_reporter_a_incident_has_been_recorded</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Case_Contact_when_a_Complaint_Case_is_created</fullName>
        <description>Email to Case Contact when a Complaint Case is created</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X5a_Notification_to_reporter_a_complaint_has_been_recorded</template>
    </alerts>
    <alerts>
        <fullName>Incident_Injury_report_started_but_not_submitted_Email_sent_to_Licensor_129</fullName>
        <description>Incident/Injury report started but not submitted - Email sent to Licensor #129</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X129_Incident_Injury_report_started_but_not_submitted_to_Licensor</template>
    </alerts>
    <alerts>
        <fullName>Incident_Injury_report_started_but_not_submitted_Email_sent_to_Provider_128</fullName>
        <description>Incident/Injury report started but not submitted - Email sent to Provider #128</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email_Hidden__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X128_Incident_Injury_report_started_but_not_submitted_to_Provider</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_New_Case_Owner</fullName>
        <description>Send Email to New Case Owner</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>Licensor_s_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X49_New_Incident_From_Portal_to_Review</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_the_case_reporter</fullName>
        <description>Send an email to the case reporter</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X18_Notification_to_Provider_of_closure_of_SLGSA_injury_without_non_compliance</template>
    </alerts>
    <alerts>
        <fullName>Send_case_recall_notice_to_approver</fullName>
        <description>Send case recall notice to approver</description>
        <protected>false</protected>
        <recipients>
            <field>Triage_Responsible__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X17_SLGSA_case_with_no_noncompliance_Request_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Send_submitter_approval</fullName>
        <description>Send approval to case submitter</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X15_SLGSA_case_with_no_noncompliance_Approved_and_Closed</template>
    </alerts>
    <alerts>
        <fullName>X18_Notification_to_Provider_of_closure_of_SLGSA_injury_without_non_compliance</fullName>
        <description>18 Notification to Provider of closure of SLGSA injury without non-compliance</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X18_Notification_to_Provider_of_closure_of_SLGSA_injury_without_non_compliance</template>
    </alerts>
    <alerts>
        <fullName>X21A_Escalated_and_Rejected_Investigation_Alert</fullName>
        <description>21A - Escalated and Rejected Investigation Alert</description>
        <protected>false</protected>
        <recipients>
            <field>X1st_Escalation_Approver_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X21_Case_Escalated_Rejected_info_to_initial_requestor</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_close_case</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Approval close case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_case_triage_target_email_list</fullName>
        <field>TriageEscalationApproverEmailList__c</field>
        <name>Clear case triage target email list</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_escalation_approver_list</fullName>
        <field>TriageEscalationApproverEmailList__c</field>
        <name>Clear escalation approver list</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Case</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Closed_Reasons</fullName>
        <field>Closing_Reasons__c</field>
        <name>Nullify Closed Reasons</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Send_Case_Triage_Email_to_Approved</fullName>
        <description>Set the SendCaseTriageEmail field value to Approved, so that a workflow rule on the changed value of this field can update the Investigation.Escalated Investigation Flag to TRUE as well as trigger off required email alerts</description>
        <field>SendCaseTriageEmail__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Send Case Triage Email to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Investigated</fullName>
        <field>Status</field>
        <literalValue>Investigation in Progress</literalValue>
        <name>Set Status to Investigated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Trigger_Escalation_Approval_to_True</fullName>
        <description>Set the field TriggerTrageEscalationApproval Flag to True so that an approval workflow action can be fired to set Escalation Investigation Field to TRUE as well as trigger email alerts</description>
        <field>TriggerTriageEscalationApproval__c</field>
        <literalValue>1</literalValue>
        <name>Set Trigger Escalation Approval to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_rejected</fullName>
        <field>ApprovalStatus__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set approval status rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approver_s_manager_to_null</fullName>
        <field>Approver_Manager__c</field>
        <name>Set approver&apos;s manager to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_case_status_in_triage</fullName>
        <field>Status</field>
        <literalValue>In Triage</literalValue>
        <name>Set case status in triage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_manager_user</fullName>
        <field>Triage_Responsible__c</field>
        <lookupValue>eec_standard_user@incapsulate.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set manager user</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_send_trigger_triage_email_approved</fullName>
        <field>SendCaseTriageEmail__c</field>
        <literalValue>Approved</literalValue>
        <name>Set send trigger triage email approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_send_trigger_triage_email_declined</fullName>
        <field>SendCaseTriageEmail__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set send trigger triage email declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_send_trigger_triage_email_recalled</fullName>
        <field>SendCaseTriageEmail__c</field>
        <literalValue>Recalled</literalValue>
        <name>Set send trigger triage email recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_trigger_triage_escalation_false</fullName>
        <field>TriggerTriageEscalationApproval__c</field>
        <literalValue>0</literalValue>
        <name>Set trigger triage escalation false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_trigger_triage_escalation_true</fullName>
        <field>TriggerTriageEscalationApproval__c</field>
        <literalValue>1</literalValue>
        <name>Set trigger triage escalation true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_trigger_trigger_triage_email_null</fullName>
        <field>SendCaseTriageEmail__c</field>
        <name>Set trigger trigger triage email null.</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_1st_Approver_Email_Address</fullName>
        <description>Update the email address of User assigned as the 1st level escalation approver</description>
        <field>X1st_Escalation_Approver_Email_Address__c</field>
        <formula>X1st_Escalation_Case_Approver__r.Email</formula>
        <name>Update 1st Approver Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Provider_Email_Hidden</fullName>
        <field>Provider_Email_Hidden__c</field>
        <formula>Provider_Email__c</formula>
        <name>Update Provider Email Hidden</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_User_Note_in_Reporter_Info</fullName>
        <field>Note_To_User2__c</field>
        <formula>If (NOT(ISBLANK(Note_To_User2__c)),&apos;N/A&apos;,&apos;&apos;)</formula>
        <name>Update User Note in Reporter Info</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_status_to_esclated</fullName>
        <field>Status</field>
        <literalValue>Escalated</literalValue>
        <name>Update case status to esclated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_to_new</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Update case to new</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_closing_reson_to_injury_no_nc</fullName>
        <field>Closing_Reasons__c</field>
        <formula>&quot;Injury without non-compliance item identified&quot;</formula>
        <name>Update closing reson to injury, no nc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status</fullName>
        <field>Status</field>
        <literalValue>No Non-Compliance Closure Pending</literalValue>
        <name>Update status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Notification when Case is Not Submitted</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Electronic_Communication__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Not Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>51A Incident,Incident,SLGSA Injury</value>
        </criteriaItems>
        <description>As the provider I shall be notified if my reported Case (incident/injury) is in &quot;Not Submitted&quot; status for more than one hour</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Incident_Injury_report_started_but_not_submitted_Email_sent_to_Licensor_129</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Incident_Injury_report_started_but_not_submitted_Email_sent_to_Provider_128</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Incident_Injury_report_started_but_not_submitted_128_to_Provider</name>
                <type>Task</type>
            </actions>
            <actions>
                <name>Email_sent_Incident_Injury_report_started_but_not_submitted_129</name>
                <type>Task</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email Response When a Case is Created %28Complaint%29</fullName>
        <actions>
            <name>Email_to_Case_Contact_when_a_Complaint_Case_is_created</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_sent_to_Originator_of_Case_Complaint</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Send an Email Response to the originator (if email address is found) when a new Case is created and Record Type is &quot;Complaint&quot;</description>
        <formula>And ( NOT (Or (Contact.Email = &quot;&quot;, ISNULL(Contact.Email), ISBLANK(Contact.Email))),  or(RecordType.Name = &quot;Complaint&quot;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email Response When a Case is Created %28Incident or Injury%29</fullName>
        <actions>
            <name>Email_to_Case_Contact_Email_when_a_new_Case_is_created</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_sent_to_Originator_of_Case_Incident</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Send an Email Response to the originator (if email address is found) when a new Case is created and Record Type is &quot;Incident&quot; or &apos;SLGSA Injury&quot;</description>
        <formula>And ( NOT (Or (Contact.Email = &quot;&quot;, ISNULL(Contact.Email), ISBLANK(Contact.Email))),  or(RecordType.Name = &quot;Incident&quot;, RecordType.Name=&quot;SLGSA Injury&quot;), ISPICKVAL( Status , &quot;New&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email to Reporter When a Case is Closed</fullName>
        <actions>
            <name>Email_Reporter_of_Case_Closed_Not_Regulatory_in_Nature</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_sent_Notification_to_reporter_a_complaint_is_not_under_authority_of_EEC_7</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>2 AND (1 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Not Regulatory in Nature</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email to Reporter When a SLGSA Case is Closed</fullName>
        <actions>
            <name>X18_Notification_to_Provider_of_closure_of_SLGSA_injury_without_non_compliance</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_sent_Notification_to_Provider_of_closure_of_SLGSA_injury_without_non_compl</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>2 AND (1 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>No Non-Compliance SLGSA Injury</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Reopen Case</fullName>
        <actions>
            <name>Nullify_Closed_Reasons</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; ISPICKVAL(PRIORVALUE(Status),&apos;Closed&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update 1st Approver Email Address</fullName>
        <actions>
            <name>Update_1st_Approver_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.X1st_Escalation_Case_Approver__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update the 1st Approver Users&apos; email address into case record so it can be used as an email field when sending alerts</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Provider Email Hidden</fullName>
        <actions>
            <name>Update_Provider_Email_Hidden</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Provider Email Hidden field so that Provider Email can be used in email alerts</description>
        <formula>NOT(ISBLANK(Provider_Email__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Provider Email Hidden as email field</fullName>
        <active>true</active>
        <description>Provider_Email__c is getting populated on Case, however, since it is a formula field it cannot be used in email alerts. There is another Provider field</description>
        <formula>NOT(ISNULL(Provider_Email__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update User Note under Reporter Information</fullName>
        <actions>
            <name>Update_User_Note_in_Reporter_Info</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(Note_To_User2__c)),  Note_To_User2__c != &apos;N/A&apos;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Email_sent_Incident_Injury_report_started_but_not_submitted_128_to_Provider</fullName>
        <assignedToType>accountOwner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Incident/Injury report started but not submitted - #128 (to Provider)</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Incident_Injury_report_started_but_not_submitted_129</fullName>
        <assignedToType>accountOwner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Incident/Injury report started but not submitted - #129 (to Licensor)</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Notification_to_Provider_of_closure_of_SLGSA_injury_without_non_compl</fullName>
        <assignedToType>accountOwner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Notification to Provider of closure of SLGSA injury without non-compliance item - #18</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Notification_to_reporter_a_complaint_is_not_under_authority_of_EEC_7</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the reporter as case does not concerned an area EEC has authority</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Notification to reporter a complaint is not under authority of EEC - #7</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_to_Originator_of_Case_Complaint</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent to Originator of Case (Complaint)</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_to_Originator_of_Case_Incident</fullName>
        <assignedToType>accountOwner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent to Originator of Case (Incident)</subject>
    </tasks>
    <tasks>
        <fullName>Review_New_Incident_Submitted_from_Portal</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Review New Incident Submitted from Portal</subject>
    </tasks>
</Workflow>
