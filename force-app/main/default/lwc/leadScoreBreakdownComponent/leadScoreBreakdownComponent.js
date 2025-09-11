import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const LEAD_FIELDS = [
    'Lead.Lead_Score__c',
    'Lead.Demographic_Score__c',
    'Lead.Engagement_Score__c'
];

export default class LeadScoreBreakdownComponent extends LightningElement {
    @api recordId;
    leadRecord;
    error;

    @wire(getRecord, { recordId: '$recordId', fields: LEAD_FIELDS })
    wiredLead({ error, data }) {
        if (data) {
            this.leadRecord = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.leadRecord = undefined;
            console.error('Error loading lead record', error);
        }
    }

    get totalScore() {
        return this.leadRecord?.fields.Lead_Score__c?.value || 0;
    }

    get demographicScore() {
        return this.leadRecord?.fields.Demographic_Score__c?.value || 0;
    }

    get engagementScore() {
        return this.leadRecord?.fields.Engagement_Score__c?.value || 0;
    }

    get scoreColor() {
        const score = this.totalScore;
        if (score >= 70) return 'green';
        if (score >= 40) return 'orange';
        return 'red';
    }

    get scoreColorStyle() {
        return `color: ${this.scoreColor};`;
    }

    get hasData() {
        return this.leadRecord && !this.error;
    }
}