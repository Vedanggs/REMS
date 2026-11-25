
import { LightningElement, api } from 'lwc';

export default class PropertyCard extends LightningElement {

    // Receives property data from the parent component
    @api property;

    // Check whether image URL exists
    get hasImage() {
        return this.property &&
               this.property.Image_URL__c;
    }

    // Apply CSS class according to property status
    get statusClass() {

        if (!this.property || !this.property.Status__c) {
            return 'status-badge';
        }

        const status = this.property.Status__c
            .toLowerCase()
            .replace(/\s+/g, '-');

        return 'status-badge ' + status;
    }

    // Handle Book Visit button click
    handleBookVisit() {

        this.dispatchEvent(
            new CustomEvent('bookvisit', {
                detail: {
                    propertyId: this.property.Id
                },
                bubbles: true,
                composed: true
            })
        );
    }
}
