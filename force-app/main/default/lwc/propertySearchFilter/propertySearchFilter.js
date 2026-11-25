
import { LightningElement } from 'lwc';

export default class PropertySearchFilter extends LightningElement {

    area = '';
    type = '';
    minPrice = '';
    maxPrice = '';

    // Property Type options
    typeOptions = [
    { label: 'All Types', value: '' },
    { label: 'Residential', value: 'Residential' },
    { label: 'Commercial', value: 'Commercial' }
];

    // Handle changes in input fields
    handleChange(event) {

        const fieldName = event.target.name;
        const fieldValue = event.target.value;

        this[fieldName] = fieldValue;
    }

    // Send filter values to parent component
    handleSearch() {

        const filterDetails = {
            area: this.area,
            type: this.type,
            minPrice: this.minPrice,
            maxPrice: this.maxPrice
        };

        this.dispatchEvent(
            new CustomEvent('filterchanged', {
                detail: filterDetails,
                bubbles: true,
                composed: true
            })
        );
    }
}
