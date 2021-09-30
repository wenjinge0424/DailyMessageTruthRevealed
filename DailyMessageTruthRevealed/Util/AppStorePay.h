//
//  AppStorePay.h
//  DailyMessageTruthRevealed
//
//  Created by Techsviewer on 5/23/18.
//  Copyright © 2018 brainyapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol AppStorePayDelegate
- (void) AppStorePayDeniedWithReson:(NSString*)errorMsg;
- (void) AppStorePaySuccessed:(NSString*)productId;
@end

@interface AppStorePay : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (strong, nonatomic) SKProductsRequest * request;
@property (strong, nonatomic) SKProduct * product;
@property (strong, nonatomic) NSString * productId;
@property (nonatomic, retain) id<AppStorePayDelegate> delegate;


- (void) startAppStorePay:(NSString*)productId :(NSString*)price;
@end
