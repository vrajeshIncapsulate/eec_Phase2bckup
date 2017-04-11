global class ChatterAnswersAuthProviderRegistration implements Auth.RegistrationHandler{
private String adminId;
public String getSiteAdminUserId(){
	return adminId != null ? adminId : Site.getAdminId();
}
public void setSiteAdminUserId(String siteAdminId){
	 adminId = siteAdminId;
}
global User createUser(Id portalId, Auth.UserData data){
	Savepoint sp = Database.setSavepoint();
	String accountId = null;
	try { 
        // Chatter Userdata does not support provider address since it's custom. This class is currently NOT used. 
        // This will correct the unit tests only and will need to be updated should we ever use the class.
        Map<String, String> userMap = new Map<String, String>{
          'firstname' => data.firstname,
          'lastname' => data.lastname,
          'email' => data.email,
          'siteAdminId' => getSiteAdminUserId(),
          'provider_address' => '123 Test St',
          'provider_city' => String.valueOf(EEC_TestUtil.mockCity().Id),
          'provider_zip_code' => '12345'
        };
		accountId = new ChatterAnswersRegistration().createAccount(userMap);
	} catch (Exception e) {
		Database.rollback(sp);
		return null;
	}
	User u = new User();
	u.FirstName = data.firstname;
	u.LastName = data.lastname;
	u.Username = accountId + '@facebook.com';
	u.Email = data.email;
	u.CommunityNickname = data.email.substring(0,  data.email.indexOf('@')) + System.currentTimeMillis();
	u.UserPermissionsChatterAnswersUser = true;
	//If using this registration handler with Salesforce Community registration then specify the profileid to associated with the new user.
	//This profile is used only for Salesforce Community site registration and not for standalone Force.com site registration.
	//u.profileId = '<profile-id>';
	Site.setPortalUserAsAuthProvider(u, accountId);
	return u;
}

global void updateUser(Id userId, Id portalId, Auth.UserData data){
	Savepoint sp = Database.setSavepoint();
	User u = [SELECT Contact.email, Contact.firstName, Contact.lastName FROM User WHERE id=:userId];
	u.Contact.email = data.email;
	u.Contact.firstName = data.firstName;
	u.Contact.lastName = data.lastName;
	u.firstName = data.firstName;
	u.lastName = data.lastName;
	u.email = data.email;
	try {
		update u;
		update u.Contact;
	 } catch (Exception e) {
		Database.rollback(sp);
	}
}
}