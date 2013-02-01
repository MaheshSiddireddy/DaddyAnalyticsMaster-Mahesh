@isTest
	
public with sharing class DaddyAnalyticsInstallationChecks_Tests {

    static testMethod void runInstallationChecksTests() {
    	
        DaddyAnalytics__c d = new DaddyAnalytics__c ();
        
        d.DA_API_Key__c = 'TeStTeStTeStTeSt';
        d.DA_Site_ID__c = '123456789';
        d.DA_Website_URL__c = 'http://testurl.com';
        d.DA_Test_Page_URL__c = 'http://testurl.com/web-to-lead';
        d.DA_Stats_URL__c = 'http://testurl.com/web-to-lead';
        d.DA_License_Key__c = 'vxb3xG3Wq0QFuAfgaOZks2NQN/G1udai8BnxUL/JAkbWjdnObUJ/GoAQXrS/UKE3';
        d.DA_Private_Key__c = 'TeStTeStTeStTeStTeStTeStTeStTeSt';
        d.name = 'Test Settings';
        
        insert d;
        
        // set mock class for testing
		Test.setMock(HttpCalloutMock.class, new DaddyAnalyticsMockHttpCallout());
        
        DaddyAnalyticsInstallationChecks i = new DaddyAnalyticsInstallationChecks();
        
        System.assertEquals(true,i.getshowEx2());
        System.assertEquals(true,i.getshowEx3());
        i.getshowEx4();
        i.getshowEx6();
        i.getshowEx7();
        i.getshowEx8();
        i.getshowEx9();
        i.getshowEx10();
    }
}