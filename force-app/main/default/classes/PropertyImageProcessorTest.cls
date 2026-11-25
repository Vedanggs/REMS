@IsTest
private class PropertyImageProcessorTest {

    @IsTest
    static void testImageUrlValidation() {

        // Create property with valid URL
        Property__c property1 = new Property__c(
            Name = 'Valid Image Property',
            Type__c = 'Residential',
            Price__c = 100000,
            Status__c = 'Available',
            Area__c = 'Pune',
            Image_URL__c = 'https://example.com/image.jpg'
        );

        // Create property with blank URL
        Property__c property2 = new Property__c(
            Name = 'Blank Image Property',
            Type__c = 'Residential',
            Price__c = 200000,
            Status__c = 'Available',
            Area__c = 'Pune'
        );

        insert new List<Property__c>{property1, property2};

        Set<Id> propertyIds = new Set<Id>{
            property1.Id, property2.Id
        };

        // Run Queueable Apex
        Test.startTest();

        System.enqueueJob(
            new PropertyImageProcessor(propertyIds)
        );

        Test.stopTest();

        // Verify results
        Map<Id, Property__c> results = new Map<Id, Property__c>([
            SELECT Image_URL_Valid__c
            FROM Property__c
            WHERE Id IN :propertyIds
        ]);

        System.assertEquals(
            true,
            results.get(property1.Id).Image_URL_Valid__c
        );

        System.assertEquals(
            false,
            results.get(property2.Id).Image_URL_Valid__c
        );
    }
}