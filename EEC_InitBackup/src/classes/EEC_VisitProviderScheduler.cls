global class EEC_VisitProviderScheduler implements schedulable{

    public void execute (SchedulableContext sc) {
        
        EEC_BatchProviderVisit pv = new EEC_BatchProviderVisit();
        id bpvs = database.executebatch(pv,10);
    }
}