import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const LEAD_FIELDS = [
    'Lead.Lead_Score__c',
    'Lead.Demographic_Score__c',
    'Lead.Engagement_Score__c'
];

export default class LeadScoreBreakdownComponent extends LightningElement {
    @api recordId;
    leadScore = 0;
    demographicScore = 0;
    engagementScore = 0;
    error;

    @wire(getRecord, { recordId: '$recordId', fields: LEAD_FIELDS })
    wiredLead({ error, data }) {
        if (data) {
            this.leadScore = data.fields.Lead_Score__c.value || 0;
            this.demographicScore = data.fields.Demographic_Score__c.value || 0;
            this.engagementScore = data.fields.Engagement_Score__c.value || 0;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.error('Error loading lead record', error);
        }
    }

    get scoreColor() {
        if (this.leadScore >= 70) return 'success';
        if (this.leadScore >= 40) return 'warning';
        return 'error';
    }

    get scoreLabel() {
        if (this.leadScore >= 70) return 'MQL Ready';
        if (this.leadScore >= 40) return 'Warm Lead';
        return 'Cold Lead';
    }

    get progressBarStyle() {
        return `width: ${Math.min(this.leadScore, 100)}%`;
    }
}