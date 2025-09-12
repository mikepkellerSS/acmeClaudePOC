import { LightningElement, track } from 'lwc';
import processQuery from '@salesforce/apex/ACME_DecisionQueryController.processNaturalLanguageQuery';
import getRecentDecisions from '@salesforce/apex/ACME_DecisionQueryController.getRecentDecisions';

export default class ACME_SupremeCourtDecisionLWC extends LightningElement {
    @track query = '';
    @track response = '';
    @track recentDecisions = [];
    @track isLoading = false;

    connectedCallback() {
        this.loadRecentDecisions();
    }

    async loadRecentDecisions() {
        try {
            this.recentDecisions = await getRecentDecisions();
        } catch (error) {
            console.error('Error loading recent decisions', error);
        }
    }

    handleQueryChange(event) {
        this.query = event.target.value;
    }

    async submitQuery() {
        if (!this.query) {
            return;
        }

        this.isLoading = true;
        try {
            this.response = await processQuery({ query: this.query });
        } catch (error) {
            this.response = 'Error processing query: ' + error.message;
        } finally {
            this.isLoading = false;
        }
    }
}