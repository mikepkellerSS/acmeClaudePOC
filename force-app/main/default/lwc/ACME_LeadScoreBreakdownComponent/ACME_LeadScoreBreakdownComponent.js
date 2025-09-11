import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const LEAD_FIELDS = [
    'Lead.ACME__Lead_Score__c',
    'Lead.ACME__Demographic_Score__c',
    'Lead.ACME__Engagement_Score__c'
];

export default class ACMELeadScoreBreakdownComponent extends LightningElement {
    @api recordId;
    leadScore = 0;
    demographicScore = 0;
    engagementScore = 0;

    @wire(getRecord, { recordId: '$recordId', fields: LEAD_FIELDS })
    wiredLead({ error, data }) {
        if (data) {
            this.leadScore = data.fields.ACME__Lead_Score__c.value || 0;
            this.demographicScore = data.fields.ACME__Demographic_Score__c.value || 0;
            this.engagementScore = data.fields.ACME__Engagement_Score__c.value || 0;
        } else if (error) {
            console.error('Error loading lead record', error);
        }
    }

    get scoreColor() {
        if (this.leadScore >= 70) return 'green';
        if (this.leadScore >= 40) return 'orange';
        return 'red';
    }
}