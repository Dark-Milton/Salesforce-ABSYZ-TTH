public with sharing class GeminiChat {
    public static String askGemini(String message) {
        String endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';
        String apiKey = 'GEMINI_API_KEY'; //Available in local system
        endpoint+= '?key=' + apiKey;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'application/json');
        String requestBody = '{\"contents\":[{\"parts\":[{\"text\":\"'+message+'\"}]}]}';
        req.setBody(requestBody);
        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
            System.debug('Callout was successful');
            String jsonResponse = res.getBody();
			
            Map<String, Object> parsedResponse = 
            (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
            
            List<Object> candidates = (List<Object>)parsedResponse.get('candidates');
            
            Map<String, Object> firstCandidate = (Map<String, Object>)candidates[0];
            
            // Navigate to "content" -> "parts"
            Map<String, Object> content = (Map<String, Object>)firstCandidate.get('content');
            List<Object> parts = (List<Object>)content.get('parts');
            
            Map<String, Object> firstPart = (Map<String, Object>)parts[0];
            String text = (String)firstPart.get('text');
            System.debug('Callout Result - ' + text);
            return text;
		} else {
            System.debug('HTTP error: ' + res.getStatusCode() + ' ' + res.getStatus());
            return 'error';
        }
    }
}