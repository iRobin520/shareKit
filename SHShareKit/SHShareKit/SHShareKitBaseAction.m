//
//  SHShareKitBaseAction.m
//  
//
//  Created by Robin Shen on 2020/11/16.
//

#import "SHShareKitBaseAction.h"

@implementation SHShareKitBaseAction

- (NSString *)appIdOrKey {
    if (_appIdOrKey) {
        return _appIdOrKey;
    }
    return @"";
}

- (NSString *)secret {
    if (_secret) {
        return _secret;
    }
    return @"";
}

- (NSString *)merchantID {
    if (_merchantID) {
        return _merchantID;
    }
    return @"";
}

- (NSString *)partnerID {
    if (_partnerID) {
        return _partnerID;
    }
    return @"";
}

- (NSString *)notifyUrl {
    if (_notifyUrl) {
        return _notifyUrl;
    }
    return @"";
}

- (NSString *)redirectUrl {
    if (_redirectUrl) {
        return _redirectUrl;
    }
    return @"";
}

@end
