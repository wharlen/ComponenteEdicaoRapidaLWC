AccountSanitizateSchedule sch = new AccountSanitizateSchedule();

String cronExp = '0 0 6,12,18,23 ? * MON-FRI';//'0 30 8 1 * * *';  // each 6h every work days

String jobID = System.schedule('Account sanitization scheduled four times every work days', cronExp, sch);