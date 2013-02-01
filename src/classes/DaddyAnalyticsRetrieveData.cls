global with sharing class DaddyAnalyticsRetrieveData {
	
	// class to orchestrate retrieving Daddy Analytics data
	public static String retrieveData(dateTime visitDate, String DA_Token) {
		
		// create string to store result of http callout
		String result = null;
		
		// query for Lead to update
		Lead matchLead =	[	Select	Lead.Id, DA_Token__c, DA_User_ID__c
								From	Lead
								Where	Lead.DA_Token__c <> '' And
										Lead.DA_Token__c <> null And
										Lead.DA_User_ID__c = null And
										Lead.DA_Token__c = :DA_Token
								limit	1
							];
			
		// if Lead is found
		if(matchLead != null) {
			
			// retrieve DA custom settings
			List<DaddyAnalytics__c> customSettings = DaddyAnalytics__c.getall().values();
		
			// if custom settings are returned
			if(customSettings.size() > 0) {
				
				String url = customSettings[0].DA_Stats_URL__c;
				String siteId = customSettings[0].DA_Site_ID__c;
				String siteKey = customSettings[0].DA_API_Key__c;
				String licenseKey = customSettings[0].DA_License_Key__c;
				String privateKey = customSettings[0].DA_Private_Key__c;
				
				// decrypt license key
				String decryptedLicenseKey = DaddyAnalyticsSecurity.decryptLicenseKey(licenseKey, privateKey);
				
				if(decryptedLicenseKey <> '') {
	
					// check license key is valid
					Boolean validLicenseKey = DaddyAnalyticsSecurity.validateLicenseKey(decryptedLicenseKey);
					
					if(validLicenseKey = true) {
						
						// extract license type form decrypted license key for use in setFields method
						Decimal licenseType = DaddyAnalyticsSecurity.licenseType(decryptedLicenseKey);
					
						// instantiate a new http request object
						Http h = new Http();
						
						// call method to build http request	
						httpRequest request = buildRequest(datetime.now(), matchLead.DA_Token__c, url, siteId, siteKey);
						
						// if a request is returned
						if(request != null) {
								
							// call method to send request and return response
							httpResponse response = sendRequest(h, request);
							
							// if a response is returned
							if(response != null) {
								
								// parse JSON and set Lead field values
								JSONParser parser = JSON.createParser(response.getBody());
								
								result = setFields(parser, matchLead, licenseType);
							}
						}
					}
				}
			}
		}
		// return DA_User_Id of Lead updated
		return result;
	}

		// method to build http request
		public static HttpRequest buildRequest(dateTime visitDate, String DA_Token, String url, String siteId, String siteKey) {
		
			// create new http request
			HttpRequest request = new HttpRequest();
				
			// specify which visitor details should be returned from http callout
			String visitorDetails = 'uid,organization,geolocation,latitude,longitude,ip_address,operating_system,web_browser,screen_resolution,session_id,time,referrer_url,referrer_search,landing_page,campaign';
				
			// set startDate and endDate values based on visitDate passed in
			String startDate = String.valueof(visitDate.addYears(-1).format('yyyy-MM-dd'));
			String endDate = String.valueof(visitDate.format('yyyy-MM-dd'));
				
			// set endpoint for http callout
			String calloutEndpoint = url + '/api/stats/4/?output=json' + '&site_id=' + siteId + '&sitekey=' + siteKey + '&type=' + 'visitors-list&visitor-details=' + visitorDetails + '&custom[DaddyAnalytics]=' + DA_Token + '&date=' + startDate + ',' + endDate;
				
			// instantiate a new HTTP request for visitor data, specify the method (GET) as well as the endpoint and parameters
			request.setEndpoint(calloutEndpoint);
			request.setMethod('GET');
		
		return request;
		}

			// method to send http callout and return response
			public static httpResponse sendRequest(Http h, httpRequest request) {

				httpResponse response = null;
		
				// send the http request and return a response
				response = h.send(request);
			
			return response;
			}
			
				// method to parse JSON, set Lead fields and create a task
				public static String setFields(JSONParser parser, Lead matchLead, Decimal licenseType) {
				
					// create list to hold new Tasks
					List<Task> newTasks = new List<Task>{};
						
					// declare variables used to store Lead and task values
					String taskDescription;
					String uId;
					String organisation;
					String estLocation;
					String geoLatitude;
					String geoLongitude;
					String ipAddress;
					String device;
					String browser;
					String resolution;
					String sessionId;
					datetime visitTime;
					String referrerWebsite;
					String searchPhrase;
					String landingPage;
					String campaignName;
					String campaignSource;
					String campaignContent;
					String campaignMedium;
					String campaignTerm;
							
					// loop through JSON tokens returned and set field values
					while(parser.nextToken() != null) {
								
					String fieldName = parser.getText();
								
					// loop through items returned in JSON token
					if(fieldName == 'Items') {
								
						while(parser.nextToken() != null) {
									
						// visitor data
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'uid')) {
																
							parser.nextToken();
							matchLead.DA_User_ID__c = parser.getText();
							uId = parser.getText();
						}
										
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'organization')) {
																		
							parser.nextToken();
							matchLead.DA_Visitor_Organisation__c = parser.getText();
							organisation = parser.getText();
						}
											
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'geolocation')) {
																		
							parser.nextToken();
							estLocation = parser.getText();
						}
																
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'latitude')) {
																		
							parser.nextToken();
							matchLead.DA_Visitor_Geolocation__Latitude__s = decimal.valueOf(parser.getText());
							geoLatitude = parser.getText();
						}
																
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'longitude')) {
																				
							parser.nextToken();
							matchLead.DA_Visitor_Geolocation__Longitude__s = decimal.valueOf(parser.getText());
							geoLongitude = parser.getText();
						}
														
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'ip_address')) {
																			
							parser.nextToken();
							ipAddress = parser.getText();
						}
																		
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'operating_system')) {
																				
							parser.nextToken();
							device = parser.getText();
						}
																			
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'web_browser')) {
																				
							parser.nextToken();
							browser = parser.getText();
						}
						
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'screen_resolution')) {
																				
							parser.nextToken();
							resolution = parser.getText();
						}
											
						// session data
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'session_id')) {
																				
							parser.nextToken();
							matchLead.DA_Session_ID__c = parser.getText();
							sessionId = parser.getText();
						}
																		
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'time')) {
																						
							parser.nextToken();
																					
							//convert unix timestamp to Salesforce dateTime
							visitTime = datetime.newInstance(0);
							integer visitInt = integer.valueOf(parser.getText());
							visitTime = visitTime.addSeconds(visitInt);
																		
							matchLead.DA_Visit_Time__c = visitTime;
						}
																
						// referrer data
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'referrer_url')) {
																						
							parser.nextToken();
													
							matchLead.DA_Referrer_Website__c = parser.getText();
							referrerWebsite = parser.getText();
						}
																					
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'referrer_search')) {
																						
							parser.nextToken();
							matchLead.DA_Referrer_Search__c = parser.getText();
												
							searchPhrase = parser.getText();
						}
																				
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'landing_page')) {
																						
							parser.nextToken();
									
							matchLead.DA_Visitor_Landing_Page__c = parser.getText();
							landingPage = parser.getText();	
						}
						
						// campaign data - only returned if user has a trial license (00001) or a license type greater than 10000
						if(licenseType == 10000 || licenseType >= 30000) {
											
							if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'name')) {
																							
								parser.nextToken();
										
								matchLead.DA_Campaign_Name__c = parser.getText();
								campaignName = parser.getText();
							}
												
							if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'source')) {
																							
								parser.nextToken();
										
								matchLead.DA_Campaign_Source__c = parser.getText();
								campaignSource = parser.getText();
							}
												
							if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'content')) {
																							
								parser.nextToken();
										
								matchLead.DA_Campaign_Content__c = parser.getText();
								campaignContent = parser.getText();
							}
												
							if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'medium')) {
																							
								parser.nextToken();
										
								matchLead.DA_Campaign_Medium__c = parser.getText();
								campaignMedium = parser.getText();	
							}
												
							if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'term')) {
																							
								parser.nextToken();
										
								matchLead.DA_Campaign_Term__c = parser.getText();
								campaignTerm = parser.getText();
							}
						}
					}
				}
				// if no referral data is returned
				if(referrerWebsite==null) {
					referrerWebsite = '';
				}
				if(searchPhrase==null) {
					searchPhrase = '';
				}
				// no campaign data returned for 'SILVER' license users
				if(campaignName==null) {
					campaignName = '';
				}
				if(campaignSource==null) {
					campaignSource = '';
				}
				if(campaignContent==null) {
					campaignContent = '';
				}
				if(campaignMedium==null) {
					campaignMedium = '';
				}
				if(campaignTerm==null) {
					campaignTerm = '';
				}
				}
						
				String line = '----------------------------------------';
						
				// set task description
				taskDescription = 'Visitor information:\n' + 'Organisation: ' + organisation + '\n' + 'Estimated Location: ' + estLocation + '\n' + 'Geolocation Latitude: ' + geoLatitude + '\n' + 'Geolocation Longitude: ' + geoLongitude + '\n' + 'IP Address: ' + ipAddress + '\n' + 'Device: ' + device + '\n' + 'Browser: ' + browser + '\n' + 'Screen Resolution: ' + resolution + '\n' + 'Visit Landing Page: ' + landingPage + '\n' + line + '\n' + 'Referrer Information:\n' + 'Website: ' + referrerWebsite + '\n' + 'Search Phrase: ' + searchPhrase + '\n' + line + '\n' + 'Campaign Information:\n' + 'Campaign Name: ' + campaignName + '\n' + 'Campaign Source: ' + campaignSource + '\n' + 'Campaign Content: ' + campaignContent + '\n' + 'Campaign Medium: ' + campaignMedium + '\n' + 'Campaign Term: ' + campaignTerm + '\n' + line + '\n' + 'Daddy Analytics Audit Fields:\n' + 'User Id: ' + uId + '\n' + 'Session Id: ' + sessionId + '\n' + 'Visit Time: ' + visitTime;
							
				// add new Task
				newTasks.add(new Task(WhoId = matchLead.Id, Subject = 'Web Visitor Information Supplied by Daddy Analytics', Priority = 'Normal', Status = 'Completed', Description = taskDescription));
						
				// update Lead
				update matchLead;
					
				// only insert new task if visitor data is returned
				if (matchLead.DA_User_ID__c != null) {
			
					insert newTasks;
				}
				return matchLead.DA_User_ID__c;
				}
		
					// class for on button click http request
					webservice static String onButtonRetrieveData(String DA_Token) {
				
						String result = retrieveData(datetime.now(), DA_Token);
				
					Return result;
	    			}

}