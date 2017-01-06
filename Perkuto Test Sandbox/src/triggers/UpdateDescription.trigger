trigger UpdateDescription on QuoteLineItem (before insert) {
   Set<Id> proIdsSet = new Set<Id> ();
   for (QuoteLineItem qutLineItem : trigger.new) {
       proIdsSet.add (qutLineItem.Product2Id);      
   }
   Map<Id, String> prodId_DesMap = new Map<Id, String> ();
   for (Product2 pr : [SELECT Product_Long_Description__c, Description FROM Product2 WHERE Id IN :proIdsSet]) {
       if (pr.Product_Long_Description__c != null) {
           prodId_DesMap.put (pr.Id, pr.Product_Long_Description__c);
       } // End if
   } // End for
 
   for (QuoteLineItem qutLineItem : trigger.new) {
       if (prodId_DesMap.containsKey (qutLineItem.Product2Id))
           qutLineItem.Quote_Line_Item_Long_Description__c = prodId_DesMap.get (qutLineItem.Product2Id);
   }
}