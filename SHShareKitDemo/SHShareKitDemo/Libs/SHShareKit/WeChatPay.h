//
//  WeChatPay.h
//  SHShareKit
//
//  Created by RobinShen on 15/8/25.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHShareKitBaseAction.h"
#import "WXApi.h"

typedef void(^WeChatPayResult)(BaseResp *response);

@interface WeChatPay : SHShareKitBaseAction<WXApiDelegate>

- (void)payOrderWithOrderNo:(NSString *)orderNo orderName:(NSString *)orderName orderPrice:(NSString *)orderPrice;
- (void)payOrderWithSignedOrderInfo:(NSDictionary *)orderInfo;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)setPaySucceedActionBlock:(WeChatPayResult)paySucceedActionBlock;
- (void)setPayFailedActionBlock:(WeChatPayResult)payFailedActionBlock;

@end
