public with sharing class AccountTriggerHandler {
    public static void handleBeforeInsert(List<Account> newAccounts) {
        validateAccountData(newAccounts);
    }

    public static void handleBeforeUpdate(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        validateAccountData(newAccounts);
    }

    private static void validateAccountData(List<Account> accounts) {
        for (Account acc : accounts) {
            if (String.isBlank(acc.Name)) {
                acc.addError('Account Name is required');
            }
        }
    }
}