@IsTest
private class PropertyValuationCalloutTest {

    private class ValuationMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {

            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"estimatedValue":7500000}');

            return response;
        }
    }

    @IsTest
    static void testPropertyValuation() {

        Property__c property = new Property__c(
            Name = 'Test Property',
            Type__c = 'Residential',
            Price__c = 7000000,
            Status__c = 'Available',
            Area__c = 'Pune'
        );
        insert property;

        Test.setMock(
            HttpCalloutMock.class,
            new ValuationMock()
        );

        Test.startTest();
        PropertyValuationCallout.getValuation(property.Id);
        Test.stopTest();

        Property__c updatedProperty = [
            SELECT Estimated_Value__c
            FROM Property__c
            WHERE Id = :property.Id
        ];

        System.assertEquals(
            7500000,
            updatedProperty.Estimated_Value__c
        );
    }
}