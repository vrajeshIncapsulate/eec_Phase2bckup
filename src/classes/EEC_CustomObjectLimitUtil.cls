public class EEC_CustomObjectLimitUtil {

  /*
  public List<SelectOption> getName()
  {

    List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();    
    List<SelectOption> options = new List<SelectOption>();
    for(Schema.SObjectType f : gd)
    {
       if (f.getDescribe().isCustom())
           options.add(new SelectOption(f.getDescribe().getLabel(),f.getDescribe().getLabel()));
    }
    return options;
   }
   */
    public Static String getEdition(){
 
         Organization[] org = new Organization[]{};
        org = [select Id, OrganizationType from Organization limit 1];
 
        // Check to make sure we have a result
        if(org.size()==1)
            return org[0].OrganizationType;
        else
            return 'Error';
    }
    
    public integer Count()
    {
               List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();    
               List<SelectOption> options = new List<SelectOption>();
               for(Schema.SObjectType f : gd)
               {
                   if (f.getDescribe().isCustom())
                       options.add(new SelectOption(f.getDescribe().getLabel(),f.getDescribe().getLabel()));
               }
       return options.size();
     }
    /*
    public void getPageInfo()
    {
        List<Apexpage> lst=[select id,name from Apexpage];
        for(Apexpage temp:lst)
        {
            System.Debug(temp.name);
            PageReference pageRef = new PageReference(temp.name);
            System.Debug(pageRef.getUrl());
        }
            
    }
    */
}