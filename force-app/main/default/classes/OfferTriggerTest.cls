@isTest
private class OfferTriggerTest {

    @testSetup
    static void createProperty() {
        Property__c p = new Property__c(
            Name = 'Test Property',
            Type__c = 'Residential',
            Price__c = 100000,
            Status__c = 'Available',
            Area__c = 'Pune'
        );
        insert p;
    }

    @isTest
    static void testValidOffer() {
        Property__c p = [SELECT Id FROM Property__c LIMIT 1];

        Offer__c o = new Offer__c(
            Property__c = p.Id,
            Offer_Amount__c = 100000,
            Expiry_Date__c = Date.today().addDays(7)
        );

        Test.startTest();
        insert o;
        Test.stopTest();

        System.assertNotEquals(null, o.Id);
    }

    @isTest
    static void testInvalidOffer() {
        Property__c p = [SELECT Id FROM Property__c LIMIT 1];

        Offer__c o = new Offer__c(
            Property__c = p.Id,
            Offer_Amount__c = 120000,
            Expiry_Date__c = Date.today().addDays(7)
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(o, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());
    }

    @isTest
    static void testBulkOffers() {
        Property__c p = [SELECT Id FROM Property__c LIMIT 1];

        List<Offer__c> offers = new List<Offer__c>();

        for (Integer i = 0; i < 200; i++) {
            offers.add(new Offer__c(
                Property__c = p.Id,
                Offer_Amount__c = 90000,
                Expiry_Date__c = Date.today().addDays(7)
            ));
        }

        Test.startTest();
        insert offers;
        Test.stopTest();

        System.assertEquals(200, offers.size());
    }
}