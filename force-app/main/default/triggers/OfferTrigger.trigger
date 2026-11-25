trigger OfferTrigger on Offer__c (
    before insert,
    after update
) {
    if (Trigger.isBefore && Trigger.isInsert) {
        OfferTriggerHandler.validateOffers(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        OfferTriggerHandler.handleOfferUpdates(
            Trigger.new,
            Trigger.oldMap
        );
    }
}