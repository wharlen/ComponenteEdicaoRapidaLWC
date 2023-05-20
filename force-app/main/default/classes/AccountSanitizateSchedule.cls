global class AccountSanitizateSchedule implements Schedulable {
   
    global void execute( SchedulableContext SC ) {
        InactiveAccountsSanitizationBatchable batch = new InactiveAccountsSanitizationBatchable();
        Database.executeBatch(batch);
    }
}