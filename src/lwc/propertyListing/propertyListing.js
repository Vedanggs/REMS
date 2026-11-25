
import { LightningElement, wire } from 'lwc';

import getProperties
    from '@salesforce/apex/PropertyListingController.getProperties';

import bookVisit
    from '@salesforce/apex/PropertyVisitController.bookVisit';

import { ShowToastEvent }
    from 'lightning/platformShowToastEvent';

export default class PropertyListing extends LightningElement {

    properties = [];
    filteredProperties = [];
    error;

    // Booking form variables
    showBookingForm = false;
    selectedPropertyId;
    selectedPropertyName;
    buyerName = '';
    buyerEmail = '';
    visitDate = '';
    isBooking = false;

    // Fetch properties
    @wire(getProperties)
    wiredProperties({ data, error }) {

        if (data) {
            this.properties = data;
            this.filteredProperties = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.properties = [];
            this.filteredProperties = [];
            console.error(error);
        }
    }

    // Check if properties exist
    get hasProperties() {
        return this.filteredProperties.length > 0;
    }

    // Minimum visit date is today
    get minimumDate() {
        const today = new Date();

        const year = today.getFullYear();
        const month = String(today.getMonth() + 1).padStart(2, '0');
        const day = String(today.getDate()).padStart(2, '0');

        return `${year}-${month}-${day}`;
    }

    // Receive filters from child
    handleFilterChanged(event) {

        const filters = event.detail;

        this.filteredProperties = this.properties.filter(property => {

            const areaMatch =
                !filters.area ||
                (property.Area__c &&
                property.Area__c.toLowerCase().includes(
                    filters.area.toLowerCase()
                ));

            const typeMatch =
                !filters.type ||
                property.Type__c === filters.type;

            const minPriceMatch =
                filters.minPrice === '' ||
                filters.minPrice == null ||
                property.Price__c >= Number(filters.minPrice);

            const maxPriceMatch =
                filters.maxPrice === '' ||
                filters.maxPrice == null ||
                property.Price__c <= Number(filters.maxPrice);

            return areaMatch &&
                   typeMatch &&
                   minPriceMatch &&
                   maxPriceMatch;
        });
    }

    // Open booking form
    handleBookVisit(event) {

        this.selectedPropertyId = event.detail.propertyId;

        const selectedProperty = this.properties.find(
            property => property.Id === this.selectedPropertyId
        );

        this.selectedPropertyName = selectedProperty
            ? selectedProperty.Name
            : '';

        this.showBookingForm = true;
        this.visitDate = this.minimumDate;
    }

    // Capture booking form inputs
    handleBookingInput(event) {

        const fieldName = event.target.name;

        this[fieldName] = event.target.value;
    }

    // Create Property Visit
    async handleBookingSubmit() {

        const inputs = this.template.querySelectorAll(
            'lightning-input'
        );

        let isValid = true;

        inputs.forEach(input => {
            if (!input.reportValidity()) {
                isValid = false;
            }
        });

        if (!isValid) {
            return;
        }

        this.isBooking = true;

        try {

            const visitId = await bookVisit({

                propertyId: this.selectedPropertyId,
                buyerName: this.buyerName,
                buyerEmail: this.buyerEmail,
                visitDate: this.visitDate

            });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Property visit booked successfully!',
                    variant: 'success'
                })
            );

            console.log('Created Visit ID:', visitId);

            this.resetBookingForm();

        } catch (error) {

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Booking Failed',
                    message: error.body?.message || error.message,
                    variant: 'error'
                })
            );

        } finally {
            this.isBooking = false;
        }
    }

    // Cancel booking
    handleCancel() {
        this.resetBookingForm();
    }

    // Reset booking form
    resetBookingForm() {

        this.showBookingForm = false;
        this.selectedPropertyId = null;
        this.selectedPropertyName = '';
        this.buyerName = '';
        this.buyerEmail = '';
        this.visitDate = '';
    }
}
