@isTest

public with sharing class DaddyAnalyticsInstallScript_Tests {
	
	static testMethod void testInstallScript() {
		
		DaddyAnalyticsInstallScript daddyTestInstall = new DaddyAnalyticsInstallScript();
		
		Test.testInstall(daddyTestInstall, new Version(1,0));
		
		List<DaddyAnalytics__c> testSettingsList = new List<DaddyAnalytics__c>();
        
        testSettingsList =	[	select	DA_Stats_URL__c
								from	DaddyAnalytics__c
								limit	1
							];

        System.assertEquals('http://stats.daddyanalytics.com', testSettingsList[0].DA_Stats_URL__c);
	}
}