public with sharing class PropertyVisitController {

    @AuraEnabled
    public static Id bookVisit(
        Id propertyId,
        String buyerName,
        String buyerEmail,
        Date visitDate
    ) {

        if (propertyId == null ||
            String.isBlank(buyerName) ||
            String.isBlank(buyerEmail) ||
            visitDate == null) {

            throw new AuraHandledException(
                'Please provide all required details.'
            );
        }

        // Get selected property
        Property__c property = [
            SELECT Id, Area__c
            FROM Property__c
            WHERE Id = :propertyId
            LIMIT 1
        ];

        // Check whether buyer already exists
        List<Buyer__c> existingBuyers = [
            SELECT Id
            FROM Buyer__c
            WHERE Email__c = :buyerEmail
            LIMIT 1
        ];

        Buyer__c buyer;

        if (!existingBuyers.isEmpty()) {
            buyer = existingBuyers[0];
        } else {

            buyer = new Buyer__c(
                Name = buyerName,
                Email__c = buyerEmail,
                Preferred_Area__c = property.Area__c,
                Lead_Source__c = 'Website'
            );

            insert buyer;
        }

        // Create property visit
        Property_Visit__c visit = new Property_Visit__c(
            Property__c = property.Id,
            Buyer__c = buyer.Id,
            Visit_Date__c = visitDate,
            Outcome__c = 'Scheduled'
        );

        insert visit;

        return visit.Id;
    }
}