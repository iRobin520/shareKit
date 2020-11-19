//
//  QQSharing.h
//  SHShareKit
//
//  Created by RobinShen on 15/8/17.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHShareKitBaseAction.h"
#import <TencentOpenAPI/QQApiInterface.h>

typedef void(^QQShareResult)(QQBaseResp *result);

@interface QQSharing : SHShareKitBaseAction<QQApiInterfaceDelegate>

/*! @brief Share to QZone
 *
 * @param title
 * @param Descriptions
 * @param previewImageUrl
 * @param linkUrl, web page url
 */
- (void)shareToQzoneWithTitle:(NSString *)title descriptions:(NSString *)descriptions previewImageUrl:(NSString *)previewImageUrl linkUrl:(NSString *)linkUrl;
- (void)shareToQzoneWithImageData:(NSData *)imageData;
- (void)shareToQQWithTitle:(NSString *)title descriptions:(NSString *)descriptions previewImageUrl:(NSString *)previewImageUrl linkUrl:(NSString *)linkUrl;
- (void)shareToQQWithImageData:(NSData *)imageData;

- (BOOL)handleOpenURL:(NSURL *)url;
- (void)setShareSucceedActionBlock:(QQShareResult)shareSucceedActionBlock;
- (void)setShareFailedActionBlock:(QQShareResult)shareFailedActionBlock;

@end
