
public class AgentDashboardSummary {

    @AuraEnabled
    public Integer dealCount { get; set; }

    @AuraEnabled
    public Integer visitCount { get; set; }

    @AuraEnabled
    public Decimal commissionTotal { get; set; }
}
