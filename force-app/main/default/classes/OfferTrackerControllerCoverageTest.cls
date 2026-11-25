@IsTest
private class OfferTrackerControllerCoverageTest {

    private static Offer__c createOffer(String status) {

        Property__c property =
            TestDataFactory.createProperty();

        Buyer__c buyer =
            TestDataFactory.createBuyer();

        Offer__c offer = new Offer__c(
            Property__c = property.Id,
            Buyer__c = buyer.Id,
            Offer_Amount__c = 90000,
            Status__c = status,
            Expiry_Date__c = Date.today().addDays(7)
        );

        insert offer;
        return offer;
    }

    @IsTest
    static void testNullPropertyId() {

        List<Offer__c> results =
            OfferTrackerController.getOffers(null);

        System.assertEquals(0, results.size());
    }

    @IsTest
    static void testInvalidNewStatus() {

        Offer__c offer = createOffer('Pending');

        Boolean exceptionOccurred = false;

        try {
            OfferTrackerController.updateOfferStatus(
                offer.Id,
                'Pending'
            );
        }
        catch (AuraHandledException e) {
            exceptionOccurred = true;
        }

        System.assertEquals(true, exceptionOccurred);
    }

    @IsTest
    static void testUpdateAlreadyAcceptedOffer() {

        Offer__c offer = createOffer('Accepted');

        Boolean exceptionOccurred = false;

        try {
            OfferTrackerController.updateOfferStatus(
                offer.Id,
                'Rejected'
            );
        }
        catch (AuraHandledException e) {
            exceptionOccurred = true;
        }

        System.assertEquals(true, exceptionOccurred);
    }
}