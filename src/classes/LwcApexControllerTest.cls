
@IsTest
private class LwcApexControllerTest {

    @IsTest
    static void testAgentDashboard() {

        Test.startTest();

        AgentDashboardSummary result =
            AgentDashboardController.getAgentSummary();

        Test.stopTest();

        System.assertEquals(0, result.dealCount);
        System.assertEquals(0, result.visitCount);
        System.assertEquals(0, result.commissionTotal);
    }

    @IsTest
    static void testOfferTracker() {

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

        // Create Offer
        Offer__c offer = new Offer__c(
            Property__c = property.Id,
            Buyer__c = buyer.Id,
            Offer_Amount__c = 90000,
            Status__c = 'Pending',
            Expiry_Date__c = Date.today().addDays(7)
        );
        insert offer;

        Test.startTest();

        List<Offer__c> offers =
            OfferTrackerController.getOffers(property.Id);

        OfferTrackerController.updateOfferStatus(
            offer.Id,
            'Accepted'
        );

        Test.stopTest();

        System.assertEquals(1, offers.size());

        Offer__c updatedOffer = [
            SELECT Status__c
            FROM Offer__c
            WHERE Id = :offer.Id
        ];

        System.assertEquals('Accepted', updatedOffer.Status__c);
    }
}
