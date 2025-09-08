import { LightningElement, api } from 'lwc';

export default class ErrorPanel extends LightningElement {
    @api errors;
    @api friendlyMessage = 'An error occurred';
}