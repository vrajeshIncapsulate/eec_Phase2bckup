<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NO_Investigation_Send_email_to_Provider_informing_them_that_Corrective_Action_is</fullName>
        <description>(NO Investigation) Send email to Provider informing them that Corrective Action is rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X87_Notification_to_Provider_after_Corrective_Plan_rejected_visit</template>
    </alerts>
    <alerts>
        <fullName>w_Investigation_With_Send_email_to_Provider_informing_them_that_Corrective_Actio</fullName>
        <description>(w / Investigation) With Send email to Provider informing them that Corrective Action is rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X88a_Notification_to_Provider_after_Corrective_Plan_rejected_visit_item_from_i</template>
    </alerts>
    <fieldUpdates>
        <fullName>Create_History_Record_flag</fullName>
        <description>Update flag to true</description>
        <field>Create_History_Record_flag__c</field>
        <literalValue>1</literalValue>
        <name>Update Create History Record flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Visit_Accessed_Date_to_Today</fullName>
        <field>Assessed_Date__c</field>
        <formula>Now()</formula>
        <name>Set Visit Accessed Date to Today()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Corrective_Actions_Submitter</fullName>
        <description>Update &quot;Corrective Actions Submitter&quot; with First / Last name of the user who did the update</description>
        <field>Corrective_Actions_Submitter__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp;  $User.LastName</formula>
        <name>Update Corrective Actions Submitter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Corrective_Actions_Received</fullName>
        <description>Update &quot;Date Corrective Actions Received&quot; with Today</description>
        <field>Date_Corrective_Actions_Received__c</field>
        <formula>Today()</formula>
        <name>Update &quot;Date Corrective Actions Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Prov_Email_Address_Visit_Item</fullName>
        <description>Update Provider Email Address of Visit Item record with associated Provider email address</description>
        <field>Provider_Email_Address__c</field>
        <formula>Inspection_No__r.Provider_No__r.Provider_Email__c</formula>
        <name>Update Prov. Email Address (Visit Item)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_of_Visit</fullName>
        <description>Update the status of a visit to &quot;Feedback received, to review&quot; as part of the workflow to update status</description>
        <field>Status__c</field>
        <literalValue>Feedback received, to review</literalValue>
        <name>Update Status after Corr Action Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Inspection_No__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_To_review_on_portal_to_False</fullName>
        <description>Update &quot;To review on portal&quot; to False</description>
        <field>To_Review_on_Portal__c</field>
        <literalValue>0</literalValue>
        <name>Update &quot;To review on portal&quot; to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Provider Email Address %28visit item%29</fullName>
        <actions>
            <name>Update_Prov_Email_Address_Visit_Item</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the provider email address of the visit item with the information from the provider.</description>
        <formula>Provider_Email_Address__c != Inspection_No__r.Provider_No__r.Provider_Email__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Status after Corr Action Received</fullName>
        <actions>
            <name>Update_Status_of_Visit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Inspection_Item__c.Date_Implemented__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection__c.Status__c</field>
            <operation>equals</operation>
            <value>&quot;Report Sent to Provider, Awaiting feedback&quot;</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Visit Item Correction Plan Change</fullName>
        <actions>
            <name>Create_History_Record_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Corrective_Actions_Submitter</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Date_Corrective_Actions_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_To_review_on_portal_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Correction Plan is changed from empty to a value then:
    - Update &quot;Date Corrective Actions Received&quot; with Today
    - Update &quot;Corrective Actions Submitter&quot; with user who did the update
    - Update &quot;To review on portal&quot; to False</description>
        <formula>AND(   ISCHANGED( Correction_Plan__c ),   NOT( ISBLANK( Correction_Plan__c ))   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Visit Item Result change to update Access Date</fullName>
        <actions>
            <name>Set_Visit_Accessed_Date_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Inspection_Item__c.Inspection_Result__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Inspection_Item__c.Assessed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Need to record the date/time a visit item was assessed, so that we can report on it</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
