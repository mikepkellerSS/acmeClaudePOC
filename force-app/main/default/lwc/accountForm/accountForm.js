import { LightningElement } from 'lwc';
import createAccount from '@salesforce/apex/AccountController.createAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountForm extends LightningElement {
    name = '';
    type = '';
    industry = '';
    isModalOpen = false;

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
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

    handleSubmit() {
        createAccount({
            name: this.name,
            type: this.type,
            industry: this.industry
        })
        .then(account => {
            this.dispatchEvent(new CustomEvent('accountcreated', { detail: account }));
            this.closeModal();
            this.showToast('Success', 'Account created successfully', 'success');
        })
        .catch(error => {
            this.showToast('Error', error.body.message, 'error');
        });
    }

    resetForm() {
        this.name = '';
        this.type = '';
        this.industry = '';
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