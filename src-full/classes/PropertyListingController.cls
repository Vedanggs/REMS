public with sharing class PropertyListingController {

    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties() {

        return [
            SELECT Id, Name, Type__c, Price__c,
                   Status__c, Area__c, Image_URL__c
            FROM Property__c
            ORDER BY CreatedDate DESC
        ];
    }
}