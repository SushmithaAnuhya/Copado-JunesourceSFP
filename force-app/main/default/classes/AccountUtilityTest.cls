/**
 * @description Test class for AccountUtility
 */
@isTest
private class AccountUtilityTest {
    
    /**
     * @description Sets up test data
     */
    @testSetup
    static void setupTestData() {
        // Create test account
        Account testAccount = new Account(
            Name = 'Test Account',
            Rating = 'Cold'
        );
        insert testAccount;
        
        // Create test opportunities
        List<Opportunity> testOpps = new List<Opportunity>();
        testOpps.add(new Opportunity(
            Name = 'Test Opp 1',
            AccountId = testAccount.Id,
            Amount = 75000,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        ));
        
        testOpps.add(new Opportunity(
            Name = 'Test Opp 2',
            AccountId = testAccount.Id,
            Amount = 125000,
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(60)
        ));
        
        insert testOpps;
    }
    
    /**
     * @description Tests the average opportunity amount calculation
     */
    @isTest
    static void testCalculateAverageOpportunityAmount() {
        // Get the test account
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Test.startTest();
        Decimal avgAmount = AccountUtility.calculateAverageOpportunityAmount(testAccount.Id);
        Test.stopTest();
        
        // Average of 75000 and 125000 should be 100000
        System.assertEquals(100000, avgAmount, 'Average opportunity amount should be 100000');
    }
    
    /**
     * @description Tests the account rating update logic
     */
    @isTest
    static void testUpdateAccountRatings() {
        // Get the test account
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Test.startTest();
        AccountUtility.updateAccountRatings(new List<Id>{testAccount.Id});
        Test.stopTest();
        
        // Verify the account rating was updated
        Account updatedAccount = [SELECT Rating FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Warm', updatedAccount.Rating, 'Account rating should be updated to Warm');
    }
    
    /**
     * @description Tests the calculation with no opportunities
     */
    @isTest
    static void testNoOpportunities() {
        // Create a new account with no opportunities
        Account noOppsAccount = new Account(Name = 'No Opps Account');
        insert noOppsAccount;
        
        Test.startTest();
        Decimal avgAmount = AccountUtility.calculateAverageOpportunityAmount(noOppsAccount.Id);
        Test.stopTest();
        
        System.assertEquals(0, avgAmount, 'Average should be 0 for accounts with no opportunities');
    }
}