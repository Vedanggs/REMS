
import { LightningElement, api, wire } from 'lwc';

import { refreshApex } from '@salesforce/apex';

import getOffers
    from '@salesforce/apex/OfferTrackerController.getOffers';

import updateOfferStatus
    from '@salesforce/apex/OfferTrackerController.updateOfferStatus';

import { ShowToastEvent }
    from 'lightning/platformShowToastEvent';

export default class OfferTracker extends LightningElement {

    // Property record ID
    @api recordId;

    offers = [];
    error;
    wiredOffersResult;

    // Fetch offers from Apex
    @wire(getOffers, { propertyId: '$recordId' })
    wiredOffers(result) {

        this.wiredOffersResult = result;

        if (result.data) {
            this.offers = result.data.map(offer => ({
    ...offer,
    buyerName: offer.Buyer__r
        ? offer.Buyer__r.Name
        : 'Unknown Buyer'
}));
            this.error = undefined;
        }

        else if (result.error) {
            this.error = result.error;
            this.offers = [];
        }
    }

    // Handle Accept and Reject buttons
    async handleStatusChange(event) {

        const offerId = event.currentTarget.dataset.id;
        const newStatus = event.currentTarget.dataset.status;

        try {

            await updateOfferStatus({
                offerId: offerId,
                newStatus: newStatus
            });

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Offer ' + newStatus + ' successfully.',
                    variant: 'success'
                })
            );

            // Refresh offers after update
            await refreshApex(this.wiredOffersResult);

        }

        catch (error) {

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body?.message || error.message,
                    variant: 'error'
                })
            );
        }
    }
}
