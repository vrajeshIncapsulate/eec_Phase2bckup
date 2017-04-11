<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Licensor_that_the_report_is_Approved</fullName>
        <description>Email Licensor that the report is Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Inspector_del__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X10_Licensing_Visit_Approved</template>
    </alerts>
    <alerts>
        <fullName>Email_the_Licensor_that_the</fullName>
        <description>Email the Manager that the Visit approval is Recalled</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To_Manager__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X12_Licensing_Visit_Approval_Request_Recalled</template>
    </alerts>
    <alerts>
        <fullName>Email_the_Licensor_that_the_Visit_is_Rejected</fullName>
        <description>Email the Licensor that the Visit is Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Inspector_del__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X11_Licensing_Visit_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Approver_to_Review_and_Approve</fullName>
        <ccEmails>gkalluri@incapsulate.com</ccEmails>
        <description>Email to Approver to Review and Approve</description>
        <protected>false</protected>
        <recipients>
            <recipient>Regional_Director</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X9_New_Licensing_Visit_to_Review_and_Approve</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Pro</fullName>
        <description>Notification to Provider for scheduled Visit</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Alert_Main_Recipient__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Alert_Secondary_Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X2_Notification_to_Provider_that_a_visit_has_been_scheduled</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Provider_for_scheduled_Visit_in_3_days</fullName>
        <description>Notification to Provider for scheduled Visit in 3 days</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Alert_Main_Recipient__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Alert_Secondary_Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X3_Reminder_to_Provider_that_a_visit_has_been_scheduled</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Provider_for_updated_scheduled_Visit</fullName>
        <description>Notification to Provider for updated scheduled Visit</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Alert_Main_Recipient__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Alert_Secondary_Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X4_Notification_to_Provider_that_a_visit_has_been_re_scheduled</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Email_to_Provider</fullName>
        <description>Reminder Email to Provider to remind of reports for approval</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Alert_Main_Recipient__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Alert_Secondary_Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X6_Notification_to_Provider_of_deadline_approaching_for_corrective_action</template>
    </alerts>
    <alerts>
        <fullName>X31a_Notification_to_Provider_after_Licensing_Visit_with_non_compliance</fullName>
        <description>31a - Notification to Provider after Licensing Visit (with non-compliance)</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Alert_Main_Recipient__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Alert_Secondary_Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X31a_Notification_to_Provider_after_Licensing_Visit_with_non_compliance</template>
    </alerts>
    <alerts>
        <fullName>X31b_Notification_to_Provider_after_Licensing_Visit_no_non_compliance</fullName>
        <description>31b - Notification to Provider after Licensing Visit (no non-compliance)</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Alert_Main_Recipient__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Email_Alert_Secondary_Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X31b_Notification_to_Provider_after_Licensing_Visit_no_non_compliance</template>
    </alerts>
    <alerts>
        <fullName>X86_Notification_to_supervisor_that_visit_tool_has_been_switched</fullName>
        <description>86 - Notification to supervisor that visit tool has been switched</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To_Manager__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X86_Notification_to_supervisor_that_visit_tool_has_been_switched</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Status_to_Pending_Approval</fullName>
        <description>Change the Status field to &apos;Pending Approval&apos;</description>
        <field>Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Change Status to Pending Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Visit_Completed</fullName>
        <description>Update Status field to &apos;Visit Completed&apos;</description>
        <field>Status__c</field>
        <literalValue>Visit Completed</literalValue>
        <name>Change Status to Visit Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_send_Report</fullName>
        <description>Change status to &apos;Report to be sent to the Provider&apos;</description>
        <field>Status__c</field>
        <literalValue>Report to be sent to Provider</literalValue>
        <name>Change Status to Send Report</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_username_in_Visit_Mode_Locked_By</fullName>
        <field>Visit_Mode_Locked_By__c</field>
        <name>Clear username in Visit Mode Locked By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Cancellation_Date</fullName>
        <field>Closed_Cancellation_Date__c</field>
        <formula>Today()</formula>
        <name>Closed/Cancellation Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Cancellation_Reason</fullName>
        <field>Cancellation__c</field>
        <name>Nullify Cancellatioj Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nullify_Cancellation_date</fullName>
        <field>Closed_Cancellation_Date__c</field>
        <name>Nullify Cancellation date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Address_2_of_Visit</fullName>
        <description>Set Address 2 of Visit with Provider Address 2</description>
        <field>Address_2__c</field>
        <formula>IF(ISBLANK(Original_Visit__c), Provider_No__r.Provider_Address_2__c,
Original_Visit__r.Address_2__c)</formula>
        <name>Set Address 2 of Visit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Address_of_Visit</fullName>
        <description>Set Address 1 of Visit with Provider Address 1</description>
        <field>Address_1__c</field>
        <formula>IF(ISBLANK(Original_Visit__c), Provider_No__r.Provider_Address_1__c,
Original_Visit__r.Address_1__c)</formula>
        <name>Set Address 1 of Visit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Alert_Main_Recipient_with_Prov_email</fullName>
        <field>Email_Alert_Main_Recipient__c</field>
        <formula>Provider_No__r.Provider_Email__c</formula>
        <name>Set Alert Main Recipient with Prov email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_City_of_Visit</fullName>
        <description>Set City of Visit with Provider City</description>
        <field>City__c</field>
        <formula>IF(ISBLANK(Original_Visit__c), Provider_No__r.Provider_City__r.Name,
Original_Visit__r.City__c)</formula>
        <name>Set City of Visit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Zip_Code_of_Visit</fullName>
        <description>Set Zip Code of Visit with Zip Code</description>
        <field>Zip_Code__c</field>
        <formula>IF(ISBLANK(Original_Visit__c), Provider_No__r.Provider_Zip_Code__c,
Original_Visit__r.Zip_Code__c)</formula>
        <name>Set Zip Code of Visit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Remainder</fullName>
        <field>Announced_Visit_Remainder__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Remainder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateVisitManagerEmail</fullName>
        <description>Update the Assigned To user manager email address on the visit.</description>
        <field>Assigned_To_Manager__c</field>
        <formula>Inspector_del__r.Manager.Email</formula>
        <name>UpdateVisitManagerEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Mid_Cycle_Review_Date</fullName>
        <description>Updates Last Mid Cycle Review Date from Date of Visit on Provider when a qualifying Visit is completed.</description>
        <field>Last_Mid_Cycle_Review_Date__c</field>
        <formula>Date_of_Visit__c</formula>
        <name>Update Last Mid Cycle Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Provider_No__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_No_Days_to_Receive_Response</fullName>
        <description>Set the value of Number of Days to Receive Response with the value from the &quot;Config&quot; object</description>
        <field>Number_of_days_to_receive_response__c</field>
        <formula>Provider_No__r.Config_Record__r.No_of_Days_Prior_Corr_Action_Deadline__c</formula>
        <name>Update No Days to Receive Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Provider_Next_FCC_Renewal_Visit</fullName>
        <field>Next_FCC_Renewal_Visit__c</field>
        <name>Update Provider Next FCC Renewal Visit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>PreviousValue</operation>
        <protected>false</protected>
        <targetObject>Provider_No__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sent_Date_to_TODAY</fullName>
        <field>Sent_date__c</field>
        <formula>TODAY()</formula>
        <name>Update Sent Date to TODAY()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>Status__c</field>
        <literalValue>Visit Completed</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Username_who_locked_the_Visit</fullName>
        <field>Visit_Mode_Locked_By__c</field>
        <formula>$User.Username</formula>
        <name>Update the Username who locked the Visit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Closed%2FCancellation Date</fullName>
        <actions>
            <name>Closed_Cancellation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Inspection__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Create Visit - Set Address</fullName>
        <actions>
            <name>Set_Address_2_of_Visit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Address_of_Visit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_City_of_Visit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Zip_Code_of_Visit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Inspection__c.Address_1__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection__c.City__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set address to provider address when the visit is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Create Visit - Set Default Number of Days to Receive Response</fullName>
        <actions>
            <name>Update_No_Days_to_Receive_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Default Number of Days to Receive Response to value from Config when the visit is created</description>
        <formula>OR(  TEXT(Number_of_days_to_receive_response__c) = &quot;&quot;, ISNULL(Number_of_days_to_receive_response__c), ISBLANK(Number_of_days_to_receive_response__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Create Visit - Set Email Alert Main Recipient</fullName>
        <actions>
            <name>Set_Alert_Main_Recipient_with_Prov_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Inspection__c.Email_Alert_Main_Recipient__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set Email Alert Main Recipient to provider email address when the visit is created</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date of Visit Entered</fullName>
        <actions>
            <name>Notification_to_Pro</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_sent_Notification_to_Provider_that_a_visit_has_been_scheduled</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(Date_of_Visit__c)),ISNULL(PRIORVALUE(Date_of_Visit__c)), Date_of_Visit__c &gt; TODAY(), Announced__c, Mater_Visit_for_Res_Cluster_of_Visits__c=&quot;&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date of Visit Updated</fullName>
        <actions>
            <name>Notification_to_Provider_for_updated_scheduled_Visit</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_sent_Notification_to_Provider_that_a_visit_has_been_re_scheduled</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND(!ISNULL(PRIORVALUE(Date_of_Visit__c)), OR(ISCHANGED(Date_of_Visit__c), ISCHANGED(Time_of_visit__c)), Date_of_Visit__c &gt; TODAY(), Announced__c, ISBLANK( Mater_Visit_for_Res_Cluster_of_Visits__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Date of Visit in 3 days</fullName>
        <active>true</active>
        <formula>AND( Announced_Visit_Remainder__c=TRUE, ISBLANK( Mater_Visit_for_Res_Cluster_of_Visits__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notification_to_Provider_for_scheduled_Visit_in_3_days</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Uncheck_Remainder</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Email_sent_Reminder_to_Provider_that_a_visit_has_been_scheduled</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Inspection__c.Date_of_Visit__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>If Visit Mode Lock %3D False%2C Clear Username in Visit Mode Locked By</fullName>
        <actions>
            <name>Clear_username_in_Visit_Mode_Locked_By</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Inspection__c.Visit_Mode_Lock__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection__c.Visit_Mode_Locked_By__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>If Visit Mode Lock %3D True%2C Update Username in Visit Mode Locked By</fullName>
        <actions>
            <name>Update_the_Username_who_locked_the_Visit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Inspection__c.Visit_Mode_Lock__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection__c.Visit_Mode_Locked_By__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Not Closed%2FCancellation Date</fullName>
        <actions>
            <name>Nullify_Cancellation_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nullify_Cancellation_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Inspection__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Assigned To Manager Email</fullName>
        <actions>
            <name>UpdateVisitManagerEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow updates the Manager email field on the Visit object</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Last Mid Cycle Review Date</fullName>
        <actions>
            <name>Update_Last_Mid_Cycle_Review_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Inspection__c.Type_of_Visit__c</field>
            <operation>equals</operation>
            <value>Enhanced Monitoring</value>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection__c.Date_of_Visit__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection__c.Status__c</field>
            <operation>equals</operation>
            <value>Visit Completed,Closed</value>
        </criteriaItems>
        <description>Updates Last Mid Cycle Review Date from Date of Visit on Provider when a qualifying Visit is completed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Scheduled Visit</fullName>
        <actions>
            <name>Update_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the status to &quot;Visit Completed&quot; if the status is Scheduled</description>
        <formula>AND(  Number_of_visit_items__c&gt;0, Number_of_items_to_assess__c = 0,  OR( ISPICKVAL(Status__c, &apos;Scheduled&apos;), ISPICKVAL(Status__c, &apos;To be scheduled&apos;))  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Visit Update Next Renewal Visit</fullName>
        <actions>
            <name>Update_Provider_Next_FCC_Renewal_Visit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update the Next FCC Renewal Visit when the visit status has switched to closed.</description>
        <formula>TEXT(Status__c) = &apos;Closed&apos; &amp;&amp; (TEXT(Licensing_Transaction__r.Provider__r.Next_FCC_Renewal_Visit__c) = TEXT(Type_of_Visit__c)) || (ISNULL(TEXT(Licensing_Transaction__r.Provider__r.Next_FCC_Renewal_Visit__c)) &amp;&amp; CONTAINS(TEXT(Type_of_Visit__c), &apos;Renewal&apos;)) &amp;&amp; LOWER(RecordType.DeveloperName) = &apos;fcc licensing visit&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Email_sent_Notification_to_Provider_that_a_visit_has_been_re_scheduled</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Notification to Provider that a visit has been re-scheduled</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Notification_to_Provider_that_a_visit_has_been_scheduled</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Notification to Provider that a visit has been scheduled</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Reminder_to_Provider_that_a_visit_has_been_scheduled</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Inspection__c.Date_of_Visit__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Reminder to Provider that a visit has been scheduled</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_visit_Announced</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-10</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Inspection__c.Estimated_Deadline__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schedule visit</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_visit_UnAnnounced</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>-10</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Inspection__c.Estimated_Deadline__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schedule visit</subject>
    </tasks>
</Workflow>
