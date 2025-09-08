public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, Type, Industry FROM Account LIMIT 50];
    }

    @AuraEnabled
    public static Account createAccount(String name, String type, String industry) {
        Account newAccount = new Account(
            Name = name,
            Type = type,
            Industry = industry
        );
        insert newAccount;
        return newAccount;
    }
}