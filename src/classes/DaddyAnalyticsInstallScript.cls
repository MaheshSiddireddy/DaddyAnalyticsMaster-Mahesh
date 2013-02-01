public with sharing class DaddyAnalyticsInstallScript implements InstallHandler {
	
	public void onInstall(InstallContext context) {
    	    	
    // check if Daddy Analytics custom settings already exist
    List<DaddyAnalytics__c> DASettings = new List<DaddyAnalytics__c>();
    	
	   DASettings =	[	select	Id
						from	DaddyAnalytics__c
					];
	
	// if settings exists delete them					
	if(DASettings.size() > 0) {
		
		delete DASettings;
	}
	
	// Create new custom settings with demo license key  	
	DaddyAnalyticsInsertCustomSettings i = new DaddyAnalyticsInsertCustomSettings();
		   		
	String privateKey = 'mX4YGt+k4SFwUBIKgOiDj/hNLRVjU1JE';
	String demoLicenseKey = DaddyAnalyticsSecurity.encryptLicenseKey(10000, datetime.now().addDays(30), privateKey, UserInfo.getOrganizationId());
		        
	i.APIKey = '';
	i.SiteId = '';
	i.PageURL = '';
	i.WebSiteURL ='';
	i.StatsURL = 'http://stats.daddyanalytics.com';
	i.licenseKey = demoLicenseKey;
	i.privateKey = privateKey;
		        
	i.submit();
    }
}