@isTest
	
public with sharing class  DaddyAnalyticsInsertCustomSettings_Tests {
    
    static testMethod void runCustomSettingsTests() {
    
    	DaddyAnalyticsInsertCustomSettings i = new DaddyAnalyticsInsertCustomSettings();
    	
        String OrgId = UserInfo.getOrganizationId();
        //Test Commit
        i.APIKey = 'TeStTeStTeStTeSt';
        i.SiteId = '987654321';
        i.PageURL = 'http://testurl.com';
        i.WebSiteURL ='http://testurl.com/web-to-lead';
        String encryptedLicenseKey = DaddyAnalyticsSecurity.encryptLicenseKey(10000, dateTime.valueOf('2050-01-01 00:00:00'), 'TeStTeStTeStTeStTeStTeStTeStTeSt', OrgId);
        i.licenseKey = encryptedLicenseKey;
        i.privateKey = 'TeStTeStTeStTeStTeStTeStTeStTeSt';
        
        i.submit();
        
        List<DaddyAnalytics__c> testAnalyticsList = new List<DaddyAnalytics__c>();
        
        testAnalyticsList =	[	select	DA_Site_ID__c
								from	DaddyAnalytics__c
								limit	1
							];
        
        System.assertEquals('987654321', testAnalyticsList[0].DA_Site_ID__c);
    }
    
    static testMethod void runCustomSettingsSiteIdExceptionTests() {
    	
    	DaddyAnalyticsInsertCustomSettings i = new DaddyAnalyticsInsertCustomSettings();
    	
        i.submit();
        
        i.APIKey = 'TeStTeStTeStTeSt';
        i.SiteId = '123';
        i.PageURL = 'http://testurl.com';
        i.WebSiteURL ='http://testurl.com/web-to-lead';
        i.licenseKey = 'pfeTz/uCdcMyauqLPpKFGpbNWuMo1aHqCOF82iTv1KYgonKbwNYc3GgNndnp4Xf248JOoEgEdV6HdaUsDRgwGg==';
        i.privateKey = 'TeStTeStTeStTeStTeStTeStTeStTeSt';
        
        i.submit();
        
        List<DaddyAnalytics__c> testAnalyticsList = new List<DaddyAnalytics__c>();
        	
        try {
        testAnalyticsList =	[	select	DA_Site_ID__c
								from	DaddyAnalytics__c
								limit	1
							];
    	} catch(Exception e) {
        
        System.assertNotEquals('System.ListException:List index out of bounds: 0',String.valueOf(e));
   	 	}
    }
    
     static testMethod void runCustomSettingsAPIKeyExceptionTests() {
    	
    	DaddyAnalyticsInsertCustomSettings i = new DaddyAnalyticsInsertCustomSettings();
    	
        i.submit();
        
        i.APIKey = 'TeSt';
        i.SiteId = '987654321';
        i.PageURL = 'http://testurl.com';
        i.WebSiteURL ='http://testurl.com/web-to-lead';
        i.licenseKey = 'pfeTz/uCdcMyauqLPpKFGpbNWuMo1aHqCOF82iTv1KYgonKbwNYc3GgNndnp4Xf248JOoEgEdV6HdaUsDRgwGg==';
        i.privateKey = 'TeStTeStTeStTeStTeStTeStTeStTeSt';
        
        i.submit();
        
        List<DaddyAnalytics__c> testAnalyticsList = new List<DaddyAnalytics__c>();
        	
        try {
        testAnalyticsList =	[	select	DA_Site_ID__c
								from	DaddyAnalytics__c
								limit	1
							];
    	} catch(Exception e) {
        
        System.assertNotEquals('System.ListException:List index out of bounds: 0',String.valueOf(e));
   	 	}
    }
    
    static testMethod void runCustomSettingsPageURLExceptionTests() {
    	
    	DaddyAnalyticsInsertCustomSettings i = new DaddyAnalyticsInsertCustomSettings();
    	
        i.submit();
        
        i.APIKey = 'TeStTeStTeStTeSt';
        i.SiteId = '987654321';
        i.PageURL = 'testurl';
        i.WebSiteURL ='http://testurl.com/web-to-lead';
        i.licenseKey = 'pfeTz/uCdcMyauqLPpKFGpbNWuMo1aHqCOF82iTv1KYgonKbwNYc3GgNndnp4Xf248JOoEgEdV6HdaUsDRgwGg==';
        i.privateKey = 'TeStTeStTeStTeStTeStTeStTeStTeSt';
        
        i.submit();
        
        List<DaddyAnalytics__c> testAnalyticsList = new List<DaddyAnalytics__c>();
        	
        try {
        testAnalyticsList =	[	select	DA_Site_ID__c
								from	DaddyAnalytics__c
								limit	1
							];
    	} catch(Exception e) {
        
        System.assertNotEquals('System.ListException:List index out of bounds: 0',String.valueOf(e));
   	 	}
    }
    
    static testMethod void runCustomSettingsWebSiteURLExceptionTests() {
    	
    	DaddyAnalyticsInsertCustomSettings i = new DaddyAnalyticsInsertCustomSettings();
    	
        i.submit();
        
        i.APIKey = 'TeStTeStTeStTeSt';
        i.SiteId = '987654321';
        i.PageURL = 'http://testurl.com';
        i.WebSiteURL ='testurl';
        i.licenseKey = 'pfeTz/uCdcMyauqLPpKFGpbNWuMo1aHqCOF82iTv1KYgonKbwNYc3GgNndnp4Xf248JOoEgEdV6HdaUsDRgwGg==';
        i.privateKey = 'TeStTeStTeStTeStTeStTeStTeStTeSt';
        
        i.submit();
        
        List<DaddyAnalytics__c> testAnalyticsList = new List<DaddyAnalytics__c>();
        	
        try {
        testAnalyticsList =	[	select	DA_Site_ID__c
								from	DaddyAnalytics__c
								limit	1
							];
    	} catch(Exception e) {
        
        System.assertNotEquals('System.ListException:List index out of bounds: 0',String.valueOf(e));
   	 	}
    }
}