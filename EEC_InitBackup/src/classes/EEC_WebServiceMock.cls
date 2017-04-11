@isTest
global class EEC_WebServiceMock implements WebServiceMock {
  global String objectClassName {get;set;}  
    
  global void doInvoke(Object stub,Object request,Map<String, Object> response,String endpoint,String soapAction,String requestName,String responseNS,String responseName,String responseType) {
     Type t = Type.forName(objectClassName); 
     response.put('response_x', t.newInstance()); 
   }
}