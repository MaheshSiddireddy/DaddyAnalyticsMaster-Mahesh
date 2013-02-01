public with sharing class DaddyAnalyticsUninstallScript implements UninstallHandler {
	
	public void onUninstall(UninstallContext context) {
	
	// check if Daddy Analytics custom settings exist
    List<DaddyAnalytics__c> DASettings = new List<DaddyAnalytics__c>();
    	
	DASettings =	[	select	Id
						from	DaddyAnalytics__c
					];

		// if settings exists delete them				
		if(DASettings.size() > 0) {
			
			delete DASettings;
		}
	}
}