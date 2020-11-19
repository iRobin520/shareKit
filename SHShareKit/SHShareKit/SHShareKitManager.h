//
//  SHAuthorizationManager.h
//  SHShareKit
//
//  Created by RobinShen on 15/8/5.
//  Copyright (c) 2015年 RobinShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QQAuthorization.h"
#import "WeChatAuthorization.h"
#import "WeiboAuthorization.h"
#import "QQSharing.h"
#import "WeChatSharing.h"
#import "WeiboSharing.h"
#import "WeChatPay.h"

typedef enum {
    SHShareKitOperationTypeQQAuthorization,
    SHShareKitOperationTypeWeChatAuthorization,
    SHShareKitOperationTypeWeiboAuthorization,
    SHShareKitOperationTypeQQSharing,
    SHShareKitOperationTypeWeChatSharing,
    SHShareKitOperationTypeWeChatPay,
    SHShareKitOperationTypeWeiboSharing,
    SHShareKitOperationTypeWeChatPayment,
} SHShareKitOperationType;

@interface SHShareKitManager : NSObject

@property (readonly, nonatomic) NSArray *sourceApplications;

+ (instancetype)sharedInstance;
+ (void)registerWeiboApp:(NSString *)appId universalLink:(NSString *)universalLink;
+ (void)registerWeChatApp:(NSString *)appId universalLink:(NSString *)universalLink;
+ (void)registerWeChatApp:(NSString *)appId secret:(NSString *)secret universalLink:(NSString *)universalLink;
+ (void)registerWeChatApp:(NSString *)appId secret:(NSString *)secret merchantId:(NSString *)merchantId partnerID:(NSString *)partnerID universalLink:(NSString *)universalLink;
+ (void)registerQQApp:(NSString *)appId;
+ (void)startQQAuthorizationWithSuccessBlock:(QQAuthorizationSucceedBlock)success failureBlock:(QQAuthorizationFailedBlock)failure;
+ (void)fetchQQUserInfoWithCompleteBlock:(QQFetchUserInfoResult)completeBlock;
+ (void)startWeChatAuthorizationWithViewController:(UIViewController *)viewController successBlock:(WeChatAuthorizationSucceedBlock)success failureBlock:(WeChatAuthorizationFailedBlock)failure;
+ (void)fetchWeChatUserInfoWithCompleteBlock:(WeChatFetchUserInfoResult)completeBlock;
+ (void)startWeiboAuthorizationWithSuccessBlock:(WeiboAuthorizationSucceedBlock)success failureBlock:(WeiboAuthorizationFailedBlock)failure;
+ (void)fetchWeiboUserInfoWithCompleteBlock:(WeiboFetchUserInfoResult)completeBlock;
+ (void)shareToQzoneWithTitle:(NSString *)title descriptions:(NSString *)descriptions previewImageUrl:(NSString *)previewImageUrl linkUrl:(NSString *)linkUrl successBlock:(QQShareResult)success failureBlock:(QQShareResult)failure;
+ (void)shareToQzoneWithImageData:(NSData *)imageData successBlock:(QQShareResult)success failureBlock:(QQShareResult)failure;
+ (void)shareToQQWithTitle:(NSString *)title descriptions:(NSString *)descriptions previewImageUrl:(NSString *)previewImageUrl linkUrl:(NSString *)linkUrl successBlock:(QQShareResult)success failureBlock:(QQShareResult)failure;
+ (void)shareToQQWithImageData:(NSData *)imageData successBlock:(QQShareResult)success failureBlock:(QQShareResult)failure;
+ (void)shareToWeChatSessionWithTitle:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage completionBlock:(WeChatShareResult)completion;
+ (void)shareToWeChatTimelineWithTitle:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage completionBlock:(WeChatShareResult)completion;
+ (void)wechatPayWithOrderNo:(NSString *)orderNo orderName:(NSString *)orderName orderPrice:(NSString *)orderPrice successBlock:(WeChatPayResult)success failureBlock:(WeChatPayResult)failure;
+ (void)wechatPayWithSignedOrderInfo:(NSDictionary *)orderInfo successBlock:(WeChatPayResult)success failureBlock:(WeChatPayResult)failure;
+ (void)shareToWeiboWithUUID:(NSString *)uuid title:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage completionBlock:(WeiboShareResult)completion;

+ (BOOL)handleOpenURL:(NSURL *)url withSourceApplication:(NSString *)sourceApplication;

@end
