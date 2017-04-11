<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Early_Education_and_Child_Care_Department_Submission_Confirmation_Change_of_Addr</fullName>
        <description>Early Education and Child Care Department - Submission Confirmation (Change of Address)</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X47b_Transaction_Electronic_Submission_Confirmation_Address_Change_docx</template>
    </alerts>
    <alerts>
        <fullName>Early_Education_and_Child_Care_Department_Submission_Confirmation_New_License_Re</fullName>
        <description>Early Education and Child Care Department - Submission Confirmation (New License / Renewal / Upgrade)</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X47a_Transaction_Electronic_Submission_Confirmation_New_App_Renewal_Upgrade</template>
    </alerts>
    <alerts>
        <fullName>Early_Education_and_Child_Care_Department_Submission_Confirmation_Other_Transact</fullName>
        <description>Early Education and Child Care Department - Submission Confirmation (Other Transactions)</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X47c_Transaction_Electronic_Submission_Confirmation_Other</template>
    </alerts>
    <alerts>
        <fullName>Email_Licensor_that_a_Licensing_Transaction_Requires_Review</fullName>
        <description>Email Licensor that a Licensing Transaction Requires Review</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_User_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X60_New_Licensing_Transaction_to_Review</template>
    </alerts>
    <alerts>
        <fullName>Email_Provider_to_Notify_14_Days_Has_Passed_Since_Submission_Via_Portal</fullName>
        <description>Email Provider to Notify 14 Days Has Passed Since Submission Via Portal</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_User_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X76_Submitted_Transaction_still_pending_after_14_days</template>
    </alerts>
    <alerts>
        <fullName>FCC_Licensing_Transaction_Processed_Notification_to_Provider</fullName>
        <description>FCC Licensing Transaction Processed - Notification to Provider</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X71_FCC_Transaction_Processed</template>
    </alerts>
    <alerts>
        <fullName>FCC_Transaction_Cancelled_Send_to_Submitter</fullName>
        <description>FCC Transaction Cancelled - Send to Submitter</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X72_FCC_Transaction_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>Licensing_Transaction_60_Day_Provider_Alert_if_Transaction_Still_Under_Review</fullName>
        <description>Licensing Transaction - 60 Day Provider Alert if Transaction Still Under Review</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X64_Notification_to_Provider_60_days_after_transaction_submission</template>
    </alerts>
    <alerts>
        <fullName>Original_request_for_signature_of_BRC_Consent</fullName>
        <description>Original request for signature of BRC Consent</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X67_Request_signature_of_Licensee_BRC_consent</template>
    </alerts>
    <alerts>
        <fullName>Original_request_for_signature_of_Tax_Certification_Statement</fullName>
        <description>Original request for signature of Tax Certification Statement</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X37_Request_signature_of_Tax_Certification</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Email_for_signature_of_Licensee_BRC_Consent</fullName>
        <description>Reminder Email for signature of Licensee BRC Consent</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X68_Signature_of_Licensee_BRC_consent_Pending_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Email_for_signature_of_Tax_Certification_Statement</fullName>
        <description>Reminder Email for signature of Tax Certification Statement</description>
        <protected>false</protected>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X38_Signature_of_Tax_Certification_Pending_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_Investigation_Leader_to_inform_of_the_rejection_Use_template_44</fullName>
        <description>Send email to Transaction Assignee to inform of the rejection - Use template #44</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X44_Licensing_Transaction_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_Transaction_Assigned_To</fullName>
        <description>Send email to Transaction Assigned To</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X43_Licensing_Transaction_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_notification_email_to_Licensing_Transaction_Transaction_Assigned_To_Manager</fullName>
        <description>Send notification email to Licensing_Transaction.Transaction Assigned To.Manager (template #45)</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X45_Licensing_Transaction_Approval_Request_Recalled</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Transaction_Status</fullName>
        <description>Change Transaction Status to &quot;Pending Manager Approval&quot;</description>
        <field>Status__c</field>
        <literalValue>Pending Manager Approval</literalValue>
        <name>Change Transaction Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_reset_to_NULL</fullName>
        <field>Document_Info_Missing_Initial_Date__c</field>
        <name>Date reset to NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fill_Document_Info_Missing_Initial_Date</fullName>
        <description>Fill Document / Information Missing Initial Date with the current date</description>
        <field>Document_Info_Missing_Initial_Date__c</field>
        <formula>TODAY()</formula>
        <name>Fill Document Info Missing Initial Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Licensee_BRC_Status_to_Sent</fullName>
        <field>Licensee_BRC_Consent_Status__c</field>
        <literalValue>Sent</literalValue>
        <name>Licensee BRC Status to &quot;Sent&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Source_to_Portal</fullName>
        <field>Source__c</field>
        <literalValue>Provider Portal</literalValue>
        <name>Set Source to Portal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_flag_Approved_by_Manager_to_FALSE</fullName>
        <field>Approved_by_Manager__c</field>
        <literalValue>0</literalValue>
        <name>Set flag &quot;Approved by Manager&quot; to FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_flag_Approved_by_Manager_to_TRUE</fullName>
        <field>Approved_by_Manager__c</field>
        <literalValue>1</literalValue>
        <name>Set flag &quot;Approved by Manager&quot; to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tax_Certification_Statement_to_Sent</fullName>
        <description>Update Tax Certification Statement Status to &quot;Sent&quot;</description>
        <field>Tax_Certification_Status__c</field>
        <literalValue>Sent</literalValue>
        <name>Tax Certification Statement to &quot;Sent&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assigned_To_Manager_Email</fullName>
        <field>Assigned_To_Manager_Email__c</field>
        <formula>Assigned_To__r.Manager.Email</formula>
        <name>Update Assigned To Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assigned_To_User_Email</fullName>
        <field>Assigned_User_Email__c</field>
        <formula>Assigned_To__r.Email</formula>
        <name>Update Assigned To User Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Consent_Request_Date</fullName>
        <description>Update BRC Consent Request Date to today</description>
        <field>Licensee_BRC_Consent_Request_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update BRC Consent Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Current_Mailing_Address</fullName>
        <field>BRC_Current_Mailing_Address__c</field>
        <formula>IF(ISBLANK(  Provider__r.ShippingStreet ), Provider__r.Provider_Full_Address__c ,  Provider__r.Mailing_Address_Reformated__c  )</formula>
        <name>Update BRC Current Mailing Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_First_Name</fullName>
        <field>BRC_First_Name__c</field>
        <formula>Submitter__r.Contact.FirstName</formula>
        <name>Update BRC First Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Last_Name</fullName>
        <field>BRC_Last_Name__c</field>
        <formula>Submitter__r.Contact.LastName</formula>
        <name>Update BRC Last Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Renewal</fullName>
        <field>BRC_Renewal__c</field>
        <formula>IF( RecordType.Name = &quot;FCC Renewal&quot;, &quot;Yes&quot;, &quot;No&quot;)</formula>
        <name>Update BRC Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved_by_Manager</fullName>
        <description>Update Status to &quot;Approved by Manager&quot;</description>
        <field>Status__c</field>
        <literalValue>Approved By Manager</literalValue>
        <name>Update Status to &quot;Approved by Manager&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Under_Review</fullName>
        <description>Update Status to &quot;Under Review&quot;</description>
        <field>Status__c</field>
        <literalValue>Under Review</literalValue>
        <name>Update Status to &quot;Under Review&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Tax_Cer_Trans_Request_Date</fullName>
        <description>Update Tax Certification Statement Request Date to today</description>
        <field>Tax_Certification_Statement_Request_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Tax Cer Trans Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Doc or Info Missing Initial Date</fullName>
        <actions>
            <name>Fill_Document_Info_Missing_Initial_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the checkbox &quot;Document / Information Missing&quot; is checked, fill &quot;Document / Information Missing Initial Date&quot; with the current date.</description>
        <formula>Document_Information_Missing__c = TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Doc or Info Missing Initial Date NULL</fullName>
        <actions>
            <name>Date_reset_to_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the checkbox &quot;Document / Information Missing&quot; is unchecked, reset &quot;Document / Information Missing&quot; to NULL.</description>
        <formula>Document_Information_Missing__c = FALSE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FCC Request Signature of Licensee BRC Consent</fullName>
        <actions>
            <name>Original_request_for_signature_of_BRC_Consent</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Licensee_BRC_Status_to_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Consent_Request_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Current_Mailing_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_First_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Last_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_BRC_Renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_sent_Request_signature_of_BRC_consent_67</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/n/projects/1275588/stories/94665848</description>
        <formula>AND(  ISPICKVAL( Status__c , &quot;Submitted&quot;),    ISPICKVAL(  Licensee_BRC_Consent_Status__c , &quot;&quot; ),  ISBLANK( Licensee_BRC_Consent_Request_Date__c ),  Provider__r.Electronic_Communication__c = TRUE,  Provider__r.RecordType.Name = &quot;Family Child Care&quot;,  OR( RecordType.Name = &quot;FCC New License&quot;,      RecordType.Name = &quot;FCC Renewal&quot;,      RecordType.Name = &quot;FCC License Upgrade&quot;,      RecordType.Name = &quot;Change of Address&quot;  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FCC Request Signature of Tax Statement</fullName>
        <actions>
            <name>Original_request_for_signature_of_Tax_Certification_Statement</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Tax_Certification_Statement_to_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Tax_Cer_Trans_Request_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_sent_Request_signature_of_Tax_Certification_37</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/story/show/94665860</description>
        <formula>AND(  ISPICKVAL( Status__c , &quot;Submitted&quot;),    ISPICKVAL( Tax_Certification_Status__c, &quot;&quot; ),  ISBLANK(Tax_Certification_Statement_Request_Date__c),  Provider__r.Electronic_Communication__c = TRUE,  OR( RecordType.Name = &quot;FCC New License&quot;,      RecordType.Name = &quot;FCC Renewal&quot;,      RecordType.Name = &quot;FCC License Upgrade&quot;  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FCC Signature of Licensee BRC Consent Reminder</fullName>
        <active>true</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/story/show/94665848</description>
        <formula>AND(  OR(ISPICKVAL( Status__c , &quot;Submitted&quot;),ISPICKVAL( Status__c , &quot;Under Review&quot;)),  NOT(ISPICKVAL( Licensee_BRC_Consent_Status__c, &quot;Completed&quot; )),  Provider__r.Electronic_Communication__c = TRUE,  Provider__r.RecordType.Name = &quot;Family Child Care&quot;,   OR( RecordType.Name = &quot;FCC New License&quot;,      RecordType.Name = &quot;FCC Renewal&quot;,      RecordType.Name = &quot;FCC License Upgrade&quot;,      RecordType.Name = &quot;Change of Address&quot;  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_Email_for_signature_of_Licensee_BRC_Consent</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Signature_of_BRC_Consent_Pending_Reminder_68</name>
                <type>Task</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FCC Signature of Tax Statement Reminder</fullName>
        <active>true</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/story/show/94665860</description>
        <formula>AND(  OR(ISPICKVAL( Status__c , &quot;Submitted&quot;),ISPICKVAL( Status__c , &quot;Under Review&quot;)),  NOT(ISPICKVAL( Tax_Certification_Status__c, &quot;Completed&quot; )),  Provider__r.Electronic_Communication__c = TRUE,  OR( RecordType.Name = &quot;FCC New License&quot;,      RecordType.Name = &quot;FCC Renewal&quot;,      RecordType.Name = &quot;FCC License Upgrade&quot;  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_Email_for_signature_of_Tax_Certification_Statement</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Signature_of_Tax_Certification_Pending_Reminder_38</name>
                <type>Task</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Licensing Transaction 45 Day Alert When Transaction Remains Under Review</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Family Child Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>FCC Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <description>Internal time based follow-up/alerts on Licensing Transaction when it remains in Under Review status beyond the 45 day stipulated allowance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Licensing_Transaction_not_processed_45_days_notice</name>
                <type>Task</type>
            </actions>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Licensing Transaction 60 Day Alert When Transaction Remains Under Review</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Family Child Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>FCC Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <description>Internal time based follow-up/alerts on Licensing Transaction when it remains in Under Review status beyond the 60 day stipulated allowance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Licensing_Transaction_not_processed_60_days_notice</name>
                <type>Task</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Licensing Transaction 60 Day Provider Alert If It Remains Under Review</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Family Child Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>FCC Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Electronic_Communication__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Document_Information_Missing__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Provider email (time based follow-up/alerts) on Licensing Transaction when it remains in Under Review status beyond the 60 day stipulated allowance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Licensing_Transaction_60_Day_Provider_Alert_if_Transaction_Still_Under_Review</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Notification_to_Provider_60_days_after_transaction_submission_64</name>
                <type>Task</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Licensing Transaction 90 Day Alert When Transaction Remains Under Review</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Family Child Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>FCC Renewal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <description>Internal time based follow-up/alerts on Licensing Transaction when it remains in Under Review status beyond the 90 day stipulated allowance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Licensing_Transaction_not_processed_90_days_notice</name>
                <type>Task</type>
            </actions>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Licensing Transaction Via Portal Pending 14 Days after Submittng</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Source__c</field>
            <operation>equals</operation>
            <value>Provider Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Electronic_Communication__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Family Child Care</value>
        </criteriaItems>
        <description>Licensing Transaction Via Portal Pending 14 Days after Submittng</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Provider_to_Notify_14_Days_Has_Passed_Since_Submission_Via_Portal</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Submitted_Transaction_still_pending_after_14_days_76</name>
                <type>Task</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Schedule followup task for Assigned User if Visit Not Scheduled in 15 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Licensing_Transaction__c.To_Schedule_Visit__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Licensing_Transaction__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <description>Schedule followup task for Assigned User if Visit Not Scheduled in 15 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Licensing_Transaction_without_scheduled_visit_15_days_notice</name>
                <type>Task</type>
            </actions>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Source to %22Web%22 when created by portal user</fullName>
        <actions>
            <name>Set_Source_to_Portal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>CONTAINS( CreatedBy.Profile.Name , &quot;Community&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Licensing Transaction Email Addresses</fullName>
        <actions>
            <name>Update_Assigned_To_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Assigned_To_User_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow update the assigned to email address and manager email address used to send emails.</description>
        <formula>NOT(ISBLANK(Assigned_To__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Close_transaction_after_manager_approval_and_issue_license_if_required</fullName>
        <assignedTo>eecleaddonotreply@state.ma.us</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Close transaction after manager approval (and issue license if required)</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Notification_to_Provider_60_days_after_transaction_submission_64</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the Provider 60 days after submission if the status is still pending and there are some missing documents</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Notification to Provider 60 days after transaction submission - #64</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Request_signature_of_BRC_consent_67</fullName>
        <assignedToType>owner</assignedToType>
        <description>Once a license transaction requiring signature of BRC Consent is received, this email is sent to require the licensee to sign a BRC Consent.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Request signature of BRC consent - #67</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Request_signature_of_Tax_Certification_37</fullName>
        <assignedToType>owner</assignedToType>
        <description>Once a license transaction requiring signature of Tax Certification Statement is received, this email is sent to require the licensee to sign a Tax Certification Statement.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Request signature of Tax Certification - #37</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Signature_of_BRC_Consent_Pending_Reminder_68</fullName>
        <assignedToType>owner</assignedToType>
        <description>If a BRC Consent is pending for more than 5 days, then this email is sent to remind the user that the document is pending</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Signature of BRC Consent Pending Reminder - #68</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Signature_of_Tax_Certification_Pending_Reminder_38</fullName>
        <assignedToType>owner</assignedToType>
        <description>If a tax certification statement is pending for more than 5 days, then this email is sent to remind the user that the document is pending</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Signature of Tax Certification Pending Reminder - #38</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Submitted_Transaction_still_pending_after_14_days_76</fullName>
        <assignedToType>owner</assignedToType>
        <description>If a transaction is submitted but remain in status &quot;Submitted&quot; for more than 14 days, this email is sent to the provider to request him/her to send the payment of the fee or sign the BRC Consent / Tax Certificate</description>
        <dueDateOffset>14</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Submitted Transaction still pending after 14 days - #76</subject>
    </tasks>
    <tasks>
        <fullName>New_Licensing_Transaction_not_processed_45_days_notice</fullName>
        <assignedToType>owner</assignedToType>
        <description>This transaction has been &quot;Under Review&quot; for 45 days and need to be checked</description>
        <dueDateOffset>48</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Licensing Transaction not processed - 45 days notice</subject>
    </tasks>
    <tasks>
        <fullName>New_Licensing_Transaction_not_processed_60_days_notice</fullName>
        <assignedToType>owner</assignedToType>
        <description>This transaction has been &quot;Under Review&quot; for 60 days and need to be checked</description>
        <dueDateOffset>63</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Licensing Transaction not processed - 60 days notice</subject>
    </tasks>
    <tasks>
        <fullName>New_Licensing_Transaction_not_processed_90_days_notice</fullName>
        <assignedToType>owner</assignedToType>
        <description>This transaction has been &quot;Under Review&quot; for 90 days and need to be checked</description>
        <dueDateOffset>93</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Licensing Transaction not processed - 90 days notice</subject>
    </tasks>
    <tasks>
        <fullName>New_Licensing_Transaction_without_scheduled_visit_15_days_notice</fullName>
        <assignedToType>owner</assignedToType>
        <description>This transaction still does not have an attached visit &quot;Scheduled&quot;. Please schedule a visit with this provider.</description>
        <dueDateOffset>18</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Licensing Transaction without scheduled visit - 15 days notice</subject>
    </tasks>
    <tasks>
        <fullName>Re_work_required_on_licensing_transaction_following_review_by_manager_and_reject</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Re-work required on licensing transaction following review by manager and rejection</subject>
    </tasks>
</Workflow>
