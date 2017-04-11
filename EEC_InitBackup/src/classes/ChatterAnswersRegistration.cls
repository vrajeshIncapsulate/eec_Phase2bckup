/**
 * This class has been generated to allow customization of Account creation for Chatter Answers Portal Users.
 * Chatter Answers requires that this class exist and implement ChatterAnswers.AccountCreator, renaming the class
 *   or removing the interface implementation is prohibited. */
public class ChatterAnswersRegistration implements ChatterAnswers.AccountCreator {
    public String createAccount(String firstname, String lastname, Id siteAdminId) {
         Account a = new Account(name = firstname + ' ' + lastname, ownerId = siteAdminId);
         insert a;
         return a.Id;
    }
    
    public String createAccount(Map<String, String> data) {
         Account a = new Account(
             name = data.get('firstname') + ' ' + data.get('lastname'), 
             ownerId = data.get('siteAdminId'), 
             Provider_Email__c = data.get('email'),
             Provider_Address_1__c = data.get('provider_address'), 
             Provider_City__c = data.get('provider_city'), 
             Provider_Zip_Code__c = data.get('provider_zip_code')
         );
         insert a;
         return a.Id;
    }
}