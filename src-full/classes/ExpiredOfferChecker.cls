public class ExpiredOfferChecker implements Schedulable {

    public void execute(SchedulableContext context) {

        List<Offer__c> expiredOffers = [
            SELECT Id, Status__c, Expiry_Date__c
            FROM Offer__c
            WHERE Expiry_Date__c < :Date.today()
            AND Status__c IN ('Pending', 'Countered')
        ];

        for (Offer__c offer : expiredOffers) {
            offer.Status__c = 'Expired';
        }

        if (!expiredOffers.isEmpty()) {
            update expiredOffers;
        }
    }
}