import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createAccount from '@salesforce/apex/AccountController.createAccount';

export default class AccountCreateModal extends LightningElement {
    @track isModalOpen = false;
    @track name = '';
    @track type = '';
    @track industry = '';

    show() {
        this.isModalOpen = true;
    }

    hide() {
        this.isModalOpen = false;
        this.resetForm();
    }

    handleNameChange(event) {
        this.name = event.target.value;
    }

    handleTypeChange(event) {
        this.type = event.target.value;
    }

    handleIndustryChange(event) {
        this.industry = event.target.value;
    }

    handleSave() {
        createAccount({
            name: this.name,
            type: this.type,
            industry: this.industry
        })
        .then(result => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Account created successfully',
                variant: 'success'
            }));
            this.hide();
            this.dispatchEvent(new CustomEvent('accountcreated'));
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error creating account',
                message: error.body.message,
                variant: 'error'
            }));
        });
    }

    resetForm() {
        this.name = '';
        this.type = '';
        this.industry = '';
    }
}