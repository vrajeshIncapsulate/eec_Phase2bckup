public with sharing class EEC_geoCodeUtility {
	public EEC_geoCodeUtility() {
		
	}
	public static map<String, String> getLatLng(Map<String, String> addressParam){ 
		string apiKey = 'AIzaSyDqKxlfxmmjRd7sFbHDpCCeusvP6MzDqmM'; //This is the key for server applications. Put this in a custom setting 
		String url = 'https://maps.googleapis.com/maps/api/geocode/json?'; 
		
		Map<String, String> result = new Map<String, String>();
		String latitudeValue = '';
		String longitudeValue = '';

		String street = addressParam.get('street') != null ? addressParam.get('street') : '';
		String city = addressParam.get('city') != null ? addressParam.get('city') : '';
		String state = addressParam.get('state') != null ? addressParam.get('state') : '';
		String zipCode = addressParam.get('zipCode') != null ? addressParam.get('zipCode') : '';

		street = street.replaceAll(' ', '%20');
		city = city.replaceAll(' ', '%20');
		state = state.replaceAll(' ', '%20');

		url += 'address=' + street + '%20' + city + '%20' + state + '%20' + zipCode; 
		url += '&key=' + apiKey; 

		System.debug('------> URL' + url);

		Http h = new Http(); 
		HttpRequest req = new HttpRequest(); 
		req.setEndpoint(url); 
		req.setMethod('GET'); 
		String responseBody = ''; 
		if(Test.isRunningTest()){
			responseBody = getMockResponse();
		} else{
			HttpResponse res = h.send(req); 
			responseBody = res.getBody();
		}
		 

		System.debug('------> responseJson: ' + responseBody);
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
		String resultStatus = (String)responseMap.get('status');
		if(resultStatus == 'OK'){
			List<Object> resultsList = (List<Object>)responseMap.get('results');
			Map<String, Object> results = (Map<String, Object>)resultsList[0];
			Map<String, Object> geometry = (Map<String, Object>)results.get('geometry');
			Map<String, Object> location = (Map<String, Object>)geometry.get('location');
			result.put('latitude', String.valueOf(location.get('lat')));
			result.put('longitude', String.valueOf(location.get('lng')));
		} 
		result.put('status', resultStatus);

		return result;

	} 

	private static String getValueFromXMLString(String xmlString, String keyField) { 
		String valueFound = ''; 
		if(xmlString.contains('<' + keyField + '>') && xmlString.contains('')){ 
			try { 
				valueFound = xmlString.substring(xmlString.indexOf('<' + keyField + '>') + keyField.length() + 2, xmlString.indexOf(''));	
			} catch(exception e) { 
				system.debug('Error in getValueFromXMLString. Details: ' + e.getMessage() + ' keyfield: ' + keyfield); 
			} 
		} 
		return valueFound; 
	} 

	private static String getMockResponse(){
		return '{"results":[{"address_components":[{"long_name":"50","short_name":"50","types":["street_number"]},{"long_name":"MilkStreet","short_name":"MilkSt","types":["route"]},{"long_name":"Downtown","short_name":"Downtown","types":["neighborhood","political"]},{"long_name":"Boston","short_name":"Boston","types":["locality","political"]},{"long_name":"SuffolkCounty","short_name":"SuffolkCounty","types":["administrative_area_level_2","political"]},{"long_name":"Massachusetts","short_name":"MA","types":["administrative_area_level_1","political"]},{"long_name":"UnitedStates","short_name":"US","types":["country","political"]},{"long_name":"02109","short_name":"02109","types":["postal_code"]}],"formatted_address":"50MilkSt,Boston,MA02109,USA","geometry":{"bounds":{"northeast":{"lat":42.3572107,"lng":-71.0573759},"southwest":{"lat":42.3567888,"lng":-71.05780039999999}},"location":{"lat":42.3569998,"lng":-71.0575881},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":42.3583487302915,"lng":-71.05623916970849},"southwest":{"lat":42.3556507697085,"lng":-71.0589371302915}}},"place_id":"ChIJdZAIdoRw44kRJs-sBg3Xjbw","types":["premise"]}],"status":"OK"}';
	}
}