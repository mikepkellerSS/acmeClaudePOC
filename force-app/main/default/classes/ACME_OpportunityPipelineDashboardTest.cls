// ACME_OpportunityPipelineDashboardTest.cls
@isTest
public class ACME_OpportunityPipelineDashboardTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        accounts.add(TestDataFactory.createAccount('Test Account 1'));
        accounts.add(TestDataFactory.createAccount('Test Account 2'));
        insert accounts;

        List<User> users = new List<User>();
        users.add(TestDataFactory.createUser('Test User 1', 'testuser1@example.com'));
        users.add(TestDataFactory.createUser('Test User 2', 'testuser2@example.com'));
        insert users;

        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(new Opportunity(
            Name = 'Test Opportunity 1',
            AccountId = accounts[0].Id,
            OwnerId = users[0].Id,
            StageName = 'Prospecting',
            Amount = 10000,
            CloseDate = Date.today().addDays(30)
        ));
        opportunities.add(new Opportunity(
            Name = 'Test Opportunity 2',
            AccountId = accounts[0