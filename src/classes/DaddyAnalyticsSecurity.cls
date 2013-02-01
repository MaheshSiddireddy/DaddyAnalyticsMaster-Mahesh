public with sharing class DaddyAnalyticsSecurity {
	
	// method to encrypt DA license key using supplied license type and license end date values and private key
	public static String encryptLicenseKey(Decimal licenseType, dateTime licenseEndDate, String privateKey, String licenseOrgId) {
		
		String encryptedLicenseKeyString;
		
		// try to encrypt DA license key
		try {
			// private key value
			Blob cryptoKey = Blob.valueOf(privateKey);
			
			// generate data to be encrypted
			Blob licenseValues = Blob.valueOf(licenseType + '&' + String.valueOf(licenseEndDate) + '%' + licenseOrgId);
			
			// encrypt license values and have Salesforce.com generate the initialization vector
			Blob encryptedLicenseKey = Crypto.encryptWithManagedIV('AES256', cryptoKey, licenseValues);
			
			// convert encrypted license key blob to string
			encryptedLicenseKeyString = EncodingUtil.base64Encode(encryptedLicenseKey);
		
		} catch(Exception e) {
			
			system.debug('encryption error - ' + e);
			encryptedLicenseKeyString = '';
			}
		
		// return license key
		system.debug('encryptedLicenseKey = ' + encryptedLicenseKeyString);
		return encryptedLicenseKeyString;
	}
	
	// method to decrypt DA license key using private key
	public static String decryptLicenseKey(String encryptedLicenseKey, String privateKey) {
		
		String decryptedLicenseKeyString;
		
		// try to decrypt DA license key
		try {
			// private key value
			Blob cryptoKey = Blob.valueOf(privateKey);
			
			// convert license key string to blob
			Blob encryptedLicenseKeyBlob = EncodingUtil.base64Decode(encryptedLicenseKey);
			
			// decrypt license key blob
			Blob decryptedLicenseKey = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedLicenseKeyBlob);
			
			// convert decrypted license key blob to string
			decryptedLicenseKeyString = decryptedLicenseKey.toString();
		
		// if error returned
		} catch(Exception e) {
			
			system.debug('decryption error - ' + e);
			decryptedLicenseKeyString = '';
			}
		
		system.debug('decryptedLicenseKey = ' + decryptedLicenseKeyString);
		return decryptedLicenseKeyString;
	}
	
	// method to check a given decrypted license key is valid
	public static Boolean validateLicenseKey(String decryptedLicenseKey) {
		
		Boolean validLicenseKey = false;
				
		// send decrypted string to licenseType method
		Decimal licenseTypeReturned = licenseType(decryptedLicenseKey);
			
		// send decrypted string to licenseEndDate method
		dateTime licenseEndDateReturned = licenseEndDate(decryptedLicenseKey);
		
		// send decrypted string to licenseOrgId method
		String licenseOrgIdReturned = licenseOrgId(decryptedLicenseKey);
		
		// retrieve users Salesforce Org Id
		String userOrgId = UserInfo.getOrganizationId();
		
		if(licenseTypeReturned >= 10000 && licenseTypeReturned <= 99999 && licenseEndDateReturned > dateTime.now() && userOrgId == licenseOrgIdReturned
		) {
				
				validLicenseKey = true;
		}
		
		system.debug('validLicenseKey = ' + validLicenseKey);
		return validLicenseKey;
	}
	
	// method to extract license end date from decrypted license values string
	public static dateTime licenseEndDate(String licenseValues) {
		
		dateTime licenseEndDate = null;
		
		Integer licenseLength = licenseValues.length();
		
		if(licenseLength > 0) {
			
			boolean containsAmp = licenseValues.containsAny('&');
			boolean containsPer = licenseValues.containsAny('%');
			
			if(containsAmp == true && containsPer == true) {
				
				Integer ampPosition = licenseValues.indexOf('&');
				
				String rightString = licenseValues.right(licenseLength - ampPosition -1);
				Integer perPosition = rightString.indexOf('%');
				
				String leftString = rightString.left(perPosition);

				licenseEndDate = dateTime.valueOf(leftString);
				system.debug('licenseEndDate = ' + licenseEndDate);
			}
		}
		return licenseEndDate;
	}
	
	// method to extract license type from decrypted license values string
	public static Decimal licenseType(String licenseValues) {
	
		Decimal licenseType = null;
		
		Integer licenseLength = licenseValues.length();
		
		if(licenseLength > 0) {
			
			boolean containsAmp = licenseValues.containsAny('&');
			
			if(containsAmp == true) {
		
				Integer ampPosition = licenseValues.indexOf('&');
		
				licenseType = Decimal.valueOf(licenseValues.left(ampPosition));
				system.debug('licenseType = ' + licenseType);
			}
		}
		return licenseType;
	}
	
	// method to extract license type from decrypted license values string
	public static String licenseOrgId(String licenseValues) {
	
		String licenseOrgId = null;
		
		Integer licenseLength = licenseValues.length();
		
		if(licenseLength > 0) {
			
			boolean containsPer = licenseValues.containsAny('%');
			
			if(containsPer == true) {
		
				Integer perPosition = licenseValues.indexOf('%');
		
				licenseOrgId = licenseValues.right(licenseLength - perPosition - 1);
			}
		}
		system.debug('licenseOrgId = ' + licenseOrgId);
		return licenseOrgId;
	}
	
	// assign license type value
	public static String licenseTypeValue(String licenseType) {
		
		String licenseTypeValue;
		Decimal licenseTypeDec = decimal.valueOf(licenseType);
		
		if(licenseTypeDec >= 10000 && licenseTypeDec < 20000) {
			
			licenseTypeValue = 'Trial';
			
		} else if(licenseTypeDec >= 20000 && licenseTypeDec < 30000) {
			
			licenseTypeValue = 'Basic';
		
		} else if(licenseTypeDec >= 40000 && licenseTypeDec < 40000) {
			
			licenseTypeValue = 'Professional';
		
		} else if(licenseTypeDec >= 40000) {
			
			licenseTypeValue = 'Enterprise';
		}
		
		system.debug('licenseTypeValue = ' + licenseTypeValue);
		return licenseTypeValue;
	}
}