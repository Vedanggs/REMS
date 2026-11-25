@IsTest
private class AgentPerformanceReportTest {

    @IsTest
    static void testAgentPerformanceBatch() {

        // Create Agent
        Agent__c agent = new Agent__c(
            User__c = UserInfo.getUserId(),
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
            Agent__c = UserInfo.getUserId()
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
            Status__c = 'Pending',
            Expiry_Date__c = Date.today().addDays(7)
        );
        insert offer;

        // Create Deal
        Deal__c deal = new Deal__c(
            Property__c = property.Id,
            Offer__c = offer.Id,
            Sale_Price__c = 100000,
            Close_Date__c = Date.today()
        );
        insert deal;

        // Create Property Visit
        Property_Visit__c visit = new Property_Visit__c(
            Property__c = property.Id,
            Buyer__c = buyer.Id,
            Visit_Date__c = Date.today(),
            Outcome__c = 'Completed'
        );
        insert visit;

        // Execute Batch
        Test.startTest();

        Database.executeBatch(
            new AgentPerformanceReport(), 1
        );

        Test.stopTest();

        // Verify Agent KPI values
        Agent__c updatedAgent = [
            SELECT Monthly_Deals__c,
                   Monthly_Revenue__c,
                   Monthly_Conversion_Rate__c
            FROM Agent__c
            WHERE Id = :agent.Id
        ];

        System.assertEquals(
            1, updatedAgent.Monthly_Deals__c
        );

        System.assertEquals(
            100000, updatedAgent.Monthly_Revenue__c
        );

        System.assertEquals(
            100, updatedAgent.Monthly_Conversion_Rate__c
        );
    }
}