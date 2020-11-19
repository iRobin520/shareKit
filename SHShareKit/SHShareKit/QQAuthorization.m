//
//  QQAuthorization.m
//  SHShareKit
//
//  Created by RobinShen on 15/8/5.
//  Copyright (c) 2015年 RobinShen. All rights reserved.
//

#import "QQAuthorization.h"
#import "SHShareKitManager.h"

@interface QQAuthorization ()

@property (strong, nonatomic) TencentOAuth *auth;
@property (copy, nonatomic) QQAuthorizationSucceedBlock loginSucceedActionBlock;
@property (copy, nonatomic) QQAuthorizationFailedBlock loginFailedActionBlock;
@property (copy, nonatomic) QQFetchUserInfoResult fetchUserInfoActionBlock;
@property (copy, nonatomic) SHAuthorizationFailedResult fetchUserInfoFailedActionBlock;

@end

@implementation QQAuthorization

#pragma mark - Object lifecycles

- (instancetype)init {
    self = [super init];
    if (self) {
        self.auth = [[TencentOAuth alloc] initWithAppId:self.appIdOrKey andDelegate:self];
    }
    return self;
}

#pragma mark - Public methods

- (void)startAuthorize {
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
//                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
//                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
//                            kOPEN_PERMISSION_ADD_TOPIC,
//                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
//                            kOPEN_PERMISSION_DEL_IDOL,
//                            kOPEN_PERMISSION_DEL_T,
//                            kOPEN_PERMISSION_GET_FANSLIST,
//                            kOPEN_PERMISSION_GET_IDOLLIST,
//                            kOPEN_PERMISSION_GET_INFO,
//                            kOPEN_PERMISSION_GET_OTHER_INFO,
//                            kOPEN_PERMISSION_GET_REPOST_LIST,
//                            kOPEN_PERMISSION_LIST_ALBUM,
//                            kOPEN_PERMISSION_UPLOAD_PIC,
//                            kOPEN_PERMISSION_GET_VIP_INFO,
//                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
//                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
//                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];
    
    [self.auth authorize:permissions inSafari:NO];
}


- (BOOL)handleOpenURL:(NSURL *)url {
    return [TencentOAuth HandleOpenURL:url];
}

- (void)fetchUserInfo {
    if (![self.auth getUserInfo]) {
        if (self.loginFailedActionBlock) {
            self.loginFailedActionBlock(NO);
        }
    }
}

#pragma mark - Accessors

- (void)setLoginSucceedActionBlock:(QQAuthorizationSucceedBlock)loginSucceedActionBlock {
    _loginSucceedActionBlock = loginSucceedActionBlock;
}

- (void)setLoginFailedActionBlock:(QQAuthorizationFailedBlock)loginFailedActionBlock {
    _loginFailedActionBlock = loginFailedActionBlock;
}

- (void)setFetchUserInfoActionBlock:(QQFetchUserInfoResult)fetchUserInfoActionBlock {
    _fetchUserInfoActionBlock = fetchUserInfoActionBlock;
}

#pragma mark - TencentOAuth Delegate methods

- (void)tencentDidLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:kQQDidLoginSucceedNotification object:self];
    if (self.loginSucceedActionBlock) {
        self.loginSucceedActionBlock([self.auth getUserOpenID]);
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    [[NSNotificationCenter defaultCenter] postNotificationName:kQQDidLoginFailedNotification object:self];
    if (self.loginFailedActionBlock) {
        self.loginFailedActionBlock(cancelled);
    }
}

- (void)tencentDidNotNetWork {
    [[NSNotificationCenter defaultCenter] postNotificationName:kQQDidLoginFailedNotification object:self];
    if (self.loginFailedActionBlock) {
        self.loginFailedActionBlock(NO);
    }
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams {
    return nil;
}

- (void)tencentDidLogout {
    [[NSNotificationCenter defaultCenter] postNotificationName:kQQDidLogoutNotification object:self];
}

- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions {
    return YES;
}

- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth {
    return YES;
}

- (void)getUserInfoResponse:(APIResponse*)response {
    if (self.fetchUserInfoActionBlock) {
        self.fetchUserInfoActionBlock(response);
    }
}

@end
