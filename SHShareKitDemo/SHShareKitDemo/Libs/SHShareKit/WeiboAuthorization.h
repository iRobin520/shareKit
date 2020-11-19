//
//  WeiboAuthorization.h
//  SHShareKit
//
//  Created by RobinShen on 15/8/7.
//  Copyright (c) 2015年 RobinShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHShareKitBaseAction.h"
#import "SHShareKitDefs.h"
#import "WeiboSDK.h"

typedef void(^WeiboAuthorizationSucceedBlock)(NSString *uid, NSString *accessToken);
typedef void(^WeiboAuthorizationFailedBlock)(WBBaseResponse *response);
typedef void(^WeiboFetchUserInfoResult)(id response);

@interface WeiboAuthorization : SHShareKitBaseAction<UIApplicationDelegate,WeiboSDKDelegate,WBHttpRequestDelegate>

@property (readonly, nonatomic) NSString *userId;
@property (readonly, nonatomic) NSString *accessToken;
@property (readonly, nonatomic) NSString *refreshToken;

- (void)startAuthorize;
- (void)fetchUserInfo;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)setLoginSucceedActionBlock:(WeiboAuthorizationSucceedBlock)loginSucceedActionBlock;
- (void)setLoginFailedActionBlock:(WeiboAuthorizationFailedBlock)loginFailedActionBlock;
- (void)setFetchUserInfoActionBlock:(WeiboFetchUserInfoResult)fetchUserInfoActionBlock;

@end
