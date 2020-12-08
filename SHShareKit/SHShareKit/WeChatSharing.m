//
//  WeChatSharing.m
//  SHShareKit
//
//  Created by RobinShen on 15/8/25.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "WeChatSharing.h"

@interface WeChatSharing()

@property (copy, nonatomic) WeChatShareResult shareCompletionBlock;

@end

@implementation WeChatSharing

#pragma mark - Public methods

- (void)shareToWeChatSessionWithTitle:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage {
    [self shareToWeChatScene:WXSceneSession withTitle:title descriptions:descriptions thumbnailData:thumbnailData linkUrl:linkUrl isSingleImage:isSingleImage];
}

- (void)shareToWeChatTimelineWithTitle:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage {
    [self shareToWeChatScene:WXSceneTimeline withTitle:title descriptions:descriptions thumbnailData:thumbnailData linkUrl:linkUrl isSingleImage:isSingleImage];
}

- (void)shareToWeChatScene:(enum WXScene)scene withTitle:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage {

    WXMediaMessage *message = [WXMediaMessage message];
    if (isSingleImage) {
        WXImageObject *imgObj = [WXImageObject object];
        [imgObj setImageData:thumbnailData];
        [message setMediaObject:imgObj];
    } else {
        WXWebpageObject *webPageObject = [WXWebpageObject object];
        [webPageObject setWebpageUrl:linkUrl];
        [message setTitle:title];
        [message setDescription:descriptions];
        [message setThumbData:thumbnailData];
        [message setMediaObject:webPageObject];
    }
    
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    if ([WXApi isWXAppInstalled]) {
        [request setMessage:message];
    } else {
        [request setText:descriptions];
    }
    [request setBText:NO];
    [request setScene:scene];
    [WXApi sendReq:request completion:^(BOOL success) {
        if (self.shareCompletionBlock) {
            self.shareCompletionBlock(success);
        }
    }];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)handleUniversalLink:(NSUserActivity *)userActivity {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

#pragma mark - Accessors

- (void)setShareCompletionBlock:(WeChatShareResult)shareCompletionBlock {
    _shareCompletionBlock = shareCompletionBlock;
}


@end
