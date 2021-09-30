//
//  AppStorePay.m
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/23/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import "AppStorePay.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation AppStorePay

- (void) startAppStorePay:(NSString*)productId :(NSString*)price
{
    NSMutableDictionary * productDict = [NSMutableDictionary new];
    [productDict setObject:@"dailymessagetruthrevealedga.item.1" forKey:@"$0.99"];
    [productDict setObject:@"dailymessagetruthrevealedga.item.5" forKey:@"$4.99"];
    [productDict setObject:@"dailymessagetruthrevealedga.item.10" forKey:@"$9.99"];
    [productDict setObject:@"dailymessagetruthrevealedga.item.20" forKey:@"$19.99"];
    [productDict setObject:@"dailymessagetruthrevealedga.item.50" forKey:@"$49.99"];
    [productDict setObject:@"dailymessagetruthrevealedga.item.100" forKey:@"$99.99"];
    [productDict setObject:@"dailymessagetruthrevealedga.item.150" forKey:@"$149.99"];
    [productDict setObject:@"dailymessagetruthrevealedga.item.200" forKey:@"$199.99"];
    [productDict setObject:@"dailymessagetruthrevealedga.item.250" forKey:@"$249.99"];
    [productDict setObject:@"dailymessagetruthrevealedga.item.300" forKey:@"$299.99"];
    
    self.productId = productDict[productId];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    if ([SKPaymentQueue canMakePayments])
    {
        SKProductsRequest * productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.productId]];
        self.request = productRequest;
        productRequest.delegate = self;
        [productRequest start];
    }else{
        [self.delegate AppStorePayDeniedWithReson:@"Please enable in app purchase in settings."];
    }
}

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if(response.products.count == 0){
        //// error occure
//        [self.delegate AppStorePaySuccessed:self.productId];
//        return;
        [self.delegate AppStorePayDeniedWithReson:@"Invalide Product ID."];
    }else if(response.invalidProductIdentifiers.count > 0){
        for(SKProduct * product in response.invalidProductIdentifiers)
            NSLog(@"Product not found: %@", product);
    }else{
        self.product = [response.products firstObject];
        SKMutablePayment * payment = [SKMutablePayment paymentWithProduct:self.product];
        payment.quantity = 2;
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self.delegate AppStorePaySuccessed:self.productId];
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self.delegate AppStorePayDeniedWithReson:@"Transaction failed"];
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}


@end
