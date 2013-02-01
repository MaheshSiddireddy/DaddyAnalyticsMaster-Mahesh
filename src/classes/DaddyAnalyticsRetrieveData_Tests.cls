@isTest

public with sharing class DaddyAnalyticsRetrieveData_Tests {
	
	// test DaddyAnalyticsRetrieveData buildRequest and sendRequest methods
	static testMethod void runRequestTests() {
		
		// set mock class for testing
		Test.setMock(HttpCalloutMock.class, new DaddyAnalyticsMockHttpCallout());
		
		// instantiate a new http request object
		Http h = new Http();
					
		// test httpCalloutBuildRequest method	
		httpRequest request = DaddyAnalyticsRetrieveData.buildRequest(date.valueOf('2012-12-05 12:00:00'), '1354633180048-8168113', 'http://stats.daddyanalytics.com', '100547823', '3a9457200b302e70');
		
		String actualRequestBody = request.getEndpoint();
		String expectedRequestBody = 'http://stats.daddyanalytics.com/api/stats/4/?output=json&site_id=100547823&sitekey=3a9457200b302e70&type=visitors-list&visitor-details=uid,organization,geolocation,latitude,longitude,ip_address,operating_system,web_browser,session_id,time,referrer_url,referrer_search,landing_page,campaign&custom[DaddyAnalytics]=1354633180048-8168113&date=2011-12-04,2012-12-04';
		
		// check request created is as expected
		System.assertEquals(expectedRequestBody, actualRequestBody);
		
		// test httpCalloutSendRequest method
		HttpResponse response = DaddyAnalyticsRetrieveData.sendRequest(h, request);

		String actualResponseBody = response.getBody();
		String expectedResponseBody = '[{"items": [{"time":"1353946876", "ip_address":"87.236.134.93", "uid":"2990163675", "session_id":"1213232622", "landing_page":"http://daddyanalyticstest.luminousinc.com/", "web_browser":"Safari 6.0", "operating_system":"Mac OS X", "referrer_url":"http://referrer.luminousinc.com/", "geolocation":"London, The United Kingdom", "latitude":"51.5142", "longitude":"-0.0931", "organization":"Excell Hosted Customers Cn", "campaign": {"name":"General Ad Campaign", "source":"bing", "medium":"cpc", "content":"marketing solutions for salesforce", "term":"salesforce campaign tracking"}}]}]';
		
		// check response recieved is as expected
		System.assertEquals(expectedResponseBody, actualResponseBody);
	}

		// test DaddyAnalyticsRetrieveData setFields method
		static testMethod void runSetFieldsTests() {	
			
			// test httpCalloutSetFields method 
			JSONParser parser = JSON.createParser('[{"items": [{"time":"1353946876", "ip_address":"87.236.134.93", "uid":"2990163675", "session_id":"1213232622", "landing_page":"http://daddyanalyticstest.luminousinc.com/", "web_browser":"Safari 6.0", "operating_system":"Mac OS X", "referrer_url":"http://referrer.luminousinc.com/", "geolocation":"London, The United Kingdom", "latitude":"51.5142", "longitude":"-0.0931", "organization":"Excell Hosted Customers Cn", "campaign": {"name":"General Ad Campaign", "source":"bing", "medium":"cpc", "content":"marketing solutions for salesforce", "term":"salesforce campaign tracking"}}]}]');
			
			// create test Lead
			List<Lead> setFieldsTestLeads = new List<Lead>{};
				
			for (Integer i = 0; i < 1; i++) {
				
				setFieldsTestLeads.add(new Lead(DA_Token__c = '1353941466870-5538515', Company = 'DA Http Callout Test' + i, FirstName = 'DA', LastName = 'HttpCalloutTest' + i, Email = 'DA@CalloutTest' + i + '.com'));
			}
			
			insert setFieldsTestLeads;
	
			String setFieldsResult = DaddyAnalyticsRetrieveData.setFields(parser, setFieldsTestLeads[0], 10000);
			
			// check Lead has been updated as expected
			System.assertEquals('2990163675', setFieldsTestLeads[0].DA_User_ID__c);
		}
	
			// run exception tests
			static testMethod void runRetrieveDataExceptionTests() {
				
				// call retrieveData method with Lead that doesn't need updating
				// create test Lead
				List<Lead> retrieveDataExceptionTestLeads = new List<Lead>{};
					
				for (Integer i = 0; i < 1; i++) {
					
					retrieveDataExceptionTestLeads.add(new Lead(DA_Token__c = '1353941466870-5538515', DA_User_Id__c = 'TestId', Company = 'DA Http Callout Test' + i, FirstName = 'DA', LastName = 'HttpCalloutTest' + i, Email = 'DA@CalloutTest' + i + '.com'));
				}
				
				insert retrieveDataExceptionTestLeads;
				
				// call retrieveData method, the Lead doesn't need updating so this should fail
				try {
						String setFieldsResult = DaddyAnalyticsRetrieveData.retrieveData(date.valueOf('2012-12-05 12:00:00'), retrieveDataExceptionTestLeads[0].DA_Token__c);
								
					} catch(Exception e) {
									
						string retrieveException = String.ValueOf(e);
									
						// check exception message recieved was as expected
						System.assertEquals('System.QueryException: List has no rows for assignment to SObject', retrieveException);			
						}
			}
	
				// run DaddyAnalyticsRetrieveDataBatch tests
				static testMethod void runRetrieveDataBatchTests() {
					
				// create test Lead
				List<Lead> retrieveDataBatchTestLeads = new List<Lead>{};
						
				for (Integer i = 0; i < 1; i++) {
						
					retrieveDataBatchTestLeads.add(new Lead(DA_Token__c = '1353941466870-5538515', Company = 'DA Http Callout Test' + i, FirstName = 'DA', LastName = 'HttpCalloutTest' + i, Email = 'DA@CalloutTest' + i + '.com'));
				}
				
				insert retrieveDataBatchTestLeads;
				
				// set mock class for testing
				Test.StartTest();
				
					DaddyAnalyticsRetrieveDataBatch scheduledTestBatch = new DaddyAnalyticsRetrieveDataBatch();
			   		ID testBatchId = database.executeBatch(scheduledTestBatch,1);
			    
			    Test.StopTest();
			    
			    // get the information from the CronTrigger API object 
				AsyncApexJob testBatch =	[	
				      							SELECT	Id, Status
				        						FROM	AsyncApexJob
				        						WHERE	Id = :testBatchId
				        					];
			    
			    // check batch has completed succesfully
			    System.assertEquals('Completed',testBatch.Status);
				}
	
					// run DaddyAnalyticsRetrieveDataScheduled tests
					static testMethod void runRetrieveDataScheduledTests() {
						
						// create a new scheduled job
						Test.StartTest();
						
							String jobId = System.schedule('DaddyAnalyticsRetrieveDataScheduled', DaddyAnalyticsRetrieveDataScheduled.CRON_EXP, new DaddyAnalyticsRetrieveDataScheduled());
					     
					  	Test.StopTest();
					        
					   	// get the information from the CronTrigger API object 
					    CronTrigger cronTrig =	[	
					      							SELECT	Id, CronExpression, TimesTriggered
					        						FROM	CronTrigger
					        						WHERE	Id = :jobId
					        					];
					
					   	// check the expressions are the same
					    System.assertEquals(DaddyAnalyticsRetrieveDataScheduled.CRON_EXP, cronTrig.CronExpression);
					}
	
						/* run DaddyAnalyticsRetrieveDataScheduled class onButtonRetrieveDataBatch methodtests
						static testMethod void runOnButtonRetrieveDataScheduledTests() {
							
							// create test Lead
							List<Lead> onButtonTestLeads = new List<Lead>{};
									
							for (Integer i = 0; i < 1; i++) {
									
								onButtonTestLeads.add(new Lead(DA_Token__c = '1353941466870-5538515', Company = 'DA Http Callout Test' + i, FirstName = 'DA', LastName = 'HttpCalloutTest' + i, Email = 'DA@CalloutTest' + i + '.com'));
							}
							
							insert onButtonTestLeads;
							
							Test.StartTest();
							
						    	ID testBatchId = DaddyAnalyticsRetrieveDataBatch.onButtonRetrieveDataBatch();
						    
						    Test.StopTest();
						    
						    // get the information from the CronTrigger API object 
							AsyncApexJob testBatch =	[	
							      							SELECT	Id, Status
							        						FROM	AsyncApexJob
							        						WHERE	Id = :testBatchId
							        					];
						    
						    // check the batch has completed succesfully
						    System.assertEquals('Completed',testBatch.Status);
						}*/
}