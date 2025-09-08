import { LightningElement, wire } from 'lwc';
import getStories from '@salesforce/apex/StoryController.getStories';
import { refreshApex } from '@salesforce/apex';

export default class StoryList extends LightningElement {
    stories = [];
    error;

    @wire(getStories)
    wiredStories(result) {
        if (result.data) {
            this.stories = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.stories = [];
        }
    }

    handleRefresh() {
        return refreshApex(this.wiredStories);
    }
}