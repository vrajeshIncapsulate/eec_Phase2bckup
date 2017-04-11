public class CreateVisitEvent {
    public Event evt{get;set;}
    public string taskId{get;set;}
    
    public CreateVisitEvent(ApexPages.StandardController controller) {
        taskId = ApexPages.currentPage().getParameters().get('id');
        Task visitTask = [Select WhatId,WhoId,OwnerId,Subject From Task where id=:taskId];
        evt = new Event();
        evt.Subject = (visitTask.Subject).replace('Schedule visit','Visit');
        evt.WhatId = visitTask.WhatId;
        evt.WhoId = visitTask.WhoId;
        evt.OwnerId = UserInfo.getUserId();
    }
   
   public pagereference save(){
        insert evt;
        PageReference eventPage = new PageReference('/'+evt.id);
        eventPage.setRedirect(true);
        return eventPage;
    }

    }