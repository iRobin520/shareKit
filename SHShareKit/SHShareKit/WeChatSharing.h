//
//  WeChatSharing.h
//  SHShareKit
//
//  Created by RobinShen on 15/8/25.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHShareKitBaseAction.h"
#import "SHShareKitDefs.h"
#import "WXApi.h"

typedef void(^WeChatShareResult)(BOOL success);

@interface WeChatSharing : SHShareKitBaseAction<WXApiDelegate>

/*! @brief Share to WeChat Session
 *
 * @param title
 * @param Descriptions
 * @param thumbnailData, it must be less than 32KB
 * @param linkUrl, web page url
 */
- (void)shareToWeChatSessionWithTitle:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage;

/*! @brief Share to WeChat Timeline
 *
 * @param title
 * @param Descriptions
 * @param thumbnailData, it must be less than 32KB
 * @param linkUrl, web page url
 */
- (void)shareToWeChatTimelineWithTitle:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage;

- (BOOL)handleOpenURL:(NSURL *)url;
- (void)setShareCompletionBlock:(WeChatShareResult)shareCompletionBlock;

@end
