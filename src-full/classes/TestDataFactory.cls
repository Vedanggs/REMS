@IsTest
public class TestDataFactory {

    // Create Property
    public static Property__c createProperty() {

        Property__c property = new Property__c(
            Name = 'Test Property',
            Type__c = 'Residential',
            Price__c = 100000,
            Status__c = 'Available',
            Area__c = 'Pune'
        );

        insert property;
        return property;
    }

    // Create Buyer
    public static Buyer__c createBuyer() {

        Buyer__c buyer = new Buyer__c(
            Name = 'Test Buyer',
            Budget__c = 100000,
            Preferred_Area__c = 'Pune',
            Lead_Source__c = 'Website'
        );

        insert buyer;
        return buyer;
    }

    // Create Deal with related Property, Buyer and Offer
    public static Deal__c createDeal() {

        Property__c property = createProperty();
        Buyer__c buyer = createBuyer();

        Offer__c offer = new Offer__c(
            Property__c = property.Id,
            Buyer__c = buyer.Id,
            Offer_Amount__c = 100000,
            Status__c = 'Pending',
            Expiry_Date__c = Date.today().addDays(7)
        );

        insert offer;

        Deal__c deal = new Deal__c(
            Property__c = property.Id,
            Offer__c = offer.Id,
            Sale_Price__c = 100000,
            Close_Date__c = Date.today()
        );

        insert deal;
        return deal;
    }
}