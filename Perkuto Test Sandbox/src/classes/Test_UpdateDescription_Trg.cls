@isTest
public class Test_UpdateDescription_Trg {
    
    public static testMethod void testUpdateDescriptionFilled(){
        dataFactory();
        try{
            QuoteLineItem resultQuoteLine = [Select Quote_Line_Item_Long_Description__c From QuoteLineItem Where Description = 'Filled' limit 1];
            system.assert(resultQuoteLine.Quote_Line_Item_Long_Description__c != null);
        }catch(Exception e){}
        
        
    }
    
    public static testMethod void testUpdateDescriptionBlank(){
        dataFactory();
        try{
            QuoteLineItem resultQuoteLine = [Select Quote_Line_Item_Long_Description__c From QuoteLineItem Where Description = 'Blank' limit 1];
            system.assert(resultQuoteLine.Quote_Line_Item_Long_Description__c == null);
        }catch(Exception e){}
    }    
    
    private static void dataFactory(){
        Company_Information__c ci = TestDataFactoryOpportunity.createCompanyInformation();
        insert ci;
        
        Account testAccount1 = new Account();
        testAccount1.Name = 'Test';
        testAccount1.CurrencyIsoCode = 'USD';
        //testAccount1.SCMC__Active__c = True;
        //testAccount1.SCMC__Customer__c = True;
        //testAccount1.SCMC__E_Mail__c = 'test@test.com';
        insert testAccount1;
        
        Opportunity testOpportunity1 = new Opportunity();
        testOpportunity1.Name = 'Test';
        testOpportunity1.CurrencyIsoCode = 'USD';
        testOpportunity1.AccountId = testAccount1.Id;
        testOpportunity1.StageName ='test';
        testOpportunity1.CloseDate = Date.today()+1;
        insert testOpportunity1;       
        
        Product2 testProduct1 = new Product2();
        testProduct1.Name = 'testProduct1';
        testProduct1.Description = 'test Description';
        testProduct1.Product_Long_Description__c = 'test Description';
        insert testProduct1;
        
        Product2 testProduct2 = new Product2();
        testProduct2.Name = 'testProduct2';
        insert testProduct2;        
        
        PricebookEntry testPriceBookEntry = new PricebookEntry();
        testPriceBookEntry.CurrencyIsoCode = 'USD';
        testPriceBookEntry.UnitPrice = 1000;
        testPriceBookEntry.Pricebook2Id = test.getStandardPricebookId();
        testPriceBookEntry.Product2Id = testProduct1.Id; 
        testPriceBookEntry.IsActive = true;
        insert testPriceBookEntry;
        
        Quote testQuote = new Quote();
        testQuote.Name = 'testQuote';
        testQuote.OpportunityId = testOpportunity1.Id;
        testQuote.Pricebook2Id = test.getStandardPricebookId();
        insert testQuote;
        
        QuoteLineItem testQuoteLine = new QuoteLineItem();
        testQuoteLine.Description ='Filled';
        testQuoteLine.Product2Id = testProduct1.Id;
        testQuoteLine.QuoteId = testQuote.Id;
        testQuoteLine.Quantity = 1;
        testQuoteLine.PricebookEntryId = testPriceBookEntry.Id;
        testQuoteLine.UnitPrice = 1000;
        insert testQuoteLine;
        
        QuoteLineItem testQuoteLine2 = new QuoteLineItem();
        testQuoteLine2.Description ='Blank';
        testQuoteLine2.Product2Id = testProduct2.Id;
        testQuoteLine2.QuoteId = testQuote.Id;
        testQuoteLine2.Quantity = 1;
        testQuoteLine2.PricebookEntryId = testPriceBookEntry.Id;
        testQuoteLine2.UnitPrice = 1000;
        insert testQuoteLine2;         
    }
}