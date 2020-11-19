//
//  WeChatAuthorization.h
//  SHShareKit
//
//  Created by RobinShen on 15/8/6.
//  Copyright (c) 2015年 RobinShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHShareKitBaseAction.h"
#import "SHShareKitDefs.h"
#import "WXApi.h"

typedef void(^WeChatAuthorizationSucceedBlock)(NSString *uid, NSString *accessToken);
typedef void(^WeChatAuthorizationFailedBlock)(BaseResp *response);
typedef void(^WeChatFetchUserInfoResult)(id response);

@interface WeChatAuthorization : SHShareKitBaseAction<WXApiDelegate>

@property (strong, nonatomic) UIViewController *viewController;

- (void)startAuthorize;
- (void)fetchUserInfo;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)setLoginSucceedActionBlock:(WeChatAuthorizationSucceedBlock)loginSucceedActionBlock;
- (void)setLoginFailedActionBlock:(WeChatAuthorizationFailedBlock)loginFailedActionBlock;
- (void)setFetchUserInfoActionBlock:(WeChatFetchUserInfoResult)fetchUserInfoActionBlock;

@end
