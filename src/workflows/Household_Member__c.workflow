<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_To_Request_Individual_BRC_Consent_Signature</fullName>
        <description>Email To Request Individual BRC Consent Signature (&gt;= 18 yo)</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X69_Request_signature_of_Household_Member_BRC_consent</template>
    </alerts>
    <alerts>
        <fullName>Email_To_Request_Individual_BRC_Consent_Signature_18_yo</fullName>
        <description>Email To Request Individual BRC Consent Signature (&lt; 18 yo)</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X69b_Request_signature_of_Household_Member_BRC_consent_18</template>
    </alerts>
    <alerts>
        <fullName>Original_request_for_signature_of_BRC_Consent</fullName>
        <description>Original request for signature of Individual BRC Consent</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X69_Request_signature_of_Household_Member_BRC_consent</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Email_for_signature_of_Individual_BRC_Consent</fullName>
        <description>Reminder Email for signature of Individual BRC Consent (&gt;= 18 yo)</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X70_Signature_of_Household_Member_BRC_consent_Pending_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Email_for_signature_of_Individual_BRC_Consent_18_yo</fullName>
        <description>Reminder Email for signature of Individual BRC Consent (&lt; 18 yo)</description>
        <protected>false</protected>
        <recipients>
            <field>Provider_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>eecleaddonotreply@state.ma.us</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EEC_External_CommunicatioTemplate_Folder/X70b_Signature_of_Household_Member_BRC_consent_Pending_Reminder_18_yo</template>
    </alerts>
    <fieldUpdates>
        <fullName>Licensee_BRC_Status_to_Sent</fullName>
        <field>BRC_Consent_Status__c</field>
        <literalValue>Sent</literalValue>
        <name>Licensee BRC Status to &quot;Sent&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Consent_Request_Date</fullName>
        <field>BRC_Consent_Request_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update BRC Consent Request Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Current_Mailing_Address</fullName>
        <field>BRC_Current_Mailing_Address__c</field>
        <formula>IF(ISBLANK(   
Licensing_Transactions__r.Provider__r.ShippingStreet ), Licensing_Transactions__r.Provider__r.Provider_Full_Address__c , Licensing_Transactions__r.Provider__r.Mailing_Address_Reformated__c )</formula>
        <name>Update BRC Current Mailing Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BRC_Renewal</fullName>
        <field>BRC_Renewal__c</field>
        <formula>IF(  Licensing_Transactions__r.RecordType.Name = &quot;FCC Renewal&quot;, &quot;Yes&quot;, &quot;No&quot;)</formula>
        <name>Update BRC Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FCC Request Signature of Individual BRC Consent</fullName>
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
            <name>Update_BRC_Renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_sent_Request_signature_of_Household_Member_BRC_consent_69</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/story/show/98100140</description>
        <formula>AND( BRC_Required__c = TRUE, ISPICKVAL(  Licensing_Transactions__r.Status__c , &quot;Submitted&quot;),  ISPICKVAL(  BRC_Consent_Status__c  , &quot;&quot; ),  ISBLANK(  BRC_Consent_Request_Date__c  ),   Licensing_Transactions__r.Provider__r.Electronic_Communication__c = TRUE,  Licensing_Transactions__r.Provider__r.RecordType.Name = &quot;Family Child Care&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FCC Request Signature of Individual BRC Consent %28age %3C 18%29</fullName>
        <actions>
            <name>Update_BRC_Current_Mailing_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is the implementation of https://incapsulate.atlassian.net/browse/LEAD-1050</description>
        <formula>AND(  BRC_Required__c = TRUE,  ISPICKVAL(  Licensing_Transactions__r.Status__c , &quot;Submitted&quot;),   ISPICKVAL(  BRC_Consent_Status__c  , &quot;&quot; ),   ISBLANK(  BRC_Consent_Request_Date__c  ),    Licensing_Transactions__r.Provider__r.Electronic_Communication__c = TRUE,   Licensing_Transactions__r.Provider__r.RecordType.Name = &quot;Family Child Care&quot;,   Age_At_Submission__c &lt;18 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_To_Request_Individual_BRC_Consent_Signature_18_yo</name>
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
                <name>Update_BRC_Renewal</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Email_sent_Request_signature_of_Household_Member_BRC_consent_18yo_69b</name>
                <type>Task</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FCC Request Signature of Individual BRC Consent %28age %3E%3D18%29</fullName>
        <actions>
            <name>Update_BRC_Current_Mailing_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/story/show/98100140 and the update https://incapsulate.atlassian.net/browse/LEAD-1050</description>
        <formula>AND( BRC_Required__c = TRUE, ISPICKVAL(  Licensing_Transactions__r.Status__c , &quot;Submitted&quot;),  ISPICKVAL(  BRC_Consent_Status__c  , &quot;&quot; ),  ISBLANK(  BRC_Consent_Request_Date__c  ),   Licensing_Transactions__r.Provider__r.Electronic_Communication__c = TRUE,  Licensing_Transactions__r.Provider__r.RecordType.Name = &quot;Family Child Care&quot;,  Age_At_Submission__c &gt;= 18 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_To_Request_Individual_BRC_Consent_Signature</name>
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
                <name>Update_BRC_Renewal</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Email_sent_Reques_signature_of_Household_Member_BRC_consent_69</name>
                <type>Task</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FCC Signature of Individual BRC Consent Reminder</fullName>
        <active>false</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/story/show/98100140</description>
        <formula>AND( BRC_Required__c = TRUE,  OR(ISPICKVAL( Licensing_Transactions__r.Status__c , &quot;Submitted&quot;),ISPICKVAL( Licensing_Transactions__r.Status__c , &quot;Under Review&quot;)), NOT(ISPICKVAL( BRC_Consent_Status__c, &quot;Completed&quot; )), Licensing_Transactions__r.Provider__r.Electronic_Communication__c = TRUE,  Licensing_Transactions__r.Provider__r.RecordType.Name = &quot;Family Child Care&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_Email_for_signature_of_Individual_BRC_Consent</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Signature_of_Household_Member_BRC_consent_Pending_Reminder_70</name>
                <type>Task</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FCC Signature of Individual BRC Consent Reminder %28age %3C 18%29</fullName>
        <active>true</active>
        <description>This workflow is the implementation of https://incapsulate.atlassian.net/browse/LEAD-1050</description>
        <formula>AND( BRC_Required__c = TRUE,  OR(ISPICKVAL( Licensing_Transactions__r.Status__c , &quot;Submitted&quot;),ISPICKVAL( Licensing_Transactions__r.Status__c , &quot;Under Review&quot;)), NOT(ISPICKVAL( BRC_Consent_Status__c, &quot;Completed&quot; )), Licensing_Transactions__r.Provider__r.Electronic_Communication__c = TRUE,  Licensing_Transactions__r.Provider__r.RecordType.Name = &quot;Family Child Care&quot;, Age_At_Submission__c &lt; 18  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_Email_for_signature_of_Individual_BRC_Consent_18_yo</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Signature_of_Household_Member_BRC_consent_Pending_Reminder_18_yo_70b</name>
                <type>Task</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FCC Signature of Individual BRC Consent Reminder %28age %3E%3D 18%29</fullName>
        <active>true</active>
        <description>This workflow is the implementation of https://www.pivotaltracker.com/story/show/98100140</description>
        <formula>AND( BRC_Required__c = TRUE,  OR(ISPICKVAL( Licensing_Transactions__r.Status__c , &quot;Submitted&quot;),ISPICKVAL( Licensing_Transactions__r.Status__c , &quot;Under Review&quot;)), NOT(ISPICKVAL( BRC_Consent_Status__c, &quot;Completed&quot; )), Licensing_Transactions__r.Provider__r.Electronic_Communication__c = TRUE,  Licensing_Transactions__r.Provider__r.RecordType.Name = &quot;Family Child Care&quot;, Age_At_Submission__c &gt;= 18  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_Email_for_signature_of_Individual_BRC_Consent</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_sent_Signature_of_Household_Member_BRC_consent_Pending_Reminder_70</name>
                <type>Task</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Email_sent_Reques_signature_of_Household_Member_BRC_consent_69</fullName>
        <assignedToType>owner</assignedToType>
        <description>Once a licensing transaction requiring signature of BRC Consent by one of the household member is submitted, this email is sent to require the household member / person on premise to sign a BRC consent.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Request signature of Household Member BRC consent (&gt;=18yo) - #69a</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Request_signature_of_Household_Member_BRC_consent_18yo_69b</fullName>
        <assignedToType>owner</assignedToType>
        <description>Once a licensing transaction requiring signature of BRC Consent by one of the household member is submitted, this email is sent to require the household member / person on premise to sign a BRC consent.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Request signature of Household Member BRC consent (&lt;18yo) - #69b</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Request_signature_of_Household_Member_BRC_consent_69</fullName>
        <assignedToType>owner</assignedToType>
        <description>Once a licensing transaction requiring signature of BRC Consent by one of the household member is submitted, this email is sent to require the household member / person on premise to sign a BRC consent.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Request signature of Household Member BRC consent - #69</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Signature_of_Household_Member_BRC_consent_Pending_Reminder_18_yo_70b</fullName>
        <assignedToType>owner</assignedToType>
        <description>If a household member / individual on premise BRC consent is pending for more than 5 days, then this email is sent to remind the user that the document is pending</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Signature of Household Member BRC consent Pending Reminder (&lt;18 yo) - #70b</subject>
    </tasks>
    <tasks>
        <fullName>Email_sent_Signature_of_Household_Member_BRC_consent_Pending_Reminder_70</fullName>
        <assignedToType>owner</assignedToType>
        <description>If a household member / individual on premise BRC consent is pending for more than 5 days, then this email is sent to remind the user that the document is pending</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email sent - Signature of Household Member BRC consent Pending Reminder (&gt;=18 yo) - #70a</subject>
    </tasks>
</Workflow>
