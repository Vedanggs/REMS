public class PropertyAssignmentService {

    public static void assignBuyers(List<Buyer__c> buyers) {

        Set<String> areas = new Set<String>();

        for (Buyer__c b : buyers) {
            if (b.Preferred_Area__c != null &&
                b.Assigned_Agent__c == null) {
                areas.add(b.Preferred_Area__c);
            }
        }

        if (areas.isEmpty()) return;

        List<Agent__c> agents = [
            SELECT User__c, Territory__c
            FROM Agent__c
            WHERE Territory__c IN :areas
            AND User__c != null
            AND User__r.IsActive = true
        ];

        Map<String, List<Id>> areaAgents =
            new Map<String, List<Id>>();

        Set<Id> agentIds = new Set<Id>();

        for (Agent__c a : agents) {
            if (!areaAgents.containsKey(a.Territory__c)) {
                areaAgents.put(a.Territory__c, new List<Id>());
            }

            areaAgents.get(a.Territory__c).add(a.User__c);
            agentIds.add(a.User__c);
        }

        Map<Id, Integer> workloads = new Map<Id, Integer>();

        for (Id id : agentIds) {
            workloads.put(id, 0);
        }

        for (AggregateResult ar : [
            SELECT Assigned_Agent__c agentId, COUNT(Id) total
            FROM Buyer__c
            WHERE Assigned_Agent__c IN :agentIds
            GROUP BY Assigned_Agent__c
        ]) {
            workloads.put(
                (Id) ar.get('agentId'),
                (Integer) ar.get('total')
            );
        }

        for (Buyer__c b : buyers) {

            if (b.Assigned_Agent__c != null ||
                !areaAgents.containsKey(b.Preferred_Area__c)) {
                continue;
            }

            Id selectedAgent;
            Integer lowestWorkload = 2147483647;

            for (Id agentId : areaAgents.get(b.Preferred_Area__c)) {

                Integer workload = workloads.get(agentId);

                if (workload < lowestWorkload) {
                    lowestWorkload = workload;
                    selectedAgent = agentId;
                }
            }

            if (selectedAgent != null) {
                b.Assigned_Agent__c = selectedAgent;
                workloads.put(selectedAgent, lowestWorkload + 1);
            }
        }
    }
}