global class HappyBirthdayBatchSchedule implements Schedulable{
    global void execute(SchedulableContext ctx) {
        HappyBirthdayBatch myHappyBirthdayBatch = new HappyBirthdayBatch();
        database.executebatch(myHappyBirthdayBatch);
    }

}