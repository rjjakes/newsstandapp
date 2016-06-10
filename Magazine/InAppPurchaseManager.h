//
//  InAppPurchaseManager.h
//
//

#import <StoreKit/StoreKit.h>

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

// public methods
- (void)requestProUpgradeProductData;
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;


@end