//
//  WeiboSharing.h
//  SHShareKit
//
//  Created by RobinShen on 15/9/1.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHShareKitBaseAction.h"
#import "SHShareKitDefs.h"
#import "WeiboSDK.h"

typedef void(^WeiboShareResult)(BOOL success);

@interface WeiboSharing : SHShareKitBaseAction<WeiboSDKDelegate,WBHttpRequestDelegate>

- (void)shareToWeiboWithUUID:(NSString *)uuid title:(NSString *)title descriptions:(NSString *)descriptions thumbnailData:(NSData *)thumbnailData linkUrl:(NSString *)linkUrl isSingleImage:(BOOL)isSingleImage;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)setShareCompletionBlock:(WeiboShareResult)shareCompletionBlock;

@end
