public with sharing class Portal_Util {

   // Utility class for Portal, common shared methods for Users/Contacts/Accounts/etc
   
   public static Account fetchAccount(Id UserId) {  // Return the Account associated with the given User Id
      System.debug('----> [Fetch Account] User ID: ' + UserId);
      Account a = [SELECT Id, Name, Recordtype.Name, Phone, Region_Phone__c, OwnerId, Licensor_Full_Name__c, Licensor_Phone__c, Is_R_P__c, Is_GSA__c FROM Account WHERE Id IN (SELECT AccountId FROM User WHERE Id =: UserId) LIMIT 1];
      System.debug('----> [Fetch Account] Account: ' + a);
      if (a == NULL) { return NULL; }
      else { return a; }
   }
   
   public static Account fetchAccountByAccID(Id accId) { 
      Account a = [SELECT Id, Name, Recordtype.Name, Phone, Region_Phone__c, OwnerId, Licensor_Full_Name__c, Licensor_Phone__c, Is_R_P__c, Is_GSA__c FROM Account WHERE Id =: accId];
      System.debug('----> [Fetch Account] Account: ' + a);
      if (a == NULL) { return NULL; }
      else { return a; }
   } 
   public static Contact fetchContactByAccID(Id accId) { 
      Contact[] ct = [SELECT Id,Name,Phone,Email FROM Contact WHERE Contact.AccountId =: accId LIMIT 1];
      System.debug('----> [Fetch Contact] Contact: ' + ct);
      if (ct.size() == 0) { return NULL; }
      else { return ct[0]; }
   }  
   
   public static Contact fetchContact(Id UserId) {  // Return the Contact associated with the given User Id
      System.debug('----> [Fetch Contact] User ID: ' + UserId);
      Contact ct = [SELECT Id,Name,Phone,Email FROM Contact WHERE Id IN (SELECT ContactId FROM User WHERE Id = :UserId) LIMIT 1];
      System.debug('----> [Fetch Contact] Contact: ' + ct);
      if (ct == NULL) { return NULL; }
      else { return ct; }
   }
 
   public class InvolvedPerson_Wrapper {
        public Id PersonId {get; set;}
        public String Name {get; set;}
        public String Type {get; set;}
        public String TypeName {get;set;}
        //public String Age {get; set;}
        public String Role {get; set;}
        public String OtherRole {get; set;}
        public String Title {get; set;}
        public String Status_of_Staff {get; set;}
        public String Description_of_Involvement {get; set;}
        public String ChildBirthDate {get;set;}
        public String GuardianAddress {get;set;}
        public String GuardianName {get;set;}  
        public String GuardianPhone {get;set;}   
   }
   
   // To convert from wrappers to Involved Person Custom Object
   public static List<Involved_Persons__c> fromWrapper(Id CaseId, List<InvolvedPerson_Wrapper> wrappers,Map<String,Id> RecordTypeMap) {
      List<Involved_Persons__c> output = new List<Involved_Persons__c>();
      for (InvolvedPerson_Wrapper p : wrappers) {
         System.debug('------> InvolvedPersonWrapper: ' + p); 
         //Integer ageInt = !String.isBlank(p.Age) ? Integer.valueOf(p.Age) : null; 
          
         Involved_Persons__c co = new Involved_Persons__c();
         co.Involved_In__c = CaseId;
         if (p.PersonId != NULL) { co.Id = p.PersonId; } 
         if (p.Name != NULL) { co.Name = p.Name; }
         if (p.Type != NULL) { co.RecordTypeId = RecordTypeMap.get(p.Type); }
         /*if (p.Age != null && ageInt > 0) { 
             co.Age__c = ageInt;
         } else {
             co.Age__c = null;
         }*/
         if (p.Role != NULL) { co.Role__c = p.Role; }
         if (p.OtherRole != NULL) { co.Other_Role__c = p.OtherRole; }
         if (p.Title != NULL) { co.Title__c = p.Title; }
         if (p.Status_of_Staff != NULL) { co.Status_of_Staff__c = p.Status_of_Staff; }
         if (p.Description_of_Involvement != NULL) { co.Description_of_involvement__c = p.Description_of_Involvement; }
         if (p.ChildBirthDate != NULL && p.ChildBirthDate != '') { 
             co.Child_birth_date__c = Date.parse(p.ChildBirthDate);
         }
         if (p.GuardianAddress  != NULL) { co.Parent_Guardian_Address__c = p.GuardianAddress ;}
         if (p.GuardianName  != NULL) { co.Parent_Guardian_Name__c = p.GuardianName ;}
         if (p.GuardianPhone  != NULL) { co.Parent_Guardian_Telephone_Number__c = p.GuardianPhone ;}                                

         output.add(co);
      }  // end for
      return output;
   }
   
   // Retrieve a list of Involved Persons using CaseId and return as wrappers
   public static List<InvolvedPerson_Wrapper> fetchInvolvedPersons(Id CaseId, Map<Id, String> RecordTypeMap) {
      List<InvolvedPerson_Wrapper> wrapper_list = new List<InvolvedPerson_Wrapper>();
      for (Involved_Persons__c ip : [SELECT Id,Name,RecordTypeId,RecordType.Name,Age__c,Role__c,
                                     Other_Role__c,Title__c,Status_of_Staff__c,Description_of_involvement__c,
                                     Child_birth_date__c,Parent_Guardian_Address__c,Parent_Guardian_Name__c,
                                     Parent_Guardian_Telephone_Number__c
                                     FROM Involved_Persons__c WHERE Involved_In__c =: CaseId]) {
         System.debug('-----> RecordTypeMap: ' + RecordTypeMap);
         InvolvedPerson_Wrapper w = new InvolvedPerson_Wrapper();
         if (ip.Id != NULL) { w.PersonId = ip.Id; }
         if (ip.Name != NULL) { w.Name = ip.Name; }
         if (ip.RecordTypeId != NULL) { w.Type = RecordTypeMap.get(ip.RecordTypeId); }
         if (ip.RecordType.Name != NULL) { w.TypeName = ip.RecordType.Name; }
         //if (ip.Age__c != NULL) { w.Age = ip.Age__c != null ? String.valueOf(ip.Age__c) : null; }
         if (ip.Role__c != NULL) { w.Role = ip.Role__c; }
         if (ip.Other_Role__c != NULL) { w.OtherRole = ip.Other_Role__c; }
         if (ip.Title__c != NULL) { w.Title = ip.Title__c; }
         if (ip.Status_of_Staff__c != NULL) { w.Status_of_Staff = ip.Status_of_Staff__c; }
         if (ip.Description_of_involvement__c != NULL) { w.Description_of_Involvement = ip.Description_of_involvement__c; }
         if (ip.Child_birth_date__c != NULL) { w.ChildBirthDate = ip.Child_birth_date__c.format();}
         if (ip.Parent_Guardian_Address__c  != NULL) { w.GuardianAddress = ip.Parent_Guardian_Address__c ;}
         if (ip.Parent_Guardian_Name__c  != NULL) { w.GuardianName = ip.Parent_Guardian_Name__c ;}
         if (ip.Parent_Guardian_Telephone_Number__c  != NULL) { w.GuardianPhone = ip.Parent_Guardian_Telephone_Number__c ;}                                
         wrapper_list.add(w);
      }  // end for loop
      return wrapper_list;
   }
   
   // Delete a list of Involved Persons via wrapper
   public static Boolean deleteInvolvedPersons(List<InvolvedPerson_Wrapper> wrappers) {
      List<Involved_Persons__c> to_delete = new List<Involved_Persons__c>();
      for (InvolvedPerson_Wrapper p : wrappers) {
         Involved_Persons__c ip = new Involved_Persons__c();
         ip.Id = p.PersonId;
         to_delete.add(ip);
      }
      delete to_delete;
      return true;
   }  // end void deleteInvolvedPersons
  
  /**
   * getPicklistValues
   * 
   * This function will return a select option list of picklist values using a passed in object and field name.
   * @author Darkis
   * @param obj SObject The object to grab the picklist values from.
   * @param fld String The field name where the picklist values are stored in the object.
   * @return List<SelectOption> A list of select options for visualforce. 
   */  
  public static list<SelectOption> getPicklistValues(SObject obj, String fld){
    list<SelectOption> options = new list<SelectOption>();
    // Get the object type of the SObject.
    Schema.sObjectType objType = obj.getSObjectType(); 
    // Describe the SObject using its object type.
    Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
    // Get a map of fields for the SObject
    map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
    // Get the list of picklist values for this field.
    list<Schema.PicklistEntry> values =
    fieldMap.get(fld).getDescribe().getPickListValues();
    // Add these values to the selectoption list.
    for (Schema.PicklistEntry a : values) { 
      options.add(new SelectOption(a.getLabel(), a.getValue())); 
    }
    return options;
  }

}