public with sharing class DaddyAnalyticsInsertCustomSettings 
{
	public String APIKey{get;set;}
	public String SiteId{get;set;}
	public String PageURL{get;set;}
	public String WebSiteURL{get;set;}
	public String statsURL{get;set;}
	public String licenseKey{get;set;}
	public String licenseType{get;set;}
	public String licenseTypeValue{get;set;}
	public dateTime licenseEndDate{get;set;}
	
	public String privateKey;
	public boolean validLicenseKey;
	
	public boolean showPassword{get;set;}
	public boolean showError{get;set;}
	public boolean showSuccess{get;set;}
	
	List<DaddyAnalytics__c> AnalyticsList = new List<DaddyAnalytics__c>();
	
	public DaddyAnalyticsInsertCustomSettings()
	{
		showError = false;
		showSuccess = false;
		validLicenseKey = false;
		
		AnalyticsList = [select name, 
														DA_API_Key__c,
														DA_Site_ID__c,
														DA_Test_Page_URL__c,
														DA_Website_URL__c,
														DA_Stats_URL__c,
														DA_License_Key__c,
														DA_License_Type__c,
														DA_License_Type_Value__c,
														DA_License_End_Date__c,
														DA_Private_Key__c
														from DaddyAnalytics__c limit 1];
														
		if(AnalyticsList.size()>0)
		{
			showPassword = true;
			APIKey = AnalyticsList[0].DA_API_Key__c;
			SiteId = AnalyticsList[0].DA_Site_ID__c;
			PageURL = AnalyticsList[0].DA_Test_Page_URL__c;
			WebSiteURL = AnalyticsList[0].DA_Website_URL__c;
			statsURL = AnalyticsList[0].DA_Stats_URL__c;
			licenseKey = AnalyticsList[0].DA_License_Key__c;
			licenseType = AnalyticsList[0].DA_License_Type__c;
			licenseTypeValue = AnalyticsList[0].DA_License_Type_Value__c;
			licenseEndDate = AnalyticsList[0].DA_License_End_Date__c;
			privateKey = AnalyticsList[0].DA_Private_Key__c;
			}
	}
	public void submit()
	{
		showError = false;
		DaddyAnalytics__c insertIntoDaddy = new DaddyAnalytics__c();
		
		// decrypt license key
		String decryptedLicenseKey = DaddyAnalyticsSecurity.decryptLicenseKey(licenseKey, privateKey);
		
		// validate license key
		validLicenseKey = DaddyAnalyticsSecurity.validateLicenseKey(decryptedLicenseKey);
				
		if(licenseKey != '' && validLicenseKey == false) {
			showError = true;
			showSuccess = false;
			ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Please enter a valid license key');
            ApexPages.addMessage(msg);
		}
		
		if(SiteId!=null && SiteId!='' && (SiteId.length()<7 || SiteId.length()>10 || (!(pattern.matches('[0-9]+',SiteId)))))
		{
			showError = true;
			showSuccess = false;
			ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Site Id must between 7 to 10 characters long and consist solely of numbers');
            ApexPages.addMessage(msg);
		}
		
		if(APIKey!=null && APIKey!='' && (APIKey.length()!=16))
		{
			showError = true;
			showSuccess = false;
			ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'API Key should have 16 characters');
            ApexPages.addMessage(msg);
		}
		if(PageURL!=null && PageURL!='')
        {
	        if((PageURL!=null)&&((!(pattern.matches('(^((http|https)://)??(www.)??([a-zA-Z0-9]|-)+?([.][a-zA-Z0-9(-|/|=|?)??]+?)+?$)+',PageURL.trim()))) ))
	        {
	            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Page URL is not valid');
	            ApexPages.addMessage(msg);
	            showError = true;
				showSuccess = false;
	        }
         }
		  
        if(WebSiteURL!=null && WebSiteURL!='')
        {      
	        if((WebSiteURL!=null)&&((!(pattern.matches('(^((http|https)://)??(www.)??([a-zA-Z0-9]|-)+?([.][a-zA-Z0-9(-|/|=|?)??]+?)+?$)+',WebSiteURL.trim()))) ))
	        {
	            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,'Website URL is not valid');
	            ApexPages.addMessage(msg);
	            showError = true;
				showSuccess = false;
	        }  
        }
         
		if(!showError) {
			
			if(AnalyticsList.size()==0)
			{
				if(showSuccess = true)
				{
					licenseType = String.valueOf(DaddyAnalyticsSecurity.licenseType(decryptedLicenseKey));
					licenseTypeValue = DaddyAnalyticsSecurity.licenseTypeValue(licenseType);
					licenseEndDate = DaddyAnalyticsSecurity.licenseEndDate(decryptedLicenseKey);
					
					insertIntoDaddy.Name = 'DaddyAnalytics';
					insertIntoDaddy.DA_API_Key__c = APIKey;
					insertIntoDaddy.DA_Site_ID__c = SiteId;
					insertIntoDaddy.DA_Test_Page_URL__c = PageURL;
					insertIntoDaddy.DA_Website_URL__c = WebSiteURL;
					insertIntoDaddy.DA_Stats_URL__c = statsURL;
					insertIntoDaddy.DA_License_Key__c = licenseKey;
					insertIntoDaddy.DA_License_Type__c = licenseType;
					insertIntoDaddy.DA_License_Type_Value__c = licenseTypeValue;
					insertIntoDaddy.DA_License_End_Date__c = licenseEndDate;
					insertIntoDaddy.DA_Private_Key__c = privateKey;
					
					insert insertIntoDaddy;
					showSuccess = true;
				}
			}
			else
			{
				licenseType = String.valueOf(DaddyAnalyticsSecurity.licenseType(decryptedLicenseKey));
				licenseTypeValue = DaddyAnalyticsSecurity.licenseTypeValue(licenseType);
				licenseEndDate = DaddyAnalyticsSecurity.licenseEndDate(decryptedLicenseKey);
				
				AnalyticsList[0].DA_API_Key__c = APIKey;
				AnalyticsList[0].DA_Site_ID__c = SiteId;
				AnalyticsList[0].DA_Test_Page_URL__c = PageURL;
				AnalyticsList[0].DA_Website_URL__c = WebSiteURL;
				AnalyticsList[0].DA_Stats_URL__c = statsURL;
				AnalyticsList[0].DA_License_Key__c = licenseKey;
				AnalyticsList[0].DA_License_Type__c = licenseType;
				AnalyticsList[0].DA_License_Type_Value__c = licenseTypeValue;
				AnalyticsList[0].DA_License_End_Date__c = licenseEndDate;
				AnalyticsList[0].DA_Private_Key__c = privateKey;
				
				update AnalyticsList[0];
				showSuccess = true;
			}
		}
	}
}