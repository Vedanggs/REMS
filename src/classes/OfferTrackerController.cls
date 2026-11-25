
public with sharing class OfferTrackerController {

    // Fetch offers related to a property
    @AuraEnabled(cacheable=true)
    public static List<Offer__c> getOffers(Id propertyId) {

        if (propertyId == null) {
            return new List<Offer__c>();
        }

        return [
            SELECT Id, Name, Buyer__r.Name,
                   Offer_Amount__c, Status__c, Expiry_Date__c
            FROM Offer__c
            WHERE Property__c = :propertyId
            ORDER BY CreatedDate DESC
        ];
    }

    // Accept or Reject an offer
    @AuraEnabled
    public static void updateOfferStatus(
        Id offerId,
        String newStatus
    ) {

        if (newStatus != 'Accepted' && newStatus != 'Rejected') {
            throw new AuraHandledException('Invalid offer status.');
        }

        Offer__c offer = [
            SELECT Id, Status__c
            FROM Offer__c
            WHERE Id = :offerId
            LIMIT 1
        ];

        if (offer.Status__c != 'Pending' &&
            offer.Status__c != 'Countered') {
            throw new AuraHandledException(
                'Only Pending or Countered offers can be updated.'
            );
        }

        offer.Status__c = newStatus;
        update offer;
    }
}
