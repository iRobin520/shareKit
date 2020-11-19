//
//  WeChatPay.m
//  SHShareKit
//
//  Created by RobinShen on 15/8/25.
//  Copyright (c) 2015年 sh. All rights reserved.
//

#import "WeChatPay.h"
#import "SHShareKitDefs.h"
#import "payRequsestHandler.h"
#import "WXApi.h"

@interface WeChatPay()

@property (strong, nonatomic) payRequsestHandler *payRequest;
@property (strong, nonatomic) NSMutableString *debugInfo;
@property (copy, nonatomic) WeChatPayResult paySucceedActionBlock;
@property (copy, nonatomic) WeChatPayResult payFailedActionBlock;

@end

@implementation WeChatPay

#pragma mark - Object lifecycles

- (instancetype)init {
    self = [super init];
    if (self) {
        self.debugInfo = [[NSMutableString alloc] init];
        self.payRequest = [[payRequsestHandler alloc] init];
        //初始化支付签名对象
        [self.payRequest init:self.appIdOrKey mch_id:self.merchantID];
        //设置密钥
        [self.payRequest setKey:self.partnerID];
    }
    return self;
}

#pragma mark - Public methods

- (void)payOrderWithOrderNo:(NSString *)orderNo orderName:(NSString *)orderName orderPrice:(NSString *)orderPrice {
    //================================
    //预付单参数订单设置
    //================================
    srand( (unsigned)time(0) );
    NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
    
    [packageParams setObject:self.appIdOrKey forKey:@"appid"];       //开放平台appid
    [packageParams setObject:self.merchantID forKey:@"mch_id"];      //商户号
    [packageParams setObject:@"iOS App" forKey:@"device_info"]; //支付设备号或门店号
    [packageParams setObject:noncestr forKey:@"nonce_str"];   //随机串
    [packageParams setObject:@"APP" forKey:@"trade_type"];  //支付类型，固定为APP
    [packageParams setObject:orderName forKey:@"body"];        //订单描述，展示给用户
    [packageParams setObject:self.notifyUrl forKey:@"notify_url"];  //支付结果异步通知
    [packageParams setObject:orderNo forKey:@"out_trade_no"];//商户订单号
    [packageParams setObject:@"196.168.1.1" forKey:@"spbill_create_ip"];//发器支付的机器ip
    [packageParams setObject:orderPrice forKey:@"total_fee"];       //订单金额，单位为分
    
    //获取prepayId（预支付交易会话标识）
    NSString *prePayid;
    prePayid = [self.payRequest sendPrepay:packageParams];
    
    if (prePayid != nil) {
        //获取到prepayid后进行第二次签名
        
        NSString *package, *time_stamp, *nonce_str;
        //设置支付参数
        time_t now;
        time(&now);
        time_stamp  = [NSString stringWithFormat:@"%ld", now];
        nonce_str	= [WXUtil md5:time_stamp];
        //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
        //package       = [NSString stringWithFormat:@"Sign=%@",package];
        package         = @"Sign=WXPay";
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject:self.appIdOrKey forKey:@"appid"];
        [signParams setObject:nonce_str forKey:@"noncestr"];
        [signParams setObject:package forKey:@"package"];
        [signParams setObject:self.partnerID forKey:@"partnerid"];
        [signParams setObject:time_stamp forKey:@"timestamp"];
        [signParams setObject:prePayid forKey:@"prepayid"];
        //[signParams setObject: @"MD5"       forKey:@"signType"];
        //生成签名
        NSString *sign  = [self.payRequest createMd5Sign:signParams];
        
        //添加签名
        [signParams setObject:sign forKey:@"sign"];
        [self.debugInfo appendFormat:@"第二步签名成功，sign＝%@\n",sign];
        [self payOrderWithSignedOrderInfo:signParams];
    }else{
        if (self.payFailedActionBlock) {
            BaseResp *response = [[BaseResp alloc] init];
            response.errCode = -1;
            response.errStr = @"获取prepayid失败";
            self.payFailedActionBlock(response);
        }
    }
}

- (void)payOrderWithSignedOrderInfo:(NSDictionary *)orderInfo {
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [orderInfo objectForKey:@"appid"];
    req.partnerId           = [orderInfo objectForKey:@"partnerid"];
    req.prepayId            = [orderInfo objectForKey:@"prepayid"];
    req.nonceStr            = [orderInfo objectForKey:@"noncestr"];
    req.timeStamp           = [[orderInfo objectForKey:@"timestamp"] intValue];
    req.package             = [orderInfo objectForKey:@"package"];
    req.sign                = [orderInfo objectForKey:@"sign"];
    
    [WXApi sendReq:req completion:NULL];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - Accessors

- (void)setPaySucceedActionBlock:(WeChatPayResult)paySucceedActionBlock {
    _paySucceedActionBlock = paySucceedActionBlock;
}

- (void)setPayFailedActionBlock:(WeChatPayResult)payFailedActionBlock {
    _payFailedActionBlock = payFailedActionBlock;
}

#pragma mark - WeChatAuthRequest delegate methods

- (void)onResp:(BaseResp*)resp {
    if([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                if (self.paySucceedActionBlock) {
                    self.paySucceedActionBlock(resp);
                }
                break;
            default:
                if (self.payFailedActionBlock) {
                    self.payFailedActionBlock(resp);
                }
                break;
        }
    }
}

@end
