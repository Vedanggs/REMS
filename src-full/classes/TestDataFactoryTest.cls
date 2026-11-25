@IsTest
private class TestDataFactoryTest {

    @IsTest
    static void testCreateProperty() {

        Property__c property =
            TestDataFactory.createProperty();

        System.assertNotEquals(null, property.Id);
        System.assertEquals('Pune', property.Area__c);
    }

    @IsTest
    static void testCreateBuyer() {

        Buyer__c buyer =
            TestDataFactory.createBuyer();

        System.assertNotEquals(null, buyer.Id);
        System.assertEquals('Test Buyer', buyer.Name);
    }

    @IsTest
    static void testCreateDeal() {

        Deal__c deal =
            TestDataFactory.createDeal();

        System.assertNotEquals(null, deal.Id);
        System.assertNotEquals(null, deal.Property__c);
        System.assertNotEquals(null, deal.Offer__c);
    }
}