<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_of_Approval</fullName>
        <description>Email Alert of Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X26_Investigation_Approval_Approved_info_to_investigator_docx</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_of_Recall</fullName>
        <description>Email Alert of Recall</description>
        <protected>false</protected>
        <recipients>
            <field>Leader_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X28_Investigation_Approval_Request_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_of_Rejection</fullName>
        <description>Email Alert of Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X27_Investigation_Approval_Rejected_info_to_investigator</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Approver</fullName>
        <description>Email Alert to Approver</description>
        <protected>false</protected>
        <recipients>
            <field>Leader_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X25_Investigation_Approval_Investigation_sent_for_review_and_approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_First_Assigned_Leader</fullName>
        <description>Email Alert to First Assigned Leader</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X23a_Investigation_Assigned_Leader_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Updated_Backup</fullName>
        <description>Email Alert to Updated Backup</description>
        <protected>false</protected>
        <recipients>
            <field>Backup__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X23b_Investigation_Assigned_Backup_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Updated_Leader</fullName>
        <description>Email Alert to Updated Leader</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X24_Investigation_ReAssigned_Notification_docx</template>
    </alerts>
    <alerts>
        <fullName>Email_Reminder_to_provider_for_new_corrective_actions_to_fill</fullName>
        <description>Email Reminder to provider for new corrective actions to fill</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X32_Notification_to_Provider_of_Deadline_for_Corrective_Actions</template>
    </alerts>
    <alerts>
        <fullName>Email_Report_to_Provider_When_Corrective_Actions_ARE_Required</fullName>
        <description>Email Report to Provider When Corrective Actions ARE Required</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X35a_Notification_to_Provider_After_Investigation_With_Non_Compliance_Items</template>
    </alerts>
    <alerts>
        <fullName>Email_Report_to_Provider_When_Corrective_Actions_NOT_Required</fullName>
        <description>Email Report to Provider When Corrective Actions NOT Required</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X35b_Notification_to_Provider_After_Investigation_No_Non_Compliance</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Provider_When_Report_Published_on_Web</fullName>
        <description>Email to Provider When Report Published on Web</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/Test_13_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Escalated_Email_Alert_to_Approver</fullName>
        <description>Escalated Email Alert to Approver</description>
        <protected>false</protected>
        <recipients>
            <field>Leader_Deputy_Commisioner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/Investigation_Approval_Investigation_sent_for_review_and_approval</template>
    </alerts>
    <alerts>
        <fullName>Escalated_Email_Alert_to_Leader</fullName>
        <description>Escalated Email Alert to Leader</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X26_Investigation_Approval_Approved_info_to_investigator_docx</template>
    </alerts>
    <alerts>
        <fullName>Escalated_Email_Alert_to_Previous_Approver</fullName>
        <description>Escalated Email Alert to Previous Approver</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Leader_Deputy_Commisioner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X27_Investigation_Approval_Rejected_info_to_investigator</template>
    </alerts>
    <alerts>
        <fullName>Escalated_Email_Alert_to_next_Approver</fullName>
        <description>Escalated Email Alert to next Approver</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Leader_Director_Supervisor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X27_Investigation_Approval_Rejected_info_to_investigator</template>
    </alerts>
    <alerts>
        <fullName>Escalated_Recall_Email_Alert_to_Approver</fullName>
        <description>Escalated Recall Email Alert to Approver</description>
        <protected>false</protected>
        <recipients>
            <field>Leader_Deputy_Commisioner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X28_Investigation_Approval_Request_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Escalated_Rejection</fullName>
        <description>Escalated Investigation Process Rejected - Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Leader_Deputy_Commisioner__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Leader_Director_Supervisor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X27_Investigation_Approval_Rejected_info_to_investigator</template>
    </alerts>
    <alerts>
        <fullName>Notify_Provider_Licensor_Manager_that_an_escalated_investigation_is_sent_to</fullName>
        <description>Notify Provider Licensor Manager that an escalated investigation is sent to</description>
        <protected>false</protected>
        <recipients>
            <field>Licensor_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/Investigation_Approval_Investigation_sent_for_review_and_approval</template>
    </alerts>
    <alerts>
        <fullName>X20A_Escalated_and_Approved_Investigation_To_1st_Escalation_Owner</fullName>
        <description>20A - Escalated and Approved Investigation To 1st Escalation Owner</description>
        <protected>false</protected>
        <recipients>
            <field>X1st_Escalation_Approver_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X20_Case_Escalated_Approved_info_to_initial_requestor</template>
    </alerts>
    <alerts>
        <fullName>X20_Escalated_and_Approved_Investigation_Alert</fullName>
        <description>20 - Escalated and Approved Investigation Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X20_Case_Escalated_Approved_info_to_initial_requestor</template>
    </alerts>
    <alerts>
        <fullName>X21A_Not_Used_Escalated_and_Rejected_Investigation_Alert</fullName>
        <description>21A_Not_Used - Escalated and Rejected Investigation Alert</description>
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
        <fullName>X21_Escalated_and_Rejected_Investigation_Alert</fullName>
        <description>21 - Escalated and Rejected Investigation Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X21_Case_Escalated_Rejected_info_to_initial_requestor</template>
    </alerts>
    <fieldUpdates>
        <fullName>Escalated_Approval_Status</fullName>
        <field>Investigation_Status__c</field>
        <literalValue>Approved - Report to send</literalValue>
        <name>Escalated Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_Completed_Date</fullName>
        <field>Completed_Date__c</field>
        <formula>IF(ISBLANK(Completed_Date__c),Today(),Completed_Date__c)</formula>
        <name>Escalated Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_Investigation_Status</fullName>
        <field>Investigation_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Escalated Investigation Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_Nullify_Completed_Date</fullName>
        <field>Completed_Date__c</field>
        <name>Escalated Nullify Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_Recall_Nullify_Date</fullName>
        <field>Completed_Date__c</field>
        <name>Escalated Recall Nullify Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_Recalled_Status</fullName>
        <field>Investigation_Status__c</field>
        <literalValue>Assigned - In Progress</literalValue>
        <name>Escalated Recalled Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Escalated_Rejected_Status</fullName>
        <field>Investigation_Status__c</field>
        <literalValue>Assigned - In Progress</literalValue>
        <name>Escalated Rejected Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Closed_Date</fullName>
        <field>Closed_Date__c</field>
        <name>Nullify Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Completed_Date</fullName>
        <field>Completed_Date__c</field>
        <name>Reset Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Completed_Date_Recall</fullName>
        <field>Completed_Date__c</field>
        <name>Reset Completed Date Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lock_Investigation_to_False</fullName>
        <field>Lock_Investigation__c</field>
        <literalValue>0</literalValue>
        <name>Set Lock Investigation to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lock_Investigation_to_True</fullName>
        <field>Lock_Investigation__c</field>
        <literalValue>1</literalValue>
        <name>Set Lock Investigation to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UnFlag_Publish_Report_On_Portal</fullName>
        <field>Created_on_the_Web__c</field>
        <literalValue>0</literalValue>
        <name>UnFlag Publish Report On Portal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UnFlag_Require_Portal_Feedback</fullName>
        <field>Require_Portal_Feedback__c</field>
        <literalValue>0</literalValue>
        <name>UnFlag Require Portal Feedback</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update</fullName>
        <field>Assigned_Date__c</field>
        <formula>Today()</formula>
        <name>Update Assigned Date no Leader</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_1st_Approver_Email_Address</fullName>
        <description>Update the Email address of 1st escalation approver on the case to the Invstigation record&apos;s email address field so it can be used on email alerts</description>
        <field>X1st_Escalation_Approver_Email_Address__c</field>
        <formula>Leader_Deputy_Commisioner__r.Email</formula>
        <name>Update 1st Approver Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Escalated_Task</fullName>
        <field>Approval_Task_Creation__c</field>
        <literalValue>Escalated Approved</literalValue>
        <name>Update Escalated Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Escalated_Task_Recall</fullName>
        <field>Approval_Task_Creation__c</field>
        <name>Update Escalated Task Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Escalated_Task_Reject</fullName>
        <field>Approval_Task_Creation__c</field>
        <literalValue>Escalated Rejected</literalValue>
        <name>Update Escalated Task Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Intake_Date_with_Today</fullName>
        <field>Assigned_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Intake Date with Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Invest_Status_to_Report_Sent</fullName>
        <description>Updates the status on Investigation to Ready to Publish/Send to Provider</description>
        <field>Investigation_Status__c</field>
        <literalValue>Ready to Publish/Send to Provider</literalValue>
        <name>Update Invest Status to Report Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Investigation_Completed_Date</fullName>
        <field>Completed_Date__c</field>
        <formula>IF(ISBLANK(Completed_Date__c),Today(),Completed_Date__c)</formula>
        <name>Update Investigation Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Investigation_Sent_Date</fullName>
        <description>Set Investigation sent date to today</description>
        <field>Sent_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Investigation Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Investigation_Status</fullName>
        <field>Investigation_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Update Investigation Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Investigation_Status_for_Approved</fullName>
        <field>Investigation_Status__c</field>
        <literalValue>Approved - Report to send</literalValue>
        <name>Update Investigation Status for Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Investigation_Status_for_no_Leade</fullName>
        <field>Investigation_Status__c</field>
        <literalValue>Assigned - In Progress</literalValue>
        <name>Update Investigation Status for no Leade</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NonEscalated_Task</fullName>
        <field>Approval_Task_Creation__c</field>
        <literalValue>NonEscalated Approved</literalValue>
        <name>Update NonEscalated Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NonEscalated_Task_Recall</fullName>
        <field>Approval_Task_Creation__c</field>
        <name>Update NonEscalated Task Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NonEscalated_Task_Reject</fullName>
        <field>Approval_Task_Creation__c</field>
        <literalValue>NonEscalated Rejected</literalValue>
        <name>Update NonEscalated Task Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Nullify_Approval_Task</fullName>
        <field>Approval_Task_Creation__c</field>
        <name>Update Nullify Approval Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Nullify_NE_Approval_Task</fullName>
        <field>Approval_Task_Creation__c</field>
        <name>Update Nullify NE Approval Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Provider_Email_on_Investigation</fullName>
        <description>Copies the value of the Provider&apos;s Email id into investigation record so it can be used for sending emails from workflows associated with Investigation object</description>
        <field>Provider_Email__c</field>
        <formula>Provider_No__r.Provider_Email__c</formula>
        <name>Update Provider Email on Investigation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Recalled</fullName>
        <field>Investigation_Status__c</field>
        <literalValue>Assigned - In Progress</literalValue>
        <name>Update Status Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_Rejected</fullName>
        <field>Investigation_Status__c</field>
        <literalValue>Assigned - In Progress</literalValue>
        <name>Update Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Lock Investigation when closed</fullName>
        <actions>
            <name>Set_Lock_Investigation_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Investigation__c.Closed_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Investigation__c.Investigation_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Investigation__c.Lock_Investigation__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Reopen Investigation</fullName>
        <actions>
            <name>Nullify_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Investigation_Status__c) &amp;&amp; ISPICKVAL(PRIORVALUE(Investigation_Status__c),&apos;Closed&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Report Published Feedback Action NOT Required</fullName>
        <actions>
            <name>Email_Report_to_Provider_When_Corrective_Actions_NOT_Required</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Investigation__c.Created_on_the_Web__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Investigation__c.Require_Portal_Feedback__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This workflow rule assigns the Investigator a task for followup when Require Portal Feedback is checked on the investigation.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Report Published Feedback Action Required</fullName>
        <actions>
            <name>Email_Report_to_Provider_When_Corrective_Actions_ARE_Required</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Review_Non_Compliant_Items_Corrective_Actions</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Investigation__c.Created_on_the_Web__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Investigation__c.Require_Portal_Feedback__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule assigns the Investigator a task for followup when Require Portal Feedback is checked on the investigation.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Report Published Feedback Followup Required</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Investigation__c.Created_on_the_Web__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Investigation__c.Require_Portal_Feedback__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule assigns the Investigator a task for followup when Require Portal Feedback is checked on the investigation and no corrective actions have been submitted by Provider</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Reminder_to_provider_for_new_corrective_actions_to_fill</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Reminder_to_provider_for_new_corrective_actions_to_fill_after_investigation_32</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Investigation__c.Sent_Date__c</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Report Published on Web</fullName>
        <actions>
            <name>Update_Investigation_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Provider_Email_on_Investigation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_sent_Notification_to_Provider_after_Investigation_35</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Investigation__c.Created_on_the_Web__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This workflow rule sets the status of the investigation to closed when Require Report is Published on web is checked on the investigation. Additionally sends required emails to Providers</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Investigation Intake Date</fullName>
        <actions>
            <name>Update_Intake_Date_with_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the Intake Date of an investigation to the day an investigator was assigned to the date.</description>
        <formula>AND(NOT ( OR( ISNULL( Assigned_To_Id__c ),  ISBLANK( Assigned_To_Id__c ), Assigned_To_Id__c =&quot;&quot;)), OR( ISNULL( Assigned_Date__c ),  ISBLANK( Assigned_Date__c  ), TEXT(Assigned_Date__c) =&quot;&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UnLock Investigation when not closed</fullName>
        <actions>
            <name>Set_Lock_Investigation_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Investigation__c.Closed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Investigation__c.Investigation_Status__c</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Investigation__c.Lock_Investigation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Investigation Leader</fullName>
        <actions>
            <name>Email_Alert_to_Updated_Leader</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_1st_Approver_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Assigned_To__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Investigation for no Leader</fullName>
        <actions>
            <name>Email_Alert_to_First_Assigned_Leader</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Investigation_Status_for_no_Leade</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Assigned_To__c) &amp;&amp; ISBLANK(PRIORVALUE(Assigned_To__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Updated Investigation - Backup</fullName>
        <actions>
            <name>Email_Alert_to_Updated_Backup</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Backup__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Email_sent_Internal_Investigation_Requested_39</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Internal Investigation Requested - #39</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Notification_to_Provider_after_Investigation_35</fullName>
        <assignedTo>Investigator</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Creates a closed task to document the fact that an email was sent to Provider to notify that report is published on Web</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Notification to Provider after Investigation - #35</subject>
    </tasks>
    <tasks>
        <fullName>Reminder_to_provider_for_new_corrective_actions_to_fill_after_investigation_32</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the provider 5 days after first email to remind  that new non-compliant items are ready for review on portal and must be completed</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Investigation__c.Sent_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Reminder to provider for new corrective actions to fill after investigation - #32</subject>
    </tasks>
    <tasks>
        <fullName>Review_Non_Compliant_Items_Corrective_Actions</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Investigation__c.Corrective_Actions_Reminder_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Review Non-Compliant Items Corrective Actions</subject>
    </tasks>
</Workflow>
