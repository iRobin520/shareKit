//
//  WeiboAuthorization.m
//  SHShareKit
//
//  Created by RobinShen on 15/8/7.
//  Copyright (c) 2015年 RobinShen. All rights reserved.
//

#import "WeiboAuthorization.h"

@interface WeiboAuthorization()

@property (readwrite, nonatomic) NSString *userId;
@property (readwrite, nonatomic) NSString *accessToken;
@property (readwrite, nonatomic) NSString *refreshToken;
@property (copy, nonatomic) WeiboAuthorizationSucceedBlock loginSucceedActionBlock;
@property (copy, nonatomic) WeiboAuthorizationFailedBlock loginFailedActionBlock;
@property (copy, nonatomic) WeiboFetchUserInfoResult fetchUserInfoActionBlock;

@end

@implementation WeiboAuthorization

#pragma mark - Public methods

- (void)startAuthorize {
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = self.redirectUrl;
    authRequest.scope = @"all";
//    self.authRequest.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:authRequest completion:NULL];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)fetchUserInfo {
    if (self.userId) {
        NSString *requestUrl = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@", self.accessToken, self.userId];
        [WBHttpRequest requestWithURL:requestUrl httpMethod:@"GET" params:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            if (!error && result) {
                if (self.fetchUserInfoActionBlock) {
                    self.fetchUserInfoActionBlock(result);
                }
            } else {
                if (self.fetchUserInfoActionBlock) {
                    self.fetchUserInfoActionBlock(nil);
                }
            }
        }];
    } else {
        if (self.fetchUserInfoActionBlock) {
            self.fetchUserInfoActionBlock(nil);
        }
    }
}

#pragma mark - Accessors

- (void)setLoginSucceedActionBlock:(WeiboAuthorizationSucceedBlock)loginSucceedActionBlock {
    _loginSucceedActionBlock = loginSucceedActionBlock;
}

- (void)setLoginFailedActionBlock:(WeiboAuthorizationFailedBlock)loginFailedActionBlock {
    _loginFailedActionBlock = loginFailedActionBlock;
}

- (void)setFetchUserInfoActionBlock:(WeiboFetchUserInfoResult)fetchUserInfoActionBlock {
    _fetchUserInfoActionBlock = fetchUserInfoActionBlock;
}

#pragma mark - WeiboSDK delegate methods

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        WBAuthorizeResponse *authorizeResponse = (WBAuthorizeResponse *)response;
        self.userId = authorizeResponse.userID;
        self.accessToken = authorizeResponse.accessToken;
        self.refreshToken = authorizeResponse.refreshToken;
        if (self.userId && self.accessToken) {
            if (self.loginSucceedActionBlock) {
                self.loginSucceedActionBlock(self.userId,self.accessToken);
            }
        } else {
            if (self.loginFailedActionBlock) {
                self.loginFailedActionBlock(response);
            }
        }
    }
}

@end
