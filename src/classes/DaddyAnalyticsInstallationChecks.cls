public with sharing class DaddyAnalyticsInstallationChecks 
{
	public boolean showEx1{get;set;}
	public boolean showEx22{get;set;}
	public boolean showEx33{get;set;}
	public boolean showEx44{get;set;}
	public boolean showEx55{get;set;}
	public boolean showEx66{get;set;}
	public boolean showEx77{get;set;}
	public boolean showEx88{get;set;}
	public boolean showEx99{get;set;}
	public boolean showEx1010{get;set;}
	public boolean showEx1111{get;set;}
	public boolean showEx1212{get;set;}
	public boolean showEx2 = false;
	public String TestPageURL{get;set;}
	public String WebSiteURL{get;set;}
	public String APIKey{get;set;}
	public String SiteID{get;set;}
	public String licenseKey{get;set;}
	public String licenseType{get;set;}
	
	public String privateKey;
	public String statsURL;
	
	public DaddyAnalyticsInstallationChecks()
	{
		showEx1 = false;
		showEx22 = false;
		showEx33 = false;
		showEx44 = false;
		showEx55 = false;
		showEx66 = false;
		showEx77 = false;
		showEx88 = false;
		showEx99 = false;
		showEx1010 = false;
		showEx1111 = false;
		showEx1212 = false;
		
		List<DaddyAnalytics__c> AnalyticsList = [	select	name, 
															DA_API_Key__c,
															DA_Site_ID__c,
															DA_Test_Page_URL__c,
															DA_Website_URL__c,
															DA_Stats_URL__c,
															DA_License_Key__c,
															DA_Private_Key__c
													from	DaddyAnalytics__c
													limit 1
												];
														
		if(AnalyticsList.size()>0)
		{
			APIKey = AnalyticsList[0].DA_API_Key__c;
			SiteID = AnalyticsList[0].DA_Site_ID__c;
			TestPageURL = AnalyticsList[0].DA_Test_Page_URL__c;
			statsURL = AnalyticsList[0].DA_Stats_URL__c;
			licenseKey = AnalyticsList[0].DA_License_Key__c;
			privateKey = AnalyticsList[0].DA_Private_Key__c;
			
			// decrypt license key
			String decryptedLicenseKey = DaddyAnalyticsSecurity.decryptLicenseKey(licenseKey, privateKey);
		
			// validate license key	
			Boolean validLicenseKey = DaddyAnalyticsSecurity.validateLicenseKey(decryptedLicenseKey);
			
			if(licenseKey != '' && validLicenseKey == true) {
				
				showEx1 = true;
			}
			
			if(AnalyticsList[0].DA_API_Key__c!=null && AnalyticsList[0].DA_Site_ID__c!=null && AnalyticsList[0].DA_Website_URL__c!=null)
			{
				showEx22 = true;
			}
		}
	}
	
	// To check the remote site settings for DaddyAnalytics URL
	public boolean getshowEx2()
	{
		boolean showEx21 = false;
		Http h=new Http();
    	HttpResponse res = new HttpResponse();
    	HttpRequest req= new HttpRequest();
    	req.setEndpoint(statsURL);
    	req.setMethod('POST'); 
    	try {
        	res = h.send(req);
    	}
    	catch(System.CalloutException e) {
        	System.debug('Callout error: '+ e);
        	if(String.valueOf(e).contains('Unauthorized endpoint'))
        	{
        		showEx21 = true;
        	}
        	
		}
		
		if(showEx22 && !showEx21)
		{
			showEx2 = true;
			return true;
		}
		else
		{
			showEx2 = false;
			return false;
		}
	}
	
	// To check Remote site settings for Test URL and Web Site URL
	public boolean showEx31{get;set;}
	public boolean showEx32{get;set;}
	public boolean getshowEx3()
	{
		showEx31 = false; showEx32 = false;
		if(showEx22 && showEx2)
		{
			List<DaddyAnalytics__c> AnalyticsList = [select name, 
														DA_API_Key__c,
														DA_Site_ID__c,
														DA_Test_Page_URL__c,
														DA_Website_URL__c
														from DaddyAnalytics__c limit 1];

			if(AnalyticsList.size()>0)
			{
				APIKey = AnalyticsList[0].DA_API_Key__c;
				SiteID = AnalyticsList[0].DA_Site_ID__c;
				if(AnalyticsList[0].DA_Test_Page_URL__c != null)
				{
					TestPageURL = AnalyticsList[0].DA_Test_Page_URL__c;
					Http h=new Http();
			    	HttpResponse res = new HttpResponse();
			    	HttpRequest req= new HttpRequest();
			    	req.setEndpoint(AnalyticsList[0].DA_Test_Page_URL__c);
			    	req.setMethod('POST');
			    	try {
			        	res = h.send(req);
			    	}
			    	
			    	catch(System.CalloutException e) {
			        	System.debug('Callout error: '+ e);
			        	
			        	if(String.valueOf(e).contains('Unauthorized endpoint'))
			        	{
			        		showEx31 = true;
			        	}

					}
				}
				if(AnalyticsList[0].DA_Test_Page_URL__c != null)
				{
					WebSiteURL = AnalyticsList[0].DA_Website_URL__c;
					Http h=new Http();
			    	HttpResponse res = new HttpResponse();
			    	HttpRequest req= new HttpRequest();
			    	req.setEndpoint(AnalyticsList[0].DA_Website_URL__c);
			    	req.setMethod('POST');
			    	try {
			        	res = h.send(req);
			    	}
			    	
			    	catch(System.CalloutException e) {
			        	
			        	if(String.valueOf(e).contains('Unauthorized endpoint'))
			        	{
			        		showEx32 = true;
			        	}

					}
				}

			}
		}
		if(showEx31 || showEx32)
		{
			showEx33 = false;
			return false;
		}
		else
		{

			showEx33 = true;
			return true;
		}
	}
	
	public boolean getshowEx4()
	{
					Http h=new Http();
			    	HttpResponse res = new HttpResponse();
			    	HttpRequest req= new HttpRequest();
			    	req.setEndpoint(statsURL+'/api/stats/4?site_id='+SiteID+'&sitekey='+APIKey+'&type=visitors-list');
			    	req.setMethod('GET');
			    	req.setHeader('Content-Length', '1024');
			    	req.setHeader('Content-Type', 'json');
			    	req.setBody('Hello');
			    	try {
			    		if(!Test.isRunningTest())
			        	res = h.send(req);
			        	System.debug('********************'+res.getBody());
			        	
			        	if(res.getBody().contains('<type type="visitors-list">'))
			        	{
			        		showEx44 = true;
			        	}
			        	else
			        	{
			        		showEx44 = false;
			        	}
			    	}
			    	catch(System.CalloutException e) {
			        	System.debug('Callout error: '+ e);
			        }
					return showEx44;
	}
	
	public boolean getshowEx6()
	{
		showEx66 = false;
					Http h=new Http();
			    	HttpResponse res = new HttpResponse();
			    	HttpRequest req= new HttpRequest();
			    	req.setEndpoint(statsURL+'/api/stats/4?site_id='+SiteID+'&sitekey='+APIKey+'&type=visitors&output=json');
			    	req.setMethod('GET');
			    	req.setHeader('Content-Length', '1024');
			    	req.setHeader('Content-Type', 'json');
			    	req.setBody('Hello');
			    	try {
			    		if(!Test.isRunningTest())
			        	res = h.send(req);
			        	System.debug('********************'+res.getBody());
			        	JSONParser parser = JSON.createParser(res.getBody());
			        	 while (parser.nextToken() != null) {
    	
					    	 if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
					                (parser.getText() == 'value')) {
					                	parser.nextToken();
					                	System.debug('###################'+parser.getText());
					                	if(Integer.valueOf(parser.getText())!=0)
					                	{
					                		showEx66 = true;
					                	}
					                }
			        	 }
			        	
			        	
			    	}
			    	catch(System.CalloutException e) {
			        	System.debug('Callout error: '+ e);
			        }
					return showEx66;
	}
	
	public boolean getshowEx7()
	{
		showEx77 = false;
					Http h=new Http();
			    	HttpResponse res = new HttpResponse();
			    	HttpRequest req= new HttpRequest();
			    	req.setEndpoint(statsURL+'/api/stats/4?site_id='+SiteID+'&sitekey='+APIKey+'&type=campaigns&date=last-7-days&output=json');
			    	req.setMethod('GET');
			    	req.setHeader('Content-Length', '1024');
			    	req.setHeader('Content-Type', 'json');
			    	req.setBody('Hello');
			    	try {
			    		if(!Test.isRunningTest())
			        	res = h.send(req);
			        	System.debug('******************** Stony'+res.getBody());
			        	JSONParser parser = JSON.createParser(res.getBody());
			        	 while (parser.nextToken() != null) {
    	
					    	 if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
					                (parser.getText() == 'items')) {
					                	parser.nextToken();
					                	String firstText = parser.getText();
					                	parser.nextToken();
					                	String secondText = parser.getText();
					                	System.debug('******************** Mahesh'+parser.getText());
					                	if(firstText=='[' && secondText == ']' )
					                	{
					                		showEx77 = false;
					                	}
					                	else
					                	{
					                		showEx77 = true;
					                	}
					                	
					                }
			        	 }
			        	
			        	
			    	}
			    	catch(System.CalloutException e) {
			        	System.debug('Callout error: '+ e);
			        }
					return showEx77;
	}
	
	public boolean getshowEx8()
	{
		showEx88 = false;
					if(TestPageURL!=null)
					{
						showEx88 = true;
					}
					return showEx88;
	}
	
	public boolean showEx991{get;set;}
	public boolean getshowEx9()
	{
		showEx991 = false;
		Http h=new Http();
			    	HttpResponse res = new HttpResponse();
			    	HttpRequest req= new HttpRequest();
			    	if(WebSiteURL!=null)
			    	{
			    	req.setEndpoint(WebSiteURL);
			    	req.setMethod('GET');
			    	
			    	
			    	try {
			    		if(!Test.isRunningTest())
			        	res = h.send(req);
			        	String s = '';
			        	s = res.getBody();
			        	if(s.contains(SiteID))
			        	{
			        		showEx99 = true;
			        	}
			        	else
			        	{
			        		showEx99 = false;
			        	}
			        	if((s.contains('clicky.init') || s.contains('clicky_site_id') || s.contains(SiteID+'ns.gif')))
			        	{
			        		showEx991 = true;
			        	}
			        	else
			        	{
			        		showEx991 = false;
			        	}
			        	
			    	}
			    	catch(System.CalloutException e) {
			        	System.debug('Callout error: '+ e);
			        }
			    	}
			    	
			    	if(showEx99 && showEx991)
			    	{
			    		return true;
			    	}
			    	else
			    	{
			    		return false;
			    	}
		
	}
	
	public boolean getshowEx10()
	{
		Http h=new Http();
			    	HttpResponse res = new HttpResponse();
			    	HttpRequest req= new HttpRequest();
			    	req.setEndpoint(TestPageURL);
			    	req.setMethod('GET');
			    	
			    	
			    	try {
			    		if(!Test.isRunningTest())
			        	res = h.send(req);
			        	String s = res.getBody();
			        	if(s.contains('utm_custom[DaddyAnalytics]'))
			        	{
			        		showEx1010 = true;
			        	}
			        	if(s.contains('document.forms[i].elements[\'00N') && s.contains('type=hidden name="00N'))
			        	{
			        		showEx1111 = true;
			        	}
			        	if(s.contains('//document.write(\'<BR><div style="background-color:yellow; color:#000000; border:5px solid black; padding:20px"><H1 style="text-align: center">Troubleshooting Info</H1>') || s.contains('// document.write(\'<BR><div style="background-color:yellow; color:#000000; border:5px solid black; padding:20px"><H1 style="text-align: center">Troubleshooting Info</H1>'))
			        	{
			        		showEx1212 = true;
			        	}
			        	System.debug('********************'+res.getBody());
			    	}
			    	catch(System.CalloutException e) {
			        	System.debug('Callout error: '+ e);
			        }
		return showEx1010;
	}
}