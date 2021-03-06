//
//  AppDelegate.m
//  SHShareKitDemo
//
//  Created by Robin Shen on 2020/11/16.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //打开写日志到文件的开关
    [QQApiInterface setSwitchPrintLogToFile:YES];
    //打印日志的回调
    [QQApiInterface startLogWithBlock:^(NSString *logStr) {
        NSLog(@"=================%@",logStr);
    }];
    
    
    [SHShareKitManager registerWeChatApp:@"wxa22013ea289ef1d8" universalLink:@"https://www.atoken.com"];
    [SHShareKitManager registerQQApp:@"101915533"];
    [SHShareKitManager registerWeiboApp:@"xxxxx" universalLink:@"https://www.test.com"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [SHShareKitManager handleOpenURL:url withSourceApplication:sourceApplication];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [SHShareKitManager handleOpenURL:url withSourceApplication:nil];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        return [SHShareKitManager handleUniversalLink:userActivity];
    }
    return YES;
}

@end

