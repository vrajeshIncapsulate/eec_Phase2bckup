<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_sent_to_Investigation_Leader_s_Email</fullName>
        <description>Email sent to Investigation Leader&apos;s Email</description>
        <protected>false</protected>
        <recipients>
            <field>Leader_Email_Workflow__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X41_An_Internal_Investigation_Has_Been_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Ingternal_Investigation_Requested</fullName>
        <description>Ingternal Investigation Requested</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X39_Request_Provider_for_Internal_Investigation</template>
    </alerts>
    <alerts>
        <fullName>Internal_Investigation_Reminder</fullName>
        <description>Internal Investigation Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X40_Internal_Investigation_Request_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Internal_Investigation_has_been_submitted_Notification</fullName>
        <description>Notification to Leader That An Internal Investigation has been submitted</description>
        <protected>false</protected>
        <recipients>
            <field>Investigation_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_Int_Communication_Template_Folder/X41_An_Internal_Investigation_Has_Been_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Leader_Email_Update</fullName>
        <field>Leader_Email_Workflow__c</field>
        <formula>Investigation__r.Assigned_To__r.Email</formula>
        <name>Leader Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>To_Be_Provided_By_Date_Update</fullName>
        <description>Ensure that the To be Provided By Date field has a default value if it has not been entered by the user during record creation</description>
        <field>To_Be_Provided_By__c</field>
        <formula>TODAY() +  Investigation__r.Provider_No__r.Config_Record__r.No_of_Days_For_Internal_Investig_Due_Da__c</formula>
        <name>To Be Provided By Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Investigation_Status</fullName>
        <description>Update the status of the investigation to, &quot;To Submit&quot;</description>
        <field>Status__c</field>
        <literalValue>To Submit</literalValue>
        <name>Update Investigation Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Leader_Info_Email</fullName>
        <description>Update the Leading Investogator&apos;s Email into the intervention record so it can be used in workflows associated with intervention</description>
        <field>Investigation_Leader_Email__c</field>
        <formula>Investigation__r.Leader_Email__c</formula>
        <name>Update Leader Info - Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Leader_Info_Full_Name</fullName>
        <description>Update the first name of the leading investigator</description>
        <field>Investigation_Leader_Full_Name__c</field>
        <formula>Investigation__r.Leader_Name_Text__c</formula>
        <name>Update Leader Info - Full Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Leader_Info_Phone_Nbr</fullName>
        <description>Update the Leading Investogator&apos;s phone # into the intervention record so it can be used in workflows associated with intervention</description>
        <field>Investigation_Leader_Phone_Number__c</field>
        <formula>Investigation__r.Leader_Phone__c</formula>
        <name>Update Leader Info - Phone Nbr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Provider_Email_into_Intervention</fullName>
        <description>Update the Provider&apos;s email into the intervention record so it can be used in workflows associated with intervention</description>
        <field>Provider_Email__c</field>
        <formula>Investigation__r.Provider_No__r.Provider_Email__c</formula>
        <name>Update Provider Email into Intervention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Intervention Actions When Status Changed to Submit Via Portal</fullName>
        <actions>
            <name>Ingternal_Investigation_Requested</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Investigation_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Provider_Email_into_Intervention</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_sent_Internal_Investigation_Requested_39</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>The Intervention workflow actions to trigger when the status of the interevntion record is changed to &quot;Submit via Portal&quot;</description>
        <formula>ISPICKVAL( Status__c, &quot;To Submit via Portal&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Intervention Actions When Status Changes From To Submit to Submitted</fullName>
        <actions>
            <name>Internal_Investigation_has_been_submitted_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Leader_Info_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Leader_Info_Full_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Leader_Info_Phone_Nbr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Interention Actions When Status Changes From To Submit to Submitted and the user who submitted it is a portal user</description>
        <formula>AND ( ISPICKVAL(Status__c, &quot;Submitted&quot;), CONTAINS($Profile.Name, &quot;Community&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Intervention Actions When Status Remains To Submit more than 7 Days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Intervention__c.Status__c</field>
            <operation>equals</operation>
            <value>To Submit</value>
        </criteriaItems>
        <description>The Intervention time based workflow actions to trigger when the status of the intervention remains in To Submit mode for more than 7 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Internal_Investigation_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Internal_Investigation_Request_Reminder_40</name>
                <type>Task</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Intervention To be Provided By Date Field Update</fullName>
        <actions>
            <name>To_Be_Provided_By_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Intervention To be Provided By Date Field Update if the Provide by date has been left bkank</description>
        <formula>AND( RecordType.Name = &quot;Internal Investigation&quot;,  ISBLANK( To_Be_Provided_By__c ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Intervention status changed to %22Submitted%22</fullName>
        <actions>
            <name>Email_sent_to_Investigation_Leader_s_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Leader_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Intervention__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>Defines the actions and rules to executed when a new Intervention has been submitted and or edited and Status is &quot;Submitted&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Request Internal Investigation on Interventions</fullName>
        <active>false</active>
        <description>Request Internal Investigation on Interventions</description>
        <formula>ISPICKVAL( Status__c, &quot;To Submit via Portal&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Email_sent_Internal_Investigation_Request_Reminder_40</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the provider 7 days after first email to remind  that internal investigation must be completed and submitted</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Internal Investigation Request Reminder - #40</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Internal_Investigation_Requested_39</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the provider to inform that an internal investigation is requested and can be uploaded on the portal</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Internal Investigation Requested - #39</subject>
    </tasks>
    <tasks>
        <fullName>Internal_Investigation_Request_Reminder_40</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email sent to the provider 7 days after first email to remind  that internal investigation must be completed and submitted</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Internal Investigation Request Reminder - #40</subject>
    </tasks>
</Workflow>
