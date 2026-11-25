@IsTest
private class ExpiredOfferCheckerTest {

    @IsTest
    static void testExpiredOfferChecker() {

        // Create Property
        Property__c property = new Property__c(
            Name = 'Test Property',
            Type__c = 'Residential',
            Price__c = 100000,
            Status__c = 'Available',
            Area__c = 'Pune'
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

        // Create expired Pending offer
        Offer__c offer1 = new Offer__c(
            Property__c = property.Id,
            Buyer__c = buyer.Id,
            Offer_Amount__c = 90000,
            Status__c = 'Pending',
            Expiry_Date__c = Date.today().addDays(-2)
        );

        // Create expired Countered offer
        Offer__c offer2 = new Offer__c(
            Property__c = property.Id,
            Buyer__c = buyer.Id,
            Offer_Amount__c = 95000,
            Status__c = 'Countered',
            Expiry_Date__c = Date.today().addDays(-1)
        );

        // Create future Pending offer
        Offer__c offer3 = new Offer__c(
            Property__c = property.Id,
            Buyer__c = buyer.Id,
            Offer_Amount__c = 100000,
            Status__c = 'Pending',
            Expiry_Date__c = Date.today().addDays(5)
        );

        insert new List<Offer__c>{offer1, offer2, offer3};

        Test.startTest();

        System.schedule(
            'Test Expired Offer Checker',
            '0 0 0 1 1 ? 2099',
            new ExpiredOfferChecker()
        );

        Test.stopTest();

        // Verify offer statuses
        Map<Id, Offer__c> results = new Map<Id, Offer__c>([
            SELECT Status__c
            FROM Offer__c
            WHERE Id IN :new Set<Id>{
                offer1.Id, offer2.Id, offer3.Id
            }
        ]);

        System.assertEquals('Expired', results.get(offer1.Id).Status__c);
        System.assertEquals('Expired', results.get(offer2.Id).Status__c);
        System.assertEquals('Pending', results.get(offer3.Id).Status__c);
    }
}