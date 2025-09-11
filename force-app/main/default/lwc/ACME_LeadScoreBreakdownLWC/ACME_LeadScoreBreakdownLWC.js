import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const LEAD_FIELDS = [
    'Lead.ACME__Lead_Score__c',
    'Lead.ACME__Demographic_Score__c',
    'Lead.ACME__Engagement_Score__c'
];

export default class ACME_LeadScoreBreakdownLWC extends LightningElement {
    @api recordId;
    leadRecord;

    @wire(getRecord, { recordId: '$recordId', fields: LEAD_FIELDS })
    wiredLead({ error, data }) {
        if (data) {
            this.leadRecord = data;
        } else if (error) {
            console.error('Error loading lead record', error);
        }
    }

    get totalScore() {
        return this.leadRecord?.fields.ACME__Lead_Score__c?.value || 0;
    }

    get demographicScore() {
        return this.leadRecord?.fields.ACME__Demographic_Score__c?.value || 0;
    }

    get engagementScore() {
        return this.leadRecord?.fields.ACME__Engagement_Score__c?.value || 0;
    }

    get scoreColor() {
        const score = this.totalScore;
        if (score >= 80) return 'green';
        if (score >= 50) return 'orange';
        return 'red';
    }
}