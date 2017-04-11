<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>License_Status_Update_to_Unlicensed</fullName>
        <description>License Status Update to &quot;Not Licensed&quot;</description>
        <field>License_Status__c</field>
        <literalValue>Not Licensed</literalValue>
        <name>License Status Update to &quot;Not Licensed&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Provider_Email_equal_Email</fullName>
        <description>Provider email = Email</description>
        <field>Provider_Email__c</field>
        <formula>Email</formula>
        <name>Provider Email equal Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>State_MA</fullName>
        <field>State__c</field>
        <literalValue>MA</literalValue>
        <name>State MA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Provider_Name_on_Prospect_record</fullName>
        <description>Update provider name with First Name + Last Name</description>
        <field>Company</field>
        <formula>FirstName &amp; &quot; &quot; &amp; LastName</formula>
        <name>Update Prov Name on Potential Provider</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FCC Potential Provider Creation and Update</fullName>
        <actions>
            <name>License_Status_Update_to_Unlicensed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>State_MA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Provider_Name_on_Prospect_record</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>FCC Potential Provider</value>
        </criteriaItems>
        <description>Update &quot;License Status&quot; to &quot;Unlicensed&quot; and update Provider Name with First / Last name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Record type FCC Prospect Provider Email</fullName>
        <actions>
            <name>Provider_Email_equal_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Record type = &quot;FCC Prospect&quot;, each time Email address is updated, update &quot;Provider Email&quot; = &quot;Email&quot;</description>
        <formula>RecordTypeId = &quot;012110000000ksN&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Provider Email with Lead Email</fullName>
        <actions>
            <name>Provider_Email_equal_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Each time Email address is updated, update &quot;Provider Email&quot; = &quot;Email&quot;</description>
        <formula>RecordType.Name = &quot;FCC Potential Provider&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
