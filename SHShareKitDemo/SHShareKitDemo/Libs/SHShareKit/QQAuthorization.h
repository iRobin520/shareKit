//
//  QQAuthorization.h
//  SHShareKit
//
//  Created by RobinShen on 15/8/5.
//  Copyright (c) 2015年 RobinShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHShareKitBaseAction.h"
#import "SHShareKitDefs.h"
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

typedef void(^QQAuthorizationSucceedBlock)(NSString *uid);
typedef void(^QQAuthorizationFailedBlock)(BOOL isCanceled);
typedef void(^QQFetchUserInfoResult)(APIResponse *response);
@interface QQAuthorization : SHShareKitBaseAction<TencentSessionDelegate,TencentApiInterfaceDelegate,TCAPIRequestDelegate>

- (void)startAuthorize;
- (void)fetchUserInfo;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)setLoginSucceedActionBlock:(QQAuthorizationSucceedBlock)loginSucceedActionBlock;
- (void)setLoginFailedActionBlock:(QQAuthorizationFailedBlock)loginFailedActionBlock;
- (void)setFetchUserInfoActionBlock:(QQFetchUserInfoResult)fetchUserInfoActionBlock;

@end
