//
//  SHShareKitDefs.h
//  SHShareKit
//
//  Created by RobinShen on 15/8/5.
//  Copyright (c) 2015年 RobinShen. All rights reserved.
//

typedef void(^SHAuthorizationFailedResult)(NSError *error);

// Common
#define kHandleOpenURLNotification @"HandleOpenURLNotification"

// QQ
#define kSHQQAppBundleId @"com.tencent.mqq"
#define kQQDidLoginSucceedNotification @"QQDidLoginSucceedNotification"
#define kQQDidLoginFailedNotification  @"QQDidLoginFailedNotification"
#define kQQDidLogoutNotification  @"QQDidLogoutNotification"

// WeChat
#define kSHWeChatAppBundleId @"com.tencent.xin"
#define kWeChatDidLoginSucceedNotification @"WeChatDidLoginSucceedNotification"
#define kWeChatDidLoginFailedNotification  @"WeChatDidLoginFailedNotification"

// Weibo
#define KSHWeiboAppBundleId @"com.sina.weibo"
#define kSHWeiboRedirectURL @"http://www.wconcept.cn"
#define kWeiboDidLoginSucceedNotification @"WeiboDidLoginSucceedNotification"
#define kWeiboDidLoginFailedNotification  @"WeiboDidLoginFailedNotification"
