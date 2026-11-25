public class PropertyImageProcessor implements Queueable {

    private Set<Id> propertyIds;

    // Constructor
    public PropertyImageProcessor(Set<Id> propertyIds) {
        this.propertyIds = propertyIds;
    }

    // Execute asynchronously
    public void execute(QueueableContext context) {

        if (propertyIds == null || propertyIds.isEmpty()) {
            return;
        }

        List<Property__c> properties = [
            SELECT Id, Image_URL__c, Image_URL_Valid__c
            FROM Property__c
            WHERE Id IN :propertyIds
        ];

        for (Property__c property : properties) {

            String imageUrl = property.Image_URL__c;

            Boolean isValid = false;

            if (String.isNotBlank(imageUrl)) {
                imageUrl = imageUrl.trim();

                isValid = Pattern.matches(
                '(?i)^https?://[a-z0-9.-]+(?::[0-9]{1,5})?(/.*)?$',
                imageUrl
                );
            }

            property.Image_URL_Valid__c = isValid;
        }

        if (!properties.isEmpty()) {
            update properties;
        }
    }
}