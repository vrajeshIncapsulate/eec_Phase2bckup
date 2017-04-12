public with sharing class EEC_ShowMapsController {
        
        public list<InspectionWrapper> inspWrapperList {get;set;}
        public String userId {get;set;}
        public EEC_ShowMapsController(){
            try{ Set<Id> accountSet = new Set<Id>();
                inspWrapperList = new List<InspectionWrapper>();
                Set<Id> userSet = getUserSet(); 
                List<Inspection__c> inspList =  [SELECT Id,name,Provider_no__c,Status__c,Inspector_del__r.name,Estimated_Deadline__c
                                                                , Date_of_Visit__c,Announced__c,Provider_no__r.name, Address_1__c, State__c, Zip_Code__c,City__c
                                                                , Type_of_Visit__c, visitLongitude__c, visitLatitude__c
                                                            FROM Inspection__c WHERE provider_no__c != null and Status__c in ('Scheduled','To be scheduled') 
                                                                and City__c != null 
                                                                and (Provider_no__r.OwnerId in :userSet or Inspector_del__c in :userSet)];
                    
                for(Inspection__c insp : inspList){
                    System.debug('-------> Inspection: ' + insp);
                    if(insp.visitLongitude__c != null){
                        inspWrapperList.add(new InspectionWrapper(insp));
                        System.debug('-------> Inspection: ' + insp);
                    }
                    //accountSet.add(insp.provider_no__c);                                                  
                }
                
                System.debug('*******inspWrapperList** ' + inspWrapperList.size() + ' -- ' + inspWrapperList);
            } catch(Exception ex){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:' +ex.getMessage()));
            }
            
            userId = UserInfo.getUserId();
        }
        
    public class InspectionWrapper{ 
        public Id Id {get;set;}
        public String content {get;set;}
        //public String announced {get;set;}
        public String providerAddress {get;set;}
        public String visitLink {get;set;}
        public String status {get;set;}
        public Decimal longitude {get; set;}
        public Decimal latitude {get; set;}
        public Date deadline {get; set;}
        
        public InspectionWrapper(Inspection__c insp){
            this.Id = insp.Id;
            
            this.providerAddress = insp.Address_1__c + ', ' + insp.city__c +', '+insp.State__c+', USA';
            //this.announced = (insp.Announced__c?'Announced':'Un-Announced');

            this.longitude = Decimal.valueOf(insp.visitLongitude__c);
            this.latitude = Decimal.valueOf(insp.visitLatitude__c);
            this.deadline = insp.Estimated_Deadline__c;
            
            System.debug('longitude: ' + longitude);
            
            this.visitLink = ' - <a target=\'_blank\' href=\'/' + insp.Id + '\'><b>Open Visit</b></a>';
            this.status = insp.Status__c;
            String deadlineEstimated = insp.Estimated_Deadline__c != null ? (' - <b>Deadline</b> - '+insp.Estimated_Deadline__c.format() ):'';
            String visitDate = insp.Date_of_Visit__c != null ? (' - <b>Visit Date</b> - '+insp.Date_of_Visit__c.format() ):'';
            String assignedTo = insp.Inspector_del__c != null ? (' - <b>Assigned to</b> - '+insp.Inspector_del__r.name):'';
            String typeOfVisit = insp.Type_of_Visit__c != null ? (' - <b>Reason of Visit</b> - ' + insp.Type_of_Visit__c ):'';
            this.content = '<b>'+insp.Provider_no__r.name + '</b> -- ' +insp.Status__c +' -- ' + deadlineEstimated + visitDate + assignedTo + typeOfVisit + visitLink;
        }
    }

        public Set<Id> getUserSet(){
            Set<Id> userSet = new Set<Id>();
            List<User> userList;
            Map<Id,User> innerMap;
            Set<Id> innerSet;
            userSet.add(UserInfo.getUserId());
            
            Map<Id,User> userMap = new Map<Id,User>([select Id,ManagerId from User where ManagerId != null and ManagerId = :UserInfo.getUserId()]);
            
            if(userMap != null && userMap.size() > 0){
                userSet.addAll(userMap.keyset());
                innerSet = userMap.keyset();
                for(integer i=0;i<6;i++){
                    innerMap = new Map<Id,User>([select Id from User where ManagerId in :innerSet]);
                    if(innerMap != null && innerMap.size() > 0){
                        userSet.addAll(innerMap.keySet());
                        innerSet = innerMap.keySet();
                    }
                    else{
                        break;
                    }
                    
                }
            }
            System.debug('********userSet -- '+userSet);
            return userSet;
        }

}