trigger BuyerAssignmentTrigger on Buyer__c (before insert) {
    PropertyAssignmentService.assignBuyers(Trigger.new);
}