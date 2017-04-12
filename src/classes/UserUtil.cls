public with sharing class UserUtil { 

    public static ID updateUserContact(ID id,String Salutation, String Title, String firstName, String lastName, String street, String city, String state, String country, String postalCode, String phone, String companyUrl, String email){
        User u = [SELECT ID, ContactId FROM User WHERE ID = :id];
        Contact c = [SELECT ID FROM Contact WHERE ID = :u.ContactId];
        
        c.Title = Title;
        c.Salutation = Salutation;
        c.FirstName = u.FirstName = firstName;
        c.LastName = u.LastName = lastName;
        c.MailingCity = u.City = city;
        c.MailingState = u.State = state;
        c.MailingCountry = u.Country = country;
        c.MailingPostalCode = u.PostalCode = postalCode;
        c.MailingStreet = u.Street = street;
        c.Phone =  phone;
        u.Phone =  phone;
        
        if(companyURL != null){
          //c.Company_Url__c = companyUrl;
        } 
        
        if(email != null){
          u.Email = email;
          System.debug(email);
          UserUtil.updateUsername(u.Id, email);
        }
        update u; 
        update c;
          
        return u.Id;
    }
    
    public static ID updateUserContact(ID id,String Salutation, String Title, String firstName, String lastName, String street, String city, String state, String country, String postalCode, String phone, String companyUrl, String email, 
                                       String otherStreet, String otherCity, String otherState, String otherPostalCode, String homePhone, String fax, String department, String extension) {
        User u = [SELECT ID, ContactId FROM User WHERE ID = :id];
        Contact c = [SELECT ID FROM Contact WHERE ID = :u.ContactId];
        
        c.Title = Title;
        c.Salutation = Salutation;
        c.FirstName = u.FirstName = firstName;
        c.LastName = u.LastName = lastName;
        c.MailingCity = u.City = city;
        c.MailingState = u.State = state;
        c.MailingCountry = u.Country = country;
        c.MailingPostalCode = u.PostalCode = postalCode;
        c.MailingStreet = u.Street = street;
        c.Phone =  phone;
        c.OtherStreet = otherStreet;
        c.OtherCity = otherCity;
        c.OtherPostalCode = otherPostalCode;
        c.OtherState = otherState;
        c.HomePhone = homePhone;
        c.Fax = fax;
        c.Department = department;
        c.Extension__c = extension;
        u.Phone =  phone;
        u.Department = department;
        u.Fax = fax;
        
        if(companyURL != null){
          //c.Company_Url__c = companyUrl;
        } 
        
        if(email != null){
          u.Email = email;
          System.debug(email);
          UserUtil.updateUsername(u.Id, email);
        }
        update u; 
        update c;
          
        return u.Id;
    }
    
    @Future
    public static void updateUsername(ID id, String username){
    
        //User u = [SELECT ID, ContactId FROM User WHERE ID = :id];
        //u.Username = username;
        //update u;
    }
    
}