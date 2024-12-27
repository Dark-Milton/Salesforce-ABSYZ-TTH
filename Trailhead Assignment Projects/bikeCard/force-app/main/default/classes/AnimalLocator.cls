public with sharing class AnimalLocator {
    public class cls_animal {
		public Integer id;	
		public String name;	
		public String eats;	
		public String says;	
	}    
    public class JSONOutput{
        public cls_animal animal;

        //public JSONOutput parse(String json){
        //return (JSONOutput) System.JSON.deserialize(json, JSONOutput.class);
        //}
    }
    public static String getAnimalNameById(Integer id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        // Deserializes the JSON string into collections of primitive data types.
        // Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        jsonOutput results = (jsonOutput) JSON.deserialize(response.getBody(), jsonOutput.class);
        return(results.animal.name);
    }
}