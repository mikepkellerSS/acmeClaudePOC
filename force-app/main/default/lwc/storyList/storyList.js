import { LightningElement, wire } from 'lwc';
import getStories from '@salesforce/apex/StoryController.getStories';

export default class StoryList extends LightningElement {
    stories = [];
    error;

    @wire(getStories)
    wiredStories({ error, data }) {
        if (data) {
            this.stories = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.stories = [];
        }
    }
}