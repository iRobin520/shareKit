//
//  WeiboSharing.m
//  SHShareKit
//
//  Created by RobinShen on 15/9/1.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "WeiboSharing.h"
#import "WeiboAuthorization.h"

@interface WeiboSharing()

@property (copy, nonatomic) WeiboShareResult shareCompletionBlock;

@end

@implementation WeiboSharing

#pragma mark - Public methods

- (void)shareToWeiboWithUUID:(NSString *)uuid title:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage {

    WBMessageObject *message = [WBMessageObject message];
    if ([WeiboSDK isWeiboAppInstalled]) {
        if (isSingleImage) {
            WBImageObject *imageObject = [WBImageObject object];
            UIImage *image = [UIImage imageWithData:thumbnailData];
            if (image) {
                [imageObject addImages:@[image]];
            }
            message.imageObject = imageObject;
        } else {
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = uuid;
            webpage.title = title;
            webpage.description = descriptions;
            webpage.thumbnailData = thumbnailData;
            webpage.webpageUrl = linkUrl;
            message.mediaObject = webpage;
        }
    } else {
        message.text = descriptions;
    }
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = self.redirectUrl;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    [WeiboSDK sendRequest:request completion:^(BOOL success) {
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(success);
        }
    }];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma mark - Accessors

- (void)setShareCompletionBlock:(WeiboShareResult)shareCompletionBlock {
    _shareCompletionBlock = shareCompletionBlock;
}

#pragma mark - WeiboSDK delegate methods

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(YES);
        }
    } else {
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(NO);
        }
    }
}

@end
