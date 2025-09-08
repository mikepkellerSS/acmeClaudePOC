import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountList extends LightningElement {
    accounts = [];
    columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Type', fieldName: 'Type' },
        { label: 'Industry', fieldName: 'Industry' }
    ];

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            this.handleError(error);
        }
    }

    handleNewAccount() {
        this.template.querySelector('c-account-form').openModal();
    }

    handleAccountCreated(event) {
        const newAccount = event.detail;
        this.accounts = [...this.accounts, newAccount];
        this.showToast('Success', 'Account created successfully', 'success');
    }

    handleError(error) {
        this.showToast('Error', error.body.message, 'error');
    }

    showToast(title, message, variant) {
        const toast = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toast);
    }
}