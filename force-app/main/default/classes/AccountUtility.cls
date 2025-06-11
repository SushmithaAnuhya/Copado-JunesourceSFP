/**
 * @description Utility class for Account-related operations
 */
public with sharing class AccountUtility {
    
    /**
     * @description Calculates the average opportunity amount for an account
     * @param accountId The ID of the account
     * @return Decimal The average opportunity amount
     */
    public static Decimal calculateAverageOpportunityAmount(Id accountId) {
        List<Opportunity> opportunities = [
            SELECT Amount 
            FROM Opportunity 
            WHERE AccountId = :accountId 
            AND Amount != null
        ];
        
        if (opportunities.isEmpty()) {
            return 0;
        }
        
        Decimal totalAmount = 0;
        for (Opportunity opp : opportunities) {
            totalAmount += opp.Amount;
        }
        
        return totalAmount / opportunities.size();
    }
    
    /**
     * @description Updates the account rating based on total opportunity amount
     * @param accountIds List of account IDs to update
     */
    public static void updateAccountRatings(List<Id> accountIds) {
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Id accId : accountIds) {
            Decimal avgAmount = calculateAverageOpportunityAmount(accId);
            String rating;
            
            if (avgAmount > 100000) {
                rating = 'Hot';
            } else if (avgAmount > 50000) {
                rating = 'Warm';
            } else {
                rating = 'Cold';
            }
            
            accountsToUpdate.add(new Account(
                Id = accId,
                Rating = rating
            ));
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}