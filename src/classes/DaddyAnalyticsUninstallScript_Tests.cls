@isTest

public with sharing class DaddyAnalyticsUninstallScript_Tests {
	
	static testMethod void testUninstallScript() {
			
		// insert test custom settings   		
		DaddyAnalyticsInsertCustomSettings i = new DaddyAnalyticsInsertCustomSettings();
    	
    	String OrgId = UserInfo.getOrganizationId();
        
   		i.APIKey = 'TeStTeStTeStTeSt';
    	i.SiteId = '987654321';
    	i.PageURL = 'http://testurl.com';
    	i.WebSiteURL ='http://testurl.com/web-to-lead';
    	String encryptedLicenseKey = DaddyAnalyticsSecurity.encryptLicenseKey(10000, dateTime.valueOf('2050-01-01 00:00:00'), 'TeStTeStTeStTeStTeStTeStTeStTeSt', OrgId);
    	i.licenseKey = encryptedLicenseKey;
    	i.privateKey = 'TeStTeStTeStTeStTeStTeStTeStTeSt';
        
    	i.submit();
		
		Test.testUninstall(new DaddyAnalyticsUninstallScript());
		
		List<DaddyAnalytics__c> testSettingsList = new List<DaddyAnalytics__c>();
        
        testSettingsList =	[	select	DA_Stats_URL__c
								from	DaddyAnalytics__c
								limit	1
							];

        System.assertEquals(testSettingsList.size(), 0);
	}
}