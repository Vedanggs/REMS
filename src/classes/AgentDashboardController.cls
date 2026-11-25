
public with sharing class AgentDashboardController {

    @AuraEnabled(cacheable=true)
    public static AgentDashboardSummary getAgentSummary() {

        Id currentUserId = UserInfo.getUserId();

        AgentDashboardSummary summary =
            new AgentDashboardSummary();

        // Get total deals and commission
        AggregateResult dealResult = [
            SELECT COUNT(Id) dealCount,
                   SUM(Commission__c) commissionTotal
            FROM Deal__c
            WHERE Property__r.Agent__c = :currentUserId
        ];

        // Get total property visits
        AggregateResult visitResult = [
            SELECT COUNT(Id) visitCount
            FROM Property_Visit__c
            WHERE Property__r.Agent__c = :currentUserId
        ];

        summary.dealCount =
            (Integer) dealResult.get('dealCount');

        Decimal commission =
            (Decimal) dealResult.get('commissionTotal');

        summary.commissionTotal =
            commission == null ? 0 : commission;

        summary.visitCount =
            (Integer) visitResult.get('visitCount');

        return summary;
    }
}
