global class EEC_ScheduleBatchGetVisitCoordinates implements Schedulable {
	global void execute(SchedulableContext sc) {
		EEC_batchGetVisitCoordinates b = new EEC_batchGetVisitCoordinates();
		id bId = database.executebatch(b);
	}
}