global with sharing class DaddyAnalyticsRetrieveDataScheduled implements Schedulable {
	
	// set cron expression used in test class
	public static String CRON_EXP = '0 0 * * * ?';
		
    public DaddyAnalyticsRetrieveDataScheduled() {}
    	
    	public void execute(SchedulableContext sc) {
    		
    	CronTrigger cronTrig =	[
									SELECT Id, CronExpression
                					FROM CronTrigger
                					WHERE Id = :sc.getTriggerId()
                		 		];
		
		// verify the expressions are the same 
      	System.assertEquals(CRON_EXP, cronTrig.CronExpression);
    	
        DaddyAnalyticsRetrieveDataBatch scheduledBatch = new DaddyAnalyticsRetrieveDataBatch();
        database.executeBatch(scheduledBatch,1);
    	}
}