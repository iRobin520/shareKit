//
//  SHShareKitBaseAction.h
//  
//
//  Created by Robin Shen on 2020/11/16.
//

#import <Foundation/Foundation.h>

@interface SHShareKitBaseAction : NSObject
//通用参数
@property (copy, nonatomic) NSString *appIdOrKey;
@property (copy, nonatomic) NSString *secret;

//微信专用
@property (copy, nonatomic) NSString *merchantID;
@property (copy, nonatomic) NSString *partnerID;
@property (copy, nonatomic) NSString *notifyUrl;

//微博专用
@property (copy, nonatomic) NSString *redirectUrl;

@end

