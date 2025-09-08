public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [
            SELECT Id, Name, AccountNumber 
            FROM Account 
            LIMIT 50
        ];
    }
}