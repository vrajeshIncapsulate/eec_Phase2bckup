@isTest
public class EEC_UtilTest {
    public static testMethod void testEncryptGetParam() {
      System.assertNotEquals(null, EEC_Util.encryptGetParam('abcde'));   
    }
    
    public static testMethod void testDecryptGetParam() {
      System.assertNotEquals(null, EEC_Util.decryptGetParam('RmLUit37tscLEIA39OWRDqgO5U+D6NM1IzEyDq69rYmDGJ27ZdEIHGpzRoxoQBDj'));     
    }
}