@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock
{
    global HttpResponse respond(HttpRequest req){
    	String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
    	//System.assertEquals('https://abc.com', req.getEndpoint());
    	//System.assertEquals('GET', req.getMethod());
        Blob credentials = Blob.valueOf('2569734815:1259647834');
    	HttpResponse res = new HttpResponse();
    	req.setHeader('X-Twilio-Client', 'salesforce-3.2.0');
        req.setHeader('User-Agent', 'twilio-salesforce/3.2.0' );
        req.setHeader('Accept', 'application/json');
        req.setHeader('Accept-Charset', 'utf-8');
        req.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(credentials));
	    //req.setBodyAsBlob();
	    system.debug('res:: '+res);
	    return res;
    }
}