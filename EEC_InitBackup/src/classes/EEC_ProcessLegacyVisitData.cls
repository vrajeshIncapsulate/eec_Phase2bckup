//Author: Latha Davuluri
public with sharing class EEC_ProcessLegacyVisitData {
    
    //Method to Process LM 2010/FCC Mobile Visits - LEAD-4231 & LEAD-4298
    public static void processLegacyVisits(EEC_HistoricalVisitStaging__c vs){
        
        Id LegacyRecordTypeId = [Select Id From RecordType Where sobjectType='Inspection__c' and name like 'Legacy System%'].Id;
        Id ProgramId = [Select Id,Name, Provider_No__c From Account Where Provider_No__c = :vs.EEC_ProgramId__c].Id;
        Id licensorId = [Select Id From User Where Historic_Licensor_No__c = :vs.EEC_VisitingLicensorId1__c limit 1].Id;
        List<Inspection__c> visitsToCreate = new List<Inspection__c>();
        
        //Duplicate Algorithm : Visit Date + ProgramId + VisitReason is considered as duplicate
        
        string dupRule1 = vs.EEC_DuplicateRule1__c;

        List<EEC_HistoricalVisitStaging__c> processedVisit = [Select Id From EEC_HistoricalVisitStaging__c Where EEC_DuplicateRule1__c = :dupRule1 and EEC_Visit_Processed__c = true];
        
        system.debug('processedVisit*******'+processedVisit);
        //check for duplicates and insert only if no duplicates found
        if (processedVisit.size() <= 0){
            Inspection__c lmv = new Inspection__c();
            
            lmv.RecordTypeId = LegacyRecordTypeId;
            lmv.Provider_No__c = ProgramId;
            lmv.Type_of_Visit__c = vs.EEC_LeadReasonOfVisit__c;
            lmv.Comments__c = vs.EEC_Comment__c;
            lmv.Status__c = 'Closed';
            lmv.Date_of_Visit__c = vs.EEC_VisitDate__c;
            lmv.EEC_Legacy_Compliance_Code_Desc__c = vs.EEC_ComplianceCodeDesc__c;
            lmv.Legacy_FCC_LM_Mobile_Visit__c = vs.EEC_FCC_Mobile_Visit__c;
            if(licensorId != null)
                lmv.Inspector_del__c = licensorId;
            
            visitsToCreate.add(lmv);
            
            if(visitsToCreate.size() > 0){
                insert visitsToCreate;
            }
        }
        
    }
        
    //Method to Process FCC Mobile VisitItems - LEAD-4298
    public static void processLegacyVisitItems(EEC_HistoricalVisitItemStaging__c vis){
        
        boolean createVisitItem = true;
        
      /*  //ONLY Bring in the Non-Compliance VisitItems on FCC Mobile Detail Extract    
        if (!String.isBlank(vis.EEC_ComplianceStatusDesc__c) && vis.EEC_ComplianceStatusDesc__c.equalsIgnoreCase('Non-compliance')){ 
            createVisitItem = true;
        }
        */
       
       //Create Visit Item only if it is Non-Compliance
       if (createVisitItem){
        
        List<Inspection_Item__c> visitItemsToCreate = new List<Inspection_Item__c>();
        List<EEC_HistoricalVisitSubItemStaging__c> subItemsToUpdate = new List<EEC_HistoricalVisitSubItemStaging__c>();
        List<Inspection__c> visitsToUpdate = new List<Inspection__c>();
        Id NonStandardItm = [Select id,Name from RecordType where sObjectType = 'Inspection_Item__c' and Name like 'Non Standard%'].Id;
        List<string> regList = new List<string>();
        Set<string> citationIds = new Set<string>();
        List<string> citationList = new List<string>();
        List<EEC_HistoricalVisitSubItemStaging__c> visitSubItems = [Select Id, EEC_Display_Text_SubItemVal__c, EEC_Visit_SubItem_Processed__c From EEC_HistoricalVisitSubItemStaging__c Where EEC_HeaderVisitItem__c = :vis.EEC_HeaderVisitItem__c And EEC_Visit_SubItem_Processed__c = false];
            
        if (vis.EEC_RegGroupItem__c != null){
                citationList = vis.EEC_RegGroupItem__c.split(';');
                for(string cs: citationList){
                    citationIds.add(cs.trim());
                }
        }
        
        List<Regulation__c> RegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :citationIds];
        Map<string,Regulation__c> RegulationMap = new Map<string,Regulation__c>();
        for(Regulation__c rg: RegulationList){
            RegulationMap.put(rg.Name,rg);
        }
        string headerVisit = vis.EEC_HeaderVisit__c;
        string subItemText = '';

        Inspection__c legacyVisit = [Select Id,Provider_No__c,Provider_Type__c,Date_of_Visit__c, Status__c From Inspection__c Where Legacy_FCC_LM_Mobile_Visit__c = :headerVisit limit 1];
        
        //check for duplicates and insert only if no duplicates found
        if (legacyVisit != null){
            
            Inspection_Item__c visitItm = new Inspection_Item__c();
                                 
             visitItm.Inspection_No__c = legacyVisit.Id;
             visitItm.RecordTypeId = NonStandardItm;
             visitItm.Additional_Inspection_Item_Name__c = vis.EEC_RegGroupItemDesc__c;
             if (!String.isBlank(vis.EEC_ComplianceStatusDesc__c)){ 
                 if (vis.EEC_ComplianceStatusDesc__c.equalsIgnoreCase('Compliance'))
                     visitItm.Inspection_Result__c = 'Compliant';
                 else if (vis.EEC_ComplianceStatusDesc__c.equalsIgnoreCase('Non-compliance'))
                     visitItm.Inspection_Result__c = 'Non-Compliant';
                 else if (vis.EEC_ComplianceStatusDesc__c.equalsIgnoreCase('Discussion'))
                     visitItm.Inspection_Result__c = 'Discussion';
                 else 
                    visitItm.Inspection_Result__c = vis.EEC_ComplianceStatusDesc__c;
                 
             }
             visitItm.Category_additional__c = 'Legacy System '+ vis.EEC_ComplianceStatusDesc__c;
             
             //Append all the SubItems info 
             if (visitSubItems.size() > 0){
                for (EEC_HistoricalVisitSubItemStaging__c sis :  visitSubItems){                    
                    subItemText = subItemText + sis.EEC_Display_Text_SubItemVal__c + ';';
                    sis.EEC_Visit_SubItem_Processed__c = true;
                    subItemsToUpdate.add(sis);
                }
             }
             
             visitItm.Observations__c = vis.EEC_Comment__c;
             if (!string.isBlank(vis.EEC_Comment__c)) {
                visitItm.Observations__c = vis.EEC_Comment__c + '; ' + subItemText;
             }
             else if (!string.isBlank(subItemText)) {
                visitItm.Observations__c = subItemText;
             }
             else{
                visitItm.Observations__c = 'No Observations added.'; // Added this text in order to avoid Validation errors 
             }
             visitItm.Assessed_Date__c = legacyVisit.Date_of_Visit__c + 1;
             
               //Citation Info to include
             if (!string.isBlank(vis.EEC_RegGroupItem__c ))
                 regList = vis.EEC_RegGroupItem__c.split(';');
            
             //Regulations/Citations to add on the visit Items  
              if (regList.size() > 1){
                
                system.debug('****Regulation Map***'+regulationMap);
                
                 integer counter = 1;
                
                 for (string cs: regList){
                    
                    system.debug('***1 ***:'+ cs);
                     
                     //Special condition on one of the regulations //7.07(07)(g)  ----> replace it with 7.07(07)(h)                  
                     if (cs == '7.07(07)(g)')
                         cs = '7.07(07)(h)'; 
                     
                     Regulation__c rgFound = regulationMap.get(cs.trim());
                     
                     if (counter == regList.size()){    
                        if (rgFound != null){
                            system.debug('****rgFound***:'+rgFound);
                            system.debug('****Provider_Type__c***:'+legacyVisit.Provider_Type__c);
                            
                            if (rgFound.Applicable_To__c.contains(legacyVisit.Provider_Type__c)){
                                system.debug('****Applicable_To***:'+rgFound.Applicable_To__c.contains(legacyVisit.Provider_Type__c));                
                                visitItm.Associated_regulation__c = rgFound.Id;                             
                            }
                        }
                        visitItemsToCreate.add(visitItm); 
                     }
                     else{                      
                        Inspection_Item__c visitItmClone = visitItm.clone();    
                        if (rgFound != null){
                            system.debug('****rgFound***:'+rgFound);
                            system.debug('****Provider_Type__c***:'+legacyVisit.Provider_Type__c);
                            system.debug('****Applicable_To***:'+rgFound.Applicable_To__c.contains(legacyVisit.Provider_Type__c));                
                                visitItmClone.Associated_regulation__c = rgFound.Id;        
                        }
                        visitItemsToCreate.add(visitItmClone);              
                     }
                                         
                     counter = counter + 1;
                     
                   }//end for citation
               }
               else if(regList.size() <= 1){
                  
                     string cs = vis.EEC_RegGroupItem__c;
                    //Special condition on one of the regulations //7.07(07)(g)  ----> replace it with 7.07(07)(h)               
                     if (cs == '7.07(07)(g)')
                         cs = '7.07(07)(h)'; 
                      
                      system.debug('***2 ***:'+ cs);
   
                   Regulation__c rgFound2 = regulationMap.get(cs.trim());
                   
                   if(rgFound2 != null){
                        
                      system.debug('****rgFound***:'+rgFound2);
                      system.debug('****Provider_Type__c***:'+legacyVisit.Provider_Type__c);
                        
                      if (rgFound2.Applicable_To__c.contains(legacyVisit.Provider_Type__c)){    
                         system.debug('****Applicable_To***:'+rgFound2.Applicable_To__c.contains(legacyVisit.Provider_Type__c));                  
                         visitItm.Associated_regulation__c = rgFound2.Id;
                       }               
                    }
                    visitItemsToCreate.add(visitItm);               
               }
                       
               
             legacyVisit.Status__c = 'Closed';           

            
             if(visitItemsToCreate.size() > 0){
                 insert visitItemsToCreate;
              }
            
             if (subItemsToUpdate.size() >0){
                 update subItemsToUpdate;
             }
            
            update legacyVisit;
        }
       } //Create Non-Compliance Visit Item
       else{
          vis.EEC_ErrorText__c = 'Not a Non-compliance Visit Item.';
       }
    }
    
    //Method to Process EECRs NonCompliance Visits - LEAD-4299
    public static void processLegacyNonComplianceVisits(EEC_HistoryOfNonComplianceStaging__c ncs){
        
        system.debug('*******Provider******'+ncs.ProgramId__c);
        
        Id LegacyRecordTypeId = [Select Id From RecordType Where sobjectType='Inspection__c' and name like 'Legacy System%'].Id;
        Id ProgramId = [Select Id,Name, Provider_No__c From Account Where Provider_No__c = :ncs.ProgramId__c].Id;
        List<User> licensorId = [Select Id From User Where Historic_Licensor_No__c = :ncs.LicensorOfInteraction__c limit 1];
        List<Inspection__c> visitsToCreate = new List<Inspection__c>();
        
        //Duplicate Algorithm : ProgramId + InteractionId + InteractionTypeDesc is considered as duplicate
        
        string dupRule1 = ncs.DuplicateRule1__c;

        List<Inspection__c> processedVisit = [Select Id,Legacy_FCC_LM_Mobile_Visit__c From Inspection__c Where Legacy_FCC_LM_Mobile_Visit__c = :dupRule1];
        
        system.debug('processedVisit*******'+processedVisit);
        //check for duplicates and insert only if no duplicates found
        if (processedVisit.size() <= 0){
            Inspection__c ncVisit = new Inspection__c();
                            
            ncVisit.RecordTypeId = LegacyRecordTypeId;
            if(ProgramId != null)
               ncVisit.Provider_No__c = ProgramId;
            ncVisit.Type_of_Visit__c = ncs.InteractionTypeDesc__c;
            ncVisit.Legacy_System_Interaction__c = ncs.InteractionId__c;
            ncVisit.Status__c = 'Closed';
            ncVisit.Date_of_Visit__c = ncs.InteractionDate__c;
            ncVisit.Legacy_FCC_LM_Mobile_Visit__c = ncs.DuplicateRule1__c;
            if(licensorId.size() > 0)
                ncVisit.Inspector_del__c = licensorId[0].Id;
            
            visitsToCreate.add(ncVisit);
            
            if(visitsToCreate.size() > 0){
                insert visitsToCreate;
            }
        }
           
    }
  //Method to create investigations for EECRS non-compliances where InvestigationType is not null - Qamar
    public static void processLegacyInvestigations(EEC_HistoryOfNonComplianceStaging__c ncs){
        
        system.debug('*******Provider******'+ncs.ProgramId__c);
        
        //Id LegacyRecordTypeId = [Select Id From RecordType Where sobjectType='Inspection__c' and name like 'Legacy System%'].Id;
        Account p = [Select Id, AccountRecord_Type_Hidden__c, Name, Provider_No__c From Account Where Provider_No__c = :ncs.ProgramId__c];
        Id programId = p.Id;
        String programRecordType = p.AccountRecord_Type_Hidden__c;
        List<User> licensorId = [Select Id From User Where Historic_Licensor_No__c = :ncs.LicensorOfInteraction__c limit 1];
        List<Investigation__c> investigationsToCreate = new List<Investigation__c>();
        
        //Duplicate Algorithm : ProgramId + InteractionId + InteractionTypeDesc is considered as duplicate
        
        string dupRule1 = ncs.DuplicateRule1__c;

        List<Investigation__c> processedInvestigation = [Select Id,Legacy_FCC_LM_Mobile_Investigation__c From Investigation__c Where Legacy_FCC_LM_Mobile_Investigation__c = :dupRule1];
        
        system.debug('processedInvestigation*******'+processedInvestigation);
        //check for duplicates and insert only if no duplicates found
        if(processedInvestigation.size() <= 0){
            Investigation__c ncInv = new Investigation__c();

            if(programId != null && programRecordType != 'FCC Assistant'){
                ncInv.Provider_No__c = ProgramId;
            }
            ncInv.Investigation_Type__c = ncs.InvestigationType__c;
            ncInv.Assigned_Date__c = ncs.InteractionDate__c;
            ncInv.Legacy_System_Interaction__c = ncs.InteractionId__c;
            ncInv.Investigation_Status__c = 'Closed (Legacy Investigation)';
            ncInv.Legacy_FCC_LM_Mobile_Investigation__c = ncs.DuplicateRule1__c;
            ncInv.isLegacyInvestigation__c = true;
            ncInv.Legacy_System_Interaction__c = ncs.InteractionId__c;
            ncInv.Legacy_IntakeID__c = ncs.IntakeID__c;
            if(licensorId.size() > 0){
                ncInv.Assigned_To__c = licensorId[0].Id;
            }
                

            investigationsToCreate.add(ncInv);
            
            if(investigationsToCreate.size() > 0){
                insert investigationsToCreate;
            }
        }
           
    }

    //Method to process EECCRS Investigation Additional Non-compliance Items - Qamar

    public static void processLegacyInvestigationAddionalNonComplianceItems(EEC_HistoryOfNonComplianceStaging__c ncs){
        List<Non_Compliant__c> nonComplianceItemsToCreate = new List<Non_Compliant__c>();
        List<string> regList = new List<string>();
        Set<string> citationIds = new Set<string>();
        List<string> citationList = new List<string>();
        List<Non_Compliant_Item_Regulation__c> ncItemRegItemsToInsert = new List<Non_Compliant_Item_Regulation__c>();

        if (ncs.Citation__c != null){
            citationList = ncs.Citation__c.split(';');
            for(string cs: citationList){
                citationIds.add(cs.trim());
            }
        }
    
    List<Regulation__c> RegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :citationIds];
    Map<string,Regulation__c> RegulationMap = new Map<string,Regulation__c>();
    for(Regulation__c rg: RegulationList){
        RegulationMap.put(rg.Name,rg);
    }
            
        //Look for the matching Visit
        string matchRule = ncs.DuplicateRule1__c;

        List<Investigation__c> processedInvestigation = [Select Id,Legacy_FCC_LM_Mobile_Investigation__c From Investigation__c Where Legacy_FCC_LM_Mobile_Investigation__c = :matchRule];
        
        system.debug('---------> processedInvestigation: ' + processedInvestigation);
        Non_Compliant__c nonCompliantItem = new Non_Compliant__c();
        //Matching investigation found - Insert the non-compliant items on the investigation found
        if(processedInvestigation.size() > 0){
            system.debug('Regulation Map ---'+RegulationMap);
            nonCompliantItem.Investigation__c = processedInvestigation[0].Id;
            nonCompliantItem.Require_Portal_Feedback__c = false;
            nonCompliantItem.To_Review_on_Portal__c = false;
            nonCompliantItem.Observations__c = ncs.Observations__c;
            nonCompliantItem.Correction_Plan__c = ncs.CorrectionPlan__c;
            nonCompliantItem.Correction_Plan_Status__c = 'Legacy Non-compliance';
        }
        insert nonCompliantItem;
        //Non_Compliant_Item_Regulation__c items to create
        for(String citationId : citationIds){
            Regulation__c reg = RegulationMap.get(citationId);

            Non_Compliant_Item_Regulation__c ncItemReg = new Non_Compliant_Item_Regulation__c();
            ncItemReg.Non_Compliant_Item__c = nonCompliantItem.Id;
            ncItemReg.Regulation__c = reg.id;
            ncItemRegItemsToInsert.add(ncItemReg);
        }
        insert ncItemRegItemsToInsert;
    }
    
    //Method to Process EECRs NonCompliance Visits - LEAD-4299
    public static void processLegacyNonComplianceVisitItems(EEC_HistoryOfNonComplianceStaging__c ncs){
        
        List<Inspection_Item__c> visitItemsToCreate = new List<Inspection_Item__c>();
        Id NonStandardItm = [Select id,Name from RecordType where sObjectType = 'Inspection_Item__c' and Name like 'Non Standard%'].Id;
        List<string> regList = new List<string>();
        Set<string> citationIds = new Set<string>();
        List<string> citationList = new List<string>();
            
        if (ncs.Citation__c != null){
                citationList = ncs.Citation__c.split(';');
                for(string cs: citationList){
                    citationIds.add(cs.trim());
                }
        }
        
        List<Regulation__c> RegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :citationIds];
        Map<string,Regulation__c> RegulationMap = new Map<string,Regulation__c>();
        for(Regulation__c rg: RegulationList){
            RegulationMap.put(rg.Name,rg);
        }
            
        //Look for the matching Visit
        string matchRule = ncs.DuplicateRule1__c;

        List<Inspection__c> processedVisit = [Select Id,Legacy_FCC_LM_Mobile_Visit__c,Provider_Type__c,Date_of_Visit__c From Inspection__c Where Legacy_FCC_LM_Mobile_Visit__c = :matchRule limit 1];
        
        system.debug('processedVisit*******'+processedVisit);
        
        //Matching Visit Found - Insert the VisitItems on the Visit Found
        if (processedVisit.size() > 0){
            system.debug('Regulation Map ---'+RegulationMap);
            Inspection_Item__c visitItm = new Inspection_Item__c();
            visitItm.Inspection_No__c = processedVisit[0].Id;
            visitItm.RecordTypeId = NonStandardItm;
            visitItm.Category_additional__c = 'Legacy System Non Compliance';
            Integer itemNameUpperLimit = ncs.Observations__c.length() > 37 ? 37 : ncs.Observations__c.length();
            visitItm.Additional_Inspection_Item_Name__c = ncs.Observations__c.substring(0,itemNameUpperLimit) + '...';
            visitItm.Observations__c = ncs.Observations__c;
            visitItm.Inspection_Result__c ='Non-Compliant';
            visitItm.Correction_Plan__c = ncs.CorrectionPlan__c;
            visitItm.Assessed_Date__c = processedVisit[0].Date_of_Visit__c + 1;
            visitItm.Correction_Plan_Status__c = 'Legacy Non-compliance';
             
               //Citation Info to include
             if (!string.isBlank(ncs.Citation__c))
                 regList = ncs.Citation__c.split(';');
                 
             //Regulations/Citations to add on the visit Items
             if (regList.size() > 1){
                
                system.debug('****Regulation Map***'+regulationMap);
                
                 integer counter = 1;
                
                 for (string cs: regList){
                    
                    system.debug('***1 ***:'+ cs);
                     
                     //Special condition on one of the regulations //7.07(07)(g)  ----> replace it with 7.07(07)(h)                  
                     if (cs == '7.07(07)(g)')
                         cs = '7.07(07)(h)'; 
                     
                     Regulation__c rgFound = regulationMap.get(cs.trim());
                     
                     if (counter == regList.size()){    
                        if (rgFound != null){
                            system.debug('****rgFound***:'+rgFound);
                            system.debug('****Provider_Type__c***:'+processedVisit[0].Provider_Type__c);
                            
                            if (rgFound.Applicable_To__c.contains(processedVisit[0].Provider_Type__c)){
                                system.debug('****Applicable_To***:'+rgFound.Applicable_To__c.contains(processedVisit[0].Provider_Type__c));                  
                                visitItm.Associated_regulation__c = rgFound.Id;                             
                            }
                        }
                        visitItemsToCreate.add(visitItm); 
                     }
                     else{                      
                        Inspection_Item__c visitItmClone = visitItm.clone();    
                        if (rgFound != null){
                            system.debug('****rgFound***:'+rgFound);
                            system.debug('****Provider_Type__c***:'+processedVisit[0].Provider_Type__c);
                            system.debug('****Applicable_To***:'+rgFound.Applicable_To__c.contains(processedVisit[0].Provider_Type__c));                  
                                visitItmClone.Associated_regulation__c = rgFound.Id;        
                        }
                        visitItemsToCreate.add(visitItmClone);              
                     }
                                         
                     counter = counter + 1;
                     
                   }//end for citation
               }
               else if(regList.size() <= 1){
                  
                     string cs = ncs.Citation__c;
                    //Special condition on one of the regulations //7.07(07)(g)  ----> replace it with 7.07(07)(h)               
                     if (cs == '7.07(07)(g)')
                         cs = '7.07(07)(h)'; 
                      
                      system.debug('***2 ***:'+ cs);
   
                   Regulation__c rgFound2 = regulationMap.get(cs.trim());
                   
                   if(rgFound2 != null){
                        
                      system.debug('****rgFound***:'+rgFound2);
                      system.debug('****Provider_Type__c***:'+processedVisit[0].Provider_Type__c);
                        
                      if (rgFound2.Applicable_To__c.contains(processedVisit[0].Provider_Type__c)){  
                         system.debug('****Applicable_To***:'+rgFound2.Applicable_To__c.contains(processedVisit[0].Provider_Type__c));                
                         visitItm.Associated_regulation__c = rgFound2.Id;
                       }               
                    }
                    visitItemsToCreate.add(visitItm);               
               }
        
            system.debug('##### VisitItems ####'+ visitItemsToCreate);
            
            processedVisit[0].Status__c = 'Closed';  
            
            update processedVisit[0];
            
        }
        if (visitItemsToCreate.size() > 0){
            insert visitItemsToCreate;
        }
    
           
    }
    
    /*
    private static Set<Id> getCitationIds(List<string> regList, Map<string,Regulation__c> regMap, string ProviderType){
        
        Set<Id> citationIds = new Set<Id>();
        
        system.debug('*** Regulation List ****'+regList);
        
        if(regList.size() > 0){
            for (string cs: regList){
                 //Special condition on one of the regulations //7.07(07)(g)  ----> replace it with 7.07(07)(h)                  
                 if (cs == '7.07(07)(g)'){
                    cs = '7.07(07)(h)'; 
                 }
                 Regulation__c rgFound = regMap.get(cs);
                 
                 if (rgFound != null){
                
                    system.debug('****rgFound***:'+rgFound);
                    system.debug('****Provider_Type__c***:'+ProviderType);
                
                     if (rgFound.Applicable_To__c.contains(ProviderType)){
                         citationIds.add(rgFound.Id);
                      }
                  } 
             }//end for citation
         }
         
         return citationIds;
        
    }
    
    
    private static Map<string,Regulation__c> getRegulationMap(Set<string> citations){
        List<Regulation__c> RegulationList = [Select Id, Name, Applicable_To__c From Regulation__c Where Name in :citations];
        Map<string,Regulation__c> regulationMap = new Map<string,Regulation__c>();
        for(Regulation__c rg: RegulationList){
            regulationMap.put(rg.Name,rg);
        }
        return regulationMap;
    }
    
    */

}