public with sharing class VF_SchemaUtil_Controller {

   public String output {get; set;}

   public VF_SchemaUtil_Controller() {
        String ObjectType = 'Case';
        String outputPrefix = 'c';
        
        output = '';
        
        sObject sObj = Schema.getGlobalDescribe().get(ObjectType).newSObject();
        List<String> accessibleFields = new List<String>();
        List<String> sortedFields = new List<String>();
        Map<String, Schema.SobjectField> fields = 
            sObj.getSObjectType().getDescribe().fields.getMap();
        sortedFields.addAll(fields.keySet());
        sortedFields.sort();
        for (String s : sortedFields) {
            if (fields.get(s).getDescribe().isAccessible()) {
                output += '&lt;apex:inputField id="' + s + '" value="{!' + outputPrefix + '.' + s + '}"/&gt;<br/><br/>\n';
            }
        }   
   }

}