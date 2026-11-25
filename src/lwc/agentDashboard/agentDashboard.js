
import { LightningElement, wire } from 'lwc';

import getAgentSummary
    from '@salesforce/apex/AgentDashboardController.getAgentSummary';

export default class AgentDashboard extends LightningElement {

    dealCount = 0;
    visitCount = 0;
    commissionTotal = 0;

    error;

    // Fetch data from Apex using Wire
    @wire(getAgentSummary)
    wiredSummary({ data, error }) {

        if (data) {

            this.dealCount = data.dealCount;
            this.visitCount = data.visitCount;
            this.commissionTotal = data.commissionTotal;

            this.error = undefined;
        }

        else if (error) {

            this.error = error;
            console.error('Error fetching agent summary:', error);
        }
    }
}
