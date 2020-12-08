//
//  SHAuthorizationManager.m
//  SHShareKit
//
//  Created by RobinShen on 15/8/5.
//  Copyright (c) 2015年 RobinShen. All rights reserved.
//

#import "SHShareKitManager.h"

@interface SHShareKitManager()

@property (strong, nonatomic) NSString *qqOpenId;
@property (strong, nonatomic) QQAuthorization *qqAuthorization;
@property (strong, nonatomic) QQSharing *qqSharing;
@property (strong, nonatomic) NSString *wechatAppId;
@property (strong, nonatomic) NSString *wechatSecret;
@property (strong, nonatomic) NSString *wechatMerchantId;
@property (strong, nonatomic) NSString *wechatPartnerId;
@property (strong, nonatomic) WeChatSharing *weChatSharing;
@property (strong, nonatomic) WeChatAuthorization *weChatAuthorization;
@property (strong, nonatomic) WeChatPay *weChatPay;
@property (strong, nonatomic) NSString *weiboAppId;
@property (strong, nonatomic) WeiboSharing *weiboSharing;
@property (strong, nonatomic) WeiboAuthorization *weiboAuthorization;
@property (assign, nonatomic) SHShareKitOperationType currentOperationType;

@end

@implementation SHShareKitManager

#pragma mark Object lifecycles

+ (instancetype)sharedInstance {
    static SHShareKitManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SHShareKitManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - Public methods

+ (void)registerWeiboApp:(NSString *)appId universalLink:(NSString *)universalLink {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.weiboAppId = appId;
    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:appId universalLink:universalLink];
}

+ (void)registerWeChatApp:(NSString *)appId universalLink:(NSString *)universalLink {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.wechatAppId = appId;
    [WXApi registerApp:appId universalLink:universalLink];
}

+ (void)registerWeChatApp:(NSString *)appId secret:(NSString *)secret universalLink:(NSString *)universalLink {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.wechatAppId = appId;
    sharedManager.wechatSecret = secret;
    [WXApi registerApp:appId universalLink:universalLink];
}

+ (void)registerWeChatApp:(NSString *)appId secret:(NSString *)secret merchantId:(NSString *)merchantId partnerID:(NSString *)partnerID universalLink:(NSString *)universalLink {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.wechatAppId = appId;
    sharedManager.wechatSecret = secret;
    sharedManager.wechatMerchantId = merchantId;
    sharedManager.wechatPartnerId = partnerID;
    [WXApi registerApp:appId universalLink:universalLink];
}

+ (void)registerQQApp:(NSString *)appId {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.qqOpenId = appId;
    
}

- (NSArray *)sourceApplications {
    return @[kSHQQAppBundleId,kSHWeChatAppBundleId,KSHWeiboAppBundleId];
}

+ (void)startQQAuthorizationWithSuccessBlock:(QQAuthorizationSucceedBlock)success failureBlock:(QQAuthorizationFailedBlock)failure {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.qqAuthorization = [[QQAuthorization alloc] init];
    [sharedManager.qqAuthorization setAppIdOrKey:sharedManager.qqOpenId];
    [sharedManager.qqAuthorization setLoginSucceedActionBlock:success];
    [sharedManager.qqAuthorization setLoginFailedActionBlock:failure];
    [sharedManager.qqAuthorization startAuthorize];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeQQAuthorization];
}

+ (void)fetchQQUserInfoWithCompleteBlock:(QQFetchUserInfoResult)completeBlock {
    SHShareKitManager *sharedManager = [self sharedInstance];
    [sharedManager.qqAuthorization setAppIdOrKey:sharedManager.qqOpenId];
    [sharedManager.qqAuthorization setFetchUserInfoActionBlock:completeBlock];
    [sharedManager.qqAuthorization fetchUserInfo];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeQQAuthorization];
}

+ (void)startWeChatAuthorizationWithViewController:(UIViewController *)viewController successBlock:(WeChatAuthorizationSucceedBlock)success failureBlock:(WeChatAuthorizationFailedBlock)failure {
    
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.weChatAuthorization = [[WeChatAuthorization alloc] init];
    [sharedManager.weChatAuthorization setAppIdOrKey:sharedManager.wechatAppId];
    [sharedManager.weChatAuthorization setViewController:viewController];
    [sharedManager.weChatAuthorization setLoginSucceedActionBlock:success];
    [sharedManager.weChatAuthorization setLoginFailedActionBlock:failure];
    [sharedManager.weChatAuthorization startAuthorize];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeWeChatAuthorization];
}

