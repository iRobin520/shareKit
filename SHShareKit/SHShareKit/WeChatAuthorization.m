//
//  WeChatAuthorization.m
//  SHShareKit
//
//  Created by RobinShen on 15/8/6.
//  Copyright (c) 2015年 RobinShen. All rights reserved.
//

#import "WeChatAuthorization.h"

@interface WeChatAuthorization()

@property (strong, nonatomic) SendAuthReq *authRequest;
@property (strong, nonatomic) NSString *accessCode;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *refreshToken;
@property (copy, nonatomic) WeChatAuthorizationSucceedBlock loginSucceedActionBlock;
@property (copy, nonatomic) WeChatAuthorizationFailedBlock loginFailedActionBlock;
@property (copy, nonatomic) WeChatFetchUserInfoResult fetchUserInfoActionBlock;

@end

@implementation WeChatAuthorization

#pragma mark - Object lifecycles

- (instancetype)init {
    self = [super init];
    if (self) {
        self.authRequest = [[SendAuthReq alloc] init];
    }
    return self;
}

#pragma mark - Public methods

- (void)startAuthorize {
    self.authRequest.openID = self.appIdOrKey;
    self.authRequest.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    self.authRequest.state = @"xxx";
  
    if (self.viewController) {
        [WXApi sendAuthReq:self.authRequest viewController:self.viewController delegate:self completion:NULL];
    } else {
        [WXApi sendReq:self.authRequest completion:NULL];
    }
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)fetchAccessTokenCode:(NSString *)code {
    self.accessCode = code;
    NSString *requestUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",self.appIdOrKey,self.secret,code];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request setHTTPMethod:@"GET"];
    [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error && data.length>0) {
            NSError *error;
            NSDictionary *accessTokenInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            self.accessToken = [accessTokenInfo objectForKey:@"access_token"];
            NSString *uid = [accessTokenInfo objectForKey:@"openid"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.loginSucceedActionBlock) {
                    self.loginSucceedActionBlock(uid,self.accessToken);
                }
            });
        }
    }];
}

- (void)fetchUserInfo {
    if (self.accessToken) {
        NSString *requestUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self.accessToken,self.appIdOrKey];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
        [request setHTTPMethod:@"GET"];
        [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error && data.length>0) {
                NSError *error;
                NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.fetchUserInfoActionBlock) {
                        self.fetchUserInfoActionBlock(userInfo);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.fetchUserInfoActionBlock) {
                        self.fetchUserInfoActionBlock(nil);
                    }
                });
            }
        }];
    } else {
        if (self.fetchUserInfoActionBlock) {
            self.fetchUserInfoActionBlock(nil);
        }
    }
}

#pragma mark - Accessors

- (void)setLoginSucceedActionBlock:(WeChatAuthorizationSucceedBlock)loginSucceedActionBlock {
    _loginSucceedActionBlock = loginSucceedActionBlock;
}

- (void)setLoginFailedActionBlock:(WeChatAuthorizationFailedBlock)loginFailedActionBlock {
    _loginFailedActionBlock = loginFailedActionBlock;
}

- (void)setFetchUserInfoActionBlock:(WeChatFetchUserInfoResult)fetchUserInfoActionBlock {
    _fetchUserInfoActionBlock = fetchUserInfoActionBlock;
}

#pragma mark - WeChatAuthRequest delegate methods

- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *response = (SendAuthResp*)resp;
        self.accessCode = response.code;
        if (response.errCode==0) {
            [self fetchAccessTokenCode:response.code];
        } else {
            if (self.loginFailedActionBlock) {
                self.loginFailedActionBlock(resp);
            }
        }
    } else {
        if (self.loginFailedActionBlock) {
            self.loginFailedActionBlock(resp);
        }
    }
}

@end
