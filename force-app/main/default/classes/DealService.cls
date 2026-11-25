public class DealService {

    public static void closeDeal(Id dealId) {

        Deal__c deal = [
            SELECT Id, Sale_Price__c, Commission__c,
                   Close_Date__c, Property__c,
                   Property__r.Agent__c
            FROM Deal__c
            WHERE Id = :dealId
        ];

        Property__c property = [
            SELECT Id, Status__c, Agent__c
            FROM Property__c
            WHERE Id = :deal.Property__c
        ];

        // Find the agent's tier
        List<Agent__c> agents = [
            SELECT Tier__c
            FROM Agent__c
            WHERE User__c = :property.Agent__c
            LIMIT 1
        ];

        if (agents.isEmpty()) {
            throw new IllegalArgumentException(
                'No Agent record found for this property.'
            );
        }

        // Calculate commission
        deal.Commission__c =
            CommissionCalculator.calculateCommission(
                deal.Sale_Price__c,
                agents[0].Tier__c
            );

        deal.Close_Date__c = Date.today();

        // Mark property as sold
        property.Status__c = 'Sold';

        update deal;
        update property;
    }
}