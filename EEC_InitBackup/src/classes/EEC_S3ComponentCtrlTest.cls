@isTest	
public class EEC_S3ComponentCtrlTest {
  static testMethod void testGenerateMultiplePolicySignature() {
    EEC_TestUtil.mockAWSKeys();
    // Test method.
    String exampleJson = '[{"filename": "testName", "type": "image/png"}]'; 
        
    List<Map<String,String>> result = EEC_S3ComponentCtrl.generateMultiplePolicySignature('eec', 'authenticated-read', exampleJson);
    System.assertNotEquals(0, result.size());
    System.assertNotEquals(null, result.get(0).get('policy'));  
    System.assertNotEquals(null, result.get(0).get('signature'));   
  }
    
  static testMethod void testGeneratePolicySignature() {
    Map<String,String> singleResult = EEC_S3ComponentCtrl.generatePolicySignature('eec', 'authenticated-read', 'testName', 'image/png', null);  
    System.assertEquals('An error has occured. Please contact your administrator.', singleResult.get('error'));   
      
    EEC_TestUtil.mockAWSKeys();  
        
    singleResult = EEC_S3ComponentCtrl.generatePolicySignature('eec', 'authenticated-read', 'testName', 'image/png', 'https://www.google.com');  
    System.assertNotEquals(null, singleResult);
    System.assertNotEquals(null, singleResult.get('policy'));  
    System.assertNotEquals(null, singleResult.get('signature')); 
      
    
  }
}