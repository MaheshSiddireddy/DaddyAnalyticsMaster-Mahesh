global with sharing class DaddyAnalyticsRetrieveDataBatch implements Database.Batchable<Lead>, Database.AllowsCallouts {

	Lead[] unMatchedLeads =	[	Select	Lead.Id, Lead.DA_Token__c, DA_User_ID__c
								From	Lead
								Where	Lead.DA_Token__c <> '' And
										Lead.DA_Token__c <> null And
										Lead.DA_User_ID__c = null
							];
							
	public Iterable<Lead> start(database.batchablecontext bc) {
    return (unMatchedLeads);
	}
	
		public void execute(Database.BatchableContext bc, List<Lead> scope) {
	    for(Lead matchLead : scope) {
	    	
	    	DaddyAnalyticsRetrieveData.retrieveData(datetime.now(),matchLead.DA_Token__c);
	    	} 									
		}
		
			public void finish(Database.BatchableContext bc) {
    		}
    		
    		webservice static String onButtonRetrieveDataBatch() {
    			
        		DaddyAnalyticsRetrieveDataBatch buttonBatch = new DaddyAnalyticsRetrieveDataBatch();
        		String batchId = database.executeBatch(buttonBatch,1);
        		
        		return batchId;
    		}
}