//
//  QQSharing.m
//  SHShareKit
//
//  Created by RobinShen on 15/8/17.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "QQSharing.h"
#import "QQAuthorization.h"

@interface QQSharing()

@property (strong, nonatomic) QQAuthorization *authorization;
@property (copy, nonatomic) QQShareResult shareSucceedActionBlock;
@property (copy, nonatomic) QQShareResult shareFailedActionBlock;

@end

@implementation QQSharing

#pragma mark - Object lifecycles

- (instancetype)init {
    self = [super init];
    if (self) {
        self.authorization = [[QQAuthorization alloc] init];
    }
    return self;
}

#pragma mark - Public methods

- (void)shareToQzoneWithTitle:(NSString *)title descriptions:(NSString *)descriptions previewImageUrl:(NSString *)previewImageUrl linkUrl:(NSString *)linkUrl {
    [self shareWithTitle:title descriptions:descriptions previewImageUrl:previewImageUrl linkUrl:linkUrl isToQZone:YES];
}

- (void)shareToQzoneWithImageData:(NSData *)imageData {
    [self shareWithImageData:imageData isToQZone:YES];
}

- (void)shareToQQWithTitle:(NSString *)title descriptions:(NSString *)descriptions previewImageUrl:(NSString *)previewImageUrl linkUrl:(NSString *)linkUrl {
    [self shareWithTitle:title descriptions:descriptions previewImageUrl:previewImageUrl linkUrl:linkUrl isToQZone:NO];
}

- (void)shareToQQWithImageData:(NSData *)imageData {
    [self shareWithImageData:imageData isToQZone:NO];
}

- (void)shareWithTitle:(NSString *)title descriptions:(NSString *)descriptions previewImageUrl:(NSString *)previewImageUrl linkUrl:(NSString *)linkUrl isToQZone:(BOOL)isToQZone {
    NSURL *previewURL = [NSURL URLWithString:previewImageUrl];
    NSURL* url = [NSURL URLWithString:linkUrl];
    QQApiNewsObject* newsObject = [QQApiNewsObject objectWithURL:url title:title description:descriptions previewImageURL:previewURL];
    SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:newsObject];
    QQApiSendResultCode sendResult;
    if (isToQZone) {
        sendResult = [QQApiInterface SendReqToQZone:request];
    } else {
        sendResult = [QQApiInterface sendReq:request];
    }
    [self handleSendResult:sendResult];
}

- (void)shareWithImageData:(NSData *)imageData isToQZone:(BOOL)isToQZone {
    QQApiImageObject *imageObject = [QQApiImageObject objectWithData:imageData previewImageData:imageData title:(NSString *)nil description:nil];
    SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:imageObject];
    QQApiSendResultCode sendResult;
    if (isToQZone) {
        sendResult = [QQApiInterface SendReqToQZone:request];
    } else {
        sendResult = [QQApiInterface sendReq:request];
    }
    [self handleSendResult:sendResult];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult {
    if (sendResult != EQQAPISENDSUCESS && sendResult != EQQAPIAPPSHAREASYNC) {
        if (self.shareFailedActionBlock) {
            QQBaseResp *sentFailedResponse = [[QQBaseResp alloc] init];
            sentFailedResponse.result = @"-1";
            switch (sendResult)
            {
                case EQQAPIAPPNOTREGISTED:
                {
                    sentFailedResponse.errorDescription = @"App Not registered";
                    break;
                }
                case EQQAPIMESSAGECONTENTINVALID:
                case EQQAPIMESSAGECONTENTNULL:
                case EQQAPIMESSAGETYPEINVALID:
                {
                    sentFailedResponse.errorDescription = @"Wrong parameters";
                    break;
                }
                case EQQAPIQQNOTINSTALLED:
                {
                    sentFailedResponse.errorDescription = @"QQ App not installed";
                    break;
                }
                case EQQAPIQQNOTSUPPORTAPI:
                {
                    sentFailedResponse.errorDescription = @"API not supported";
                    break;
                }
                case EQQAPISENDFAILD:
                {
                    sentFailedResponse.errorDescription = @"send failed";
                    break;
                }
                default:
                {
                    break;
                }
            }
            self.shareFailedActionBlock(sentFailedResponse);
        }
    }
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [QQApiInterface handleOpenURL:url delegate:self];
}

#pragma mark - Accessors

- (void)setShareSucceedActionBlock:(QQShareResult)shareSucceedActionBlock {
    _shareSucceedActionBlock = shareSucceedActionBlock;
}

- (void)setShareFailedActionBlock:(QQShareResult)shareFailedActionBlock {
    _shareFailedActionBlock = shareFailedActionBlock;
}

#pragma mark - QQApiInterface Delegate methods

- (void)isOnlineResponse:(NSDictionary *)response {
    
}

- (void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    if ([resp.result isEqualToString:@"0"]) {
        if (self.shareSucceedActionBlock) {
            self.shareSucceedActionBlock(resp);
        }
    } else {
        if (self.shareFailedActionBlock) {
            self.shareFailedActionBlock(resp);
        }
    }
}

@end
