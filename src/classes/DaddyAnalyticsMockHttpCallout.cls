// mock http callout class used for testing DaddyAnalyticsHttpCallout class

public with sharing class DaddyAnalyticsMockHttpCallout implements HttpCalloutMock {
	
	public HttpResponse respond(HttpRequest mockRequest) {
		
	// create a mock response
	HttpResponse mockResponse = new HttpResponse();
	
	mockResponse.setHeader('Content-Type', 'application/json');
	mockResponse.setBody('[{"items": [{"time":"1353946876", "ip_address":"87.236.134.93", "uid":"2990163675", "session_id":"1213232622", "landing_page":"http://daddyanalyticstest.luminousinc.com/", "web_browser":"Safari 6.0", "operating_system":"Mac OS X", "referrer_url":"http://referrer.luminousinc.com/", "geolocation":"London, The United Kingdom", "latitude":"51.5142", "longitude":"-0.0931", "organization":"Excell Hosted Customers Cn", "campaign": {"name":"General Ad Campaign", "source":"bing", "medium":"cpc", "content":"marketing solutions for salesforce", "term":"salesforce campaign tracking"}}]}]');
	mockResponse.setStatusCode(200);
	
	// return response
	return mockResponse;
	}
}