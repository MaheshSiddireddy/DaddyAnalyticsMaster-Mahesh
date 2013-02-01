@isTest

public with sharing class DaddyAnalyticsSecurity_Tests {
	
	static testMethod void runSecurityTests() {
	
		// test values
		dateTime licenseEndDate = dateTime.valueOf('2050-01-01 00:00:00');
		Decimal licenseType = 10000;
		String licenseOrgId = UserInfo.getOrganizationId();
		String licenseValues = licenseType + '&' + String.valueOf(licenseEndDate) + '%' + licenseOrgId;
		String privateKey = 'TeStTeStTeStTeStTeStTeStTeStTeSt';
		
		// test encryption and decryption methods
		String encryptedLicenseKey = DaddyAnalyticsSecurity.encryptLicenseKey(licenseType, licenseEndDate, privateKey, licenseOrgId);
		String decryptedLicenseKey = DaddyAnalyticsSecurity.decryptLicenseKey(encryptedLicenseKey, privateKey);
		System.assertEquals(licenseValues, decryptedLicenseKey);
		
		// test validate license method
		Boolean validLicenseKey = DaddyAnalyticsSecurity.validateLicenseKey(decryptedLicenseKey);
		System.assertEquals(true, validLicenseKey);
		
		// test license type method
		Decimal licenseTypeReturned = DaddyAnalyticsSecurity.licenseType(licenseValues);
		System.assertEquals(licenseType, licenseTypeReturned);
		
		// test license end date method
		dateTime licenseEndDateReturned = DaddyAnalyticsSecurity.licenseEndDate(licenseValues);
		System.assertEquals(licenseEndDate, licenseEndDateReturned);
	}
}