+ (void)fetchWeChatUserInfoWithCompleteBlock:(WeChatFetchUserInfoResult)completeBlock {
    SHShareKitManager *sharedManager = [self sharedInstance];
    [sharedManager.weChatAuthorization setAppIdOrKey:sharedManager.wechatAppId];
    [sharedManager.weChatAuthorization setFetchUserInfoActionBlock:completeBlock];
    [sharedManager.weChatAuthorization fetchUserInfo];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeWeChatAuthorization];
}

+ (void)startWeiboAuthorizationWithSuccessBlock:(WeiboAuthorizationSucceedBlock)success failureBlock:(WeiboAuthorizationFailedBlock)failure {
    
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.weiboAuthorization = [[WeiboAuthorization alloc] init];
    [sharedManager.weiboAuthorization setAppIdOrKey:sharedManager.weiboAppId];
    [sharedManager.weiboAuthorization setLoginSucceedActionBlock:success];
    [sharedManager.weiboAuthorization setLoginFailedActionBlock:failure];
    [sharedManager.weiboAuthorization startAuthorize];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeWeiboAuthorization];
}

+ (void)fetchWeiboUserInfoWithCompleteBlock:(WeiboFetchUserInfoResult)completeBlock {
    SHShareKitManager *sharedManager = [self sharedInstance];
    [sharedManager.weiboAuthorization setAppIdOrKey:sharedManager.weiboAppId];
    [sharedManager.weiboAuthorization setFetchUserInfoActionBlock:completeBlock];
    [sharedManager.weiboAuthorization fetchUserInfo];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeWeiboAuthorization];
}

+ (void)shareToQzoneWithTitle:(NSString *)title descriptions:(NSString *)descriptions previewImageUrl:(NSString *)previewImageUrl linkUrl:(NSString *)linkUrl completionBlock:(QQShareResult)completion {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.qqSharing = [[QQSharing alloc] initWithOpenId:sharedManager.qqOpenId];
    [sharedManager.qqSharing setShareCompletionBlock:completion];
    [sharedManager.qqSharing shareToQzoneWithTitle:title descriptions:descriptions previewImageUrl:previewImageUrl linkUrl:linkUrl];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeQQSharing];
}

+ (void)shareToQzoneWithImageData:(NSData *)imageData completionBlock:(QQShareResult)completion {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.qqSharing = [[QQSharing alloc] initWithOpenId:sharedManager.qqOpenId];
    [sharedManager.qqSharing setShareCompletionBlock:completion];
    [sharedManager.qqSharing shareToQzoneWithImageData:imageData];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeQQSharing];
}

+ (void)shareToQQWithTitle:(NSString *)title descriptions:(NSString *)descriptions previewImageUrl:(NSString *)previewImageUrl linkUrl:(NSString *)linkUrl completionBlock:(QQShareResult)completion {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.qqSharing = [[QQSharing alloc] initWithOpenId:sharedManager.qqOpenId];
    [sharedManager.qqSharing setShareCompletionBlock:completion];
    [sharedManager.qqSharing shareToQQWithTitle:title descriptions:descriptions previewImageUrl:previewImageUrl linkUrl:linkUrl];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeQQSharing];
}

+ (void)shareToQQWithImageData:(NSData *)imageData completionBlock:(QQShareResult)completion {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.qqSharing = [[QQSharing alloc] initWithOpenId:sharedManager.qqOpenId];
    [sharedManager.qqSharing setShareCompletionBlock:completion];
    [sharedManager.qqSharing shareToQQWithImageData:imageData];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeQQSharing];
}

+ (void)shareToWeChatSessionWithTitle:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage completionBlock:(WeChatShareResult)completion {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.weChatSharing = [[WeChatSharing alloc] init];
    [sharedManager.weChatSharing setAppIdOrKey:sharedManager.wechatAppId];
    [sharedManager.weChatSharing setSecret:sharedManager.wechatSecret];
    [sharedManager.weChatSharing setShareCompletionBlock:completion];
    [sharedManager.weChatSharing shareToWeChatSessionWithTitle:title descriptions:descriptions thumbnailData:thumbnailData linkUrl:linkUrl isSingleImage:isSingleImage];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeWeChatSharing];
}

+ (void)shareToWeChatTimelineWithTitle:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage completionBlock:(WeChatShareResult)completion {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.weChatSharing = [[WeChatSharing alloc] init];
    [sharedManager.weChatSharing setAppIdOrKey:sharedManager.wechatAppId];
    [sharedManager.weChatSharing setSecret:sharedManager.wechatSecret];
    [sharedManager.weChatSharing setShareCompletionBlock:completion];
    [sharedManager.weChatSharing shareToWeChatTimelineWithTitle:title descriptions:descriptions thumbnailData:thumbnailData linkUrl:linkUrl isSingleImage:isSingleImage];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeWeChatSharing];
}

