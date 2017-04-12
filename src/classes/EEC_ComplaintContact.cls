public class EEC_ComplaintContact {

    public Id id { get; set; }
    public String FirstName { get; set; }
    public String LastName { get; set; }
    public String MailingStreet{get; set;}
    public String MailingCity{ get; set; }
    public String MailingState{ get; set; }
    public String MailingPostalCode{ get; set; }
    public String HomePhone{ get; set; }
    public String MobilePhone{ get; set; }
    public String Phone{ get; set; }
    public String Email{ get; set; }
  
    public static EEC_ComplaintContact fromContact(Id contactId) {
        List<Contact> contacts = [SELECT ID, FirstName, LastName, MailingStreet, MailingCity, MailingState, MailingPostalCode, HomePhone, MobilePhone, Phone, Email From Contact WHERE ID = :contactId];
        
        if(contacts.size() == 0) {
            return new EEC_ComplaintContact();
        }
        
        return fromContact(contacts[0]);
    }
    
    public static EEC_ComplaintContact fromContact(Contact contact) { 
        EEC_ComplaintContact c = new EEC_ComplaintContact();
        c.FirstName = contact.FirstName;
        c.LastName = contact.LastName;
        c.Id = contact.Id;
        c.MailingStreet = contact.MailingStreet;
        c.MailingCity = contact.MailingCity;
        c.MailingState= contact.MailingState;
        c.MailingPostalCode= contact.MailingPostalCode;
        c.HomePhone= contact.HomePhone;
        c.MobilePhone= contact.MobilePhone;
        c.Phone= contact.Phone;
        c.Email= contact.Email;
        return c;
    }
    
    public Contact toContact() {
        return new Contact(
            FirstName = this.firstName,
            LastName = this.lastName,  
            MailingStreet = this.MailingStreet,
            MailingCity = this.MailingCity,
            MailingState= this.MailingState,
            MailingPostalCode= this.MailingPostalCode,
            HomePhone= this.HomePhone,
            MobilePhone= this.MobilePhone,
            Phone= this.Phone,
            Email= this.Email
        ); 
    }
}