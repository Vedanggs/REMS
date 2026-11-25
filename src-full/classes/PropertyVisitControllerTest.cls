@IsTest
private class PropertyVisitControllerTest {

    @IsTest
    static void testBookVisit() {

        // Create Property
        Property__c property = new Property__c(
            Name = 'Test Property',
            Type__c = 'Residential',
            Price__c = 100000,
            Status__c = 'Available',
            Area__c = 'Pune'
        );
        insert property;

        Test.startTest();

        Id visitId = PropertyVisitController.bookVisit(
            property.Id,
            'Test Buyer',
            'testbuyer@example.com',
            Date.today().addDays(1)
        );

        Test.stopTest();

        // Verify Property Visit
        Property_Visit__c visit = [
            SELECT Property__c, Buyer__c,
                   Visit_Date__c, Outcome__c
            FROM Property_Visit__c
            WHERE Id = :visitId
        ];

        System.assertEquals(property.Id, visit.Property__c);
        System.assertNotEquals(null, visit.Buyer__c);
        System.assertEquals(Date.today().addDays(1), visit.Visit_Date__c);
        System.assertEquals('Scheduled', visit.Outcome__c);
    }
}