+ (void)wechatPayWithOrderNo:(NSString *)orderNo orderName:(NSString *)orderName orderPrice:(NSString *)orderPrice successBlock:(WeChatPayResult)success failureBlock:(WeChatPayResult)failure {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.weChatPay = [[WeChatPay alloc] init];
    [sharedManager.weChatPay setAppIdOrKey:sharedManager.wechatAppId];
    [sharedManager.weChatPay setSecret:sharedManager.wechatSecret];
    [sharedManager.weChatPay setMerchantID:sharedManager.wechatMerchantId];
    [sharedManager.weChatPay setPartnerID:sharedManager.wechatPartnerId];
    [sharedManager.weChatPay setPaySucceedActionBlock:success];
    [sharedManager.weChatPay setPayFailedActionBlock:failure];
    [sharedManager.weChatPay payOrderWithOrderNo:orderNo orderName:orderName orderPrice:orderPrice];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeWeChatPay];
}

+ (void)wechatPayWithSignedOrderInfo:(NSDictionary *)orderInfo successBlock:(WeChatPayResult)success failureBlock:(WeChatPayResult)failure {
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.weChatPay = [[WeChatPay alloc] init];
    [sharedManager.weChatPay setPaySucceedActionBlock:success];
    [sharedManager.weChatPay setPayFailedActionBlock:failure];
    [sharedManager.weChatPay payOrderWithSignedOrderInfo:orderInfo];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeWeChatPay];
}

+ (void)shareToWeiboWithUUID:(NSString *)uuid title:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage completionBlock:(WeiboShareResult)completion {
    
    SHShareKitManager *sharedManager = [self sharedInstance];
    sharedManager.weiboSharing = [[WeiboSharing alloc] init];
    [sharedManager.weiboSharing setAppIdOrKey:sharedManager.weiboAppId];
    [sharedManager.weiboSharing setShareCompletionBlock:completion];
    [sharedManager.weiboSharing shareToWeiboWithUUID:uuid title:title descriptions:descriptions thumbnailData:thumbnailData linkUrl:linkUrl isSingleImage:isSingleImage];
    [sharedManager setCurrentOperationType:SHShareKitOperationTypeWeiboSharing];
}

+ (BOOL)handleOpenURL:(NSURL *)url withSourceApplication:(NSString *)sourceApplication {
    SHShareKitManager *sharedManager = [self sharedInstance];
    if ([sourceApplication isEqualToString:kSHQQAppBundleId]) {
        if (sharedManager.currentOperationType == SHShareKitOperationTypeQQAuthorization) {
            return [sharedManager.qqAuthorization handleOpenURL:url];
        } else if (sharedManager.currentOperationType == SHShareKitOperationTypeQQSharing) {
            return [sharedManager.qqSharing handleOpenURL:url];
        }
    } else if ([sourceApplication isEqualToString:kSHWeChatAppBundleId]) {
        if (sharedManager.currentOperationType == SHShareKitOperationTypeWeChatAuthorization) {
            return [sharedManager.weChatAuthorization handleOpenURL:url];
        } else if (sharedManager.currentOperationType == SHShareKitOperationTypeWeChatSharing) {
            return [sharedManager.weChatSharing handleOpenURL:url];
        } else if (sharedManager.currentOperationType == SHShareKitOperationTypeWeChatPay) {
            return [sharedManager.weChatPay handleOpenURL:url];
        }
    } else if ([sourceApplication isEqualToString:KSHWeiboAppBundleId]) {
        if (sharedManager.currentOperationType == SHShareKitOperationTypeWeiboSharing) {
            return [sharedManager.weiboSharing handleOpenURL:url];
        } else if (sharedManager.currentOperationType == SHShareKitOperationTypeWeiboAuthorization) {
            return [sharedManager.weiboAuthorization handleOpenURL:url];
        }
    }
    return YES;
}

+ (BOOL)handleUniversalLink:(NSUserActivity *)userActivity {
    SHShareKitManager *sharedManager = [self sharedInstance];
    if (sharedManager.currentOperationType == SHShareKitOperationTypeWeChatAuthorization) {
        return [sharedManager.weChatAuthorization handleUniversalLink:userActivity];
    } else if (sharedManager.currentOperationType == SHShareKitOperationTypeWeChatSharing) {
        return [sharedManager.weChatSharing handleUniversalLink:userActivity];
    } else if (sharedManager.currentOperationType == SHShareKitOperationTypeQQAuthorization) {
        return [sharedManager.qqAuthorization handleUniversalLink:userActivity];
    } else if (sharedManager.currentOperationType == SHShareKitOperationTypeQQSharing) {
        return [sharedManager.qqSharing handleUniversalLink:userActivity];
    }
    return YES;
}

@end
