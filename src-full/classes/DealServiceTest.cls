@IsTest
private class DealServiceTest {

    @IsTest
    static void testCloseDeal() {

        Id currentUserId = UserInfo.getUserId();

        // Create Agent
        Agent__c agent = new Agent__c(
            User__c = currentUserId,
            Tier__c = 'Junior',
            Commission_Rate__c = 1,
            Territory__c = 'Pune'
        );
        insert agent;

        // Create Property
        Property__c property = new Property__c(
            Name = 'Test Property',
            Type__c = 'Residential',
            Price__c = 100000,
            Status__c = 'Available',
            Area__c = 'Pune',
            Agent__c = currentUserId
        );
        insert property;

        // Create Buyer
        Buyer__c buyer = new Buyer__c(
            Name = 'Test Buyer',
            Budget__c = 100000,
            Preferred_Area__c = 'Pune',
            Lead_Source__c = 'Website'
        );
        insert buyer;

        // Create Offer
        Offer__c offer = new Offer__c(
            Property__c = property.Id,
            Buyer__c = buyer.Id,
            Offer_Amount__c = 100000,
            Status__c = 'Accepted',
            Expiry_Date__c = Date.today().addDays(7)
        );
        insert offer;

        Deal__c deal = new Deal__c(
    Property__c = property.Id,
    Offer__c = offer.Id,
    Sale_Price__c = 100000,
    Close_Date__c = Date.today()
);
        insert deal;

        Test.startTest();
        DealService.closeDeal(deal.Id);
        Test.stopTest();

        // Verify results
        Deal__c updatedDeal = [
            SELECT Commission__c, Close_Date__c
            FROM Deal__c
            WHERE Id = :deal.Id
        ];

        Property__c updatedProperty = [
            SELECT Status__c
            FROM Property__c
            WHERE Id = :property.Id
        ];

        System.assertEquals(1000, updatedDeal.Commission__c);
        System.assertEquals(Date.today(), updatedDeal.Close_Date__c);
        System.assertEquals('Sold', updatedProperty.Status__c);
    }
    @IsTest
static void testCloseDealWithoutAgent() {

    Property__c property =
        TestDataFactory.createProperty();

    Buyer__c buyer =
        TestDataFactory.createBuyer();

    Offer__c offer = new Offer__c(
        Property__c = property.Id,
        Buyer__c = buyer.Id,
        Offer_Amount__c = 90000,
        Status__c = 'Pending',
        Expiry_Date__c = Date.today().addDays(7)
    );
    insert offer;

    Deal__c deal = new Deal__c(
        Property__c = property.Id,
        Offer__c = offer.Id,
        Sale_Price__c = 90000,
        Close_Date__c = Date.today()
    );
    insert deal;

    Boolean exceptionOccurred = false;

    Test.startTest();

    try {
        DealService.closeDeal(deal.Id);
    } catch (IllegalArgumentException e) {
        exceptionOccurred = true;
    }

    Test.stopTest();

    System.assertEquals(true, exceptionOccurred);
}
}