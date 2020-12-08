//
//  ViewController.m
//  SHShareKitDemo
//
//  Created by Robin Shen on 2020/11/16.
//

#import "ViewController.h"
#import <SHShareKit/SHShareKitManager.h>

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - User actions

- (IBAction)userDidTouchQQLoginButton:(id)sender {
    [SHShareKitManager startQQAuthorizationWithSuccessBlock:^(NSString *uid) {

    } failureBlock:^(BOOL isCanceled) {

    }];
}

- (IBAction)userDidTouchWeChatLoginButton:(id)sender {
    [SHShareKitManager startWeChatAuthorizationWithViewController:self successBlock:^(NSString *uid, NSString *accessToken) {

    } failureBlock:^(BaseResp *response) {

    }];
}

- (IBAction)userDidTouchWeiboLoginButton:(id)sender {
    [SHShareKitManager startWeiboAuthorizationWithSuccessBlock:^(NSString *uid, NSString *accessToken) {

    } failureBlock:^(WBBaseResponse *response) {

    }];
}

- (IBAction)userDidTouchShareToQZoneButton:(id)sender {
    [SHShareKitManager shareToQzoneWithTitle:@"Test Title" descriptions:@"Test Descriptions" previewImageUrl:@"http://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg" linkUrl:@"http://sports.qq.com/a/20120510/000650.htm" completionBlock:^(BOOL isSuccess) {
        
    }];
}

- (IBAction)userDidTouchShareToQQButton:(id)sender {
    [SHShareKitManager shareToQQWithTitle:@"Test Title" descriptions:@"Test Descriptions" previewImageUrl:@"http://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg" linkUrl:@"http://sports.qq.com/a/20120510/000650.htm" completionBlock:^(BOOL isSuccess) {
        
    }];
}

- (IBAction)userDidTouchShareToWeChatSessionButton:(id)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    [SHShareKitManager shareToWeChatSessionWithTitle:@"分享测试" descriptions:@"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。" thumbnailData:imageData linkUrl:@"http://www.wconcept.cn" isSingleImage:YES completionBlock:^(BOOL success) {
        if (success) {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Succeed" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
        } else {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
        }
    }];
}

- (IBAction)userDidTouchShareToWeChatTimelineButton:(id)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    [SHShareKitManager shareToWeChatTimelineWithTitle:@"分享测试" descriptions:@"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。" thumbnailData:imageData linkUrl:@"http://www.wconcept.cn" isSingleImage:YES completionBlock:^(BOOL success) {
        if (success) {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Succeed" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
        } else {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
        }
    }];
}

- (IBAction)userDidTouchWeChatPayButton:(id)sender {
    [SHShareKitManager wechatPayWithOrderNo:@"TestOrderNo001" orderName:@"TestOrder" orderPrice:@"1" successBlock:^(BaseResp *response) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Succeed" message:@"支付成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
    } failureBlock:^(BaseResp *response) {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:response.errStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [msgbox show];
    }];
}

- (IBAction)userDidTouchShareToWeiboButton:(id)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    [SHShareKitManager shareToWeiboWithUUID:@"" title:@"分享测试" descriptions:@"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。" thumbnailData:imageData linkUrl:@"http://www.wconcept.cn" isSingleImage:YES completionBlock:^(BOOL success) {
        if (success) {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Succeed" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
        } else {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [msgbox show];
        }
    }];
}

@end
