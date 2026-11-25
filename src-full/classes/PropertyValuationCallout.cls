public class PropertyValuationCallout {

    public static void getValuation(Id propertyId) {

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint(
            'callout:PropertyValuationAPI/properties/' + propertyId
        );
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {

            Map<String, Object> result =
                (Map<String, Object>) JSON.deserializeUntyped(
                    response.getBody()
                );

            Decimal value = Decimal.valueOf(
                String.valueOf(result.get('estimatedValue'))
            );

            Property__c property = [
                SELECT Id, Estimated_Value__c
                FROM Property__c
                WHERE Id = :propertyId
            ];

            property.Estimated_Value__c = value;
            update property;
        }
    }
}