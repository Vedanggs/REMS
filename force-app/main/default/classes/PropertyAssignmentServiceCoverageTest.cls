@IsTest
private class PropertyAssignmentServiceCoverageTest {

    @IsTest
    static void testExistingAgentWorkload() {

        Id currentUserId = UserInfo.getUserId();

        // Create Agent
        Agent__c agent = new Agent__c(
            User__c = currentUserId,
            Tier__c = 'Junior',
            Commission_Rate__c = 1,
            Territory__c = 'Pune'
        );
        insert agent;

        // Create an existing Buyer assigned to this Agent
        Buyer__c existingBuyer = new Buyer__c(
            Name = 'Existing Buyer',
            Budget__c = 100000,
            Preferred_Area__c = 'Pune',
            Lead_Source__c = 'Website',
            Assigned_Agent__c = currentUserId
        );
        insert existingBuyer;

        // Create a new Buyer without an Agent
        Buyer__c newBuyer = new Buyer__c(
            Name = 'New Buyer',
            Budget__c = 150000,
            Preferred_Area__c = 'Pune',
            Lead_Source__c = 'Website'
        );

        Test.startTest();

        PropertyAssignmentService.assignBuyers(
            new List<Buyer__c>{ newBuyer }
        );

        Test.stopTest();

        // Verify Agent assignment
        System.assertEquals(
            currentUserId,
            newBuyer.Assigned_Agent__c
        );
    }
}