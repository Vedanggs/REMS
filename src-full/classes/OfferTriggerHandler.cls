public class OfferTriggerHandler {

    public static void validateOffers(List<Offer__c> offers) {

        Set<Id> propertyIds = new Set<Id>();

        for (Offer__c o : offers) {
            if (o.Property__c != null) {
                propertyIds.add(o.Property__c);
            }
        }

        Map<Id, Property__c> properties = new Map<Id, Property__c>(
            [SELECT Id, Price__c
             FROM Property__c
             WHERE Id IN :propertyIds]
        );

        for (Offer__c o : offers) {
            if (o.Property__c != null &&
                properties.containsKey(o.Property__c)) {

                Decimal price = properties.get(o.Property__c).Price__c;

                if (o.Offer_Amount__c > price * 1.10) {
                    o.addError('Offer cannot exceed 110% of property price.');
                }
            }
        }
    }
    public static void handleOfferUpdates(
    List<Offer__c> newOffers,
    Map<Id, Offer__c> oldMap
) {
    for (Offer__c offer : newOffers) {
        Offer__c oldOffer = oldMap.get(offer.Id);

        if (offer.Status__c != oldOffer.Status__c) {

            if (offer.Status__c == 'Accepted') {
                System.debug('Offer accepted: ' + offer.Id);
            }

            if (offer.Status__c == 'Rejected') {
                System.debug('Offer rejected: ' + offer.Id);
            }
        }
    }
}
}