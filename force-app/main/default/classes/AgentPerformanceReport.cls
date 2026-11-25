public class AgentPerformanceReport
    implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([
            SELECT Id, User__c
            FROM Agent__c
            WHERE User__c != null
        ]);
    }

    public void execute(
        Database.BatchableContext bc,
        List<SObject> scope
    ) {

        List<Agent__c> agentScope = new List<Agent__c>();

        for (SObject record : scope) {
            agentScope.add((Agent__c) record);
        }

        Date startDate = Date.today().toStartOfMonth();
        Date nextMonth = startDate.addMonths(1);

        Set<Id> userIds = new Set<Id>();

        for (Agent__c agent : agentScope) {
            userIds.add(agent.User__c);
        }

        Map<Id, Integer> dealCounts = new Map<Id, Integer>();
        Map<Id, Decimal> revenues = new Map<Id, Decimal>();
        Map<Id, Integer> visitCounts = new Map<Id, Integer>();

        // Get monthly deals and revenue
        for (AggregateResult result : [
            SELECT Property__r.Agent__c agentId,
                   COUNT(Id) dealCount,
                   SUM(Sale_Price__c) totalRevenue
            FROM Deal__c
            WHERE Property__r.Agent__c IN :userIds
            AND Close_Date__c >= :startDate
            AND Close_Date__c < :nextMonth
            GROUP BY Property__r.Agent__c
        ]) {

            Id agentId = (Id) result.get('agentId');

            dealCounts.put(
                agentId,
                (Integer) result.get('dealCount')
            );

            Decimal totalRevenue =
                (Decimal) result.get('totalRevenue');

            revenues.put(
                agentId,
                totalRevenue == null ? 0 : totalRevenue
            );
        }

        // Get monthly property visits
        for (AggregateResult result : [
            SELECT Property__r.Agent__c agentId,
                   COUNT(Id) visitCount
            FROM Property_Visit__c
            WHERE Property__r.Agent__c IN :userIds
            AND Visit_Date__c >= :startDate
            AND Visit_Date__c < :nextMonth
            GROUP BY Property__r.Agent__c
        ]) {

            visitCounts.put(
                (Id) result.get('agentId'),
                (Integer) result.get('visitCount')
            );
        }

        List<Agent__c> updates = new List<Agent__c>();

        for (Agent__c agent : agentScope) {

            Integer deals = dealCounts.containsKey(agent.User__c)
                ? dealCounts.get(agent.User__c) : 0;

            Decimal revenue = revenues.containsKey(agent.User__c)
                ? revenues.get(agent.User__c) : 0;

            Integer visits = visitCounts.containsKey(agent.User__c)
                ? visitCounts.get(agent.User__c) : 0;

            Decimal conversionRate = 0;

            if (visits > 0) {
                conversionRate =
                    (Decimal.valueOf(String.valueOf(deals)) /
                     Decimal.valueOf(String.valueOf(visits))) * 100;
            }

            agent.Monthly_Deals__c = deals;
            agent.Monthly_Revenue__c = revenue;
            agent.Monthly_Conversion_Rate__c =
                conversionRate.setScale(2);

            updates.add(agent);
        }

        update updates;
    }

    public void finish(Database.BatchableContext bc) {

        System.debug(
            'Monthly Agent Performance Report completed.'
        );
    }
}