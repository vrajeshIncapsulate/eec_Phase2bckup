public with sharing class EEC_StandardItemRegulationsController {

    public String itemId { get; set; }
    
    public String getRegulationNames() {
        String ret = '';
        
        System.debug(itemId);
    
        List<Junction_InspReg__c> inspRegs = [
            SELECT Regulation__r.Name
            FROM Junction_InspReg__c
            WHERE Standard_Inspection_Item__c = :itemId
        ];
        
        
        for(Junction_InspReg__c inspReg : inspRegs) {
            if(ret != ''){ 
                ret += ', ';
            }
        
            ret += inspReg.Regulation__r.Name;
        }
        
        return ret;
    }

}