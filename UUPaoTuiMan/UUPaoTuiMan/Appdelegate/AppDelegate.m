//
//  AppDelegate.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/27.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MyCenterViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()
@property (strong,nonatomic) CLLocationManager * locationManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self setViewController];
    [self.window makeKeyAndVisible];
    [AMapServices sharedServices].apiKey = @"d2cf8fa6e83008a24bb8cc5649ff8047";
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    return YES;
}

- (void)setViewController{
    if (![XLUserMessage getUserLogin]) {
        ViewController *loginVC = loadViewControllerFromStoryboard(@"Main", @"LoginVC");
        UINavigationController *loginNvc = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = loginNvc;
    }else{
        MyCenterViewController *centerVC = [[MyCenterViewController alloc] init];
        UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerVC];
        self.window.rootViewController = centerNav;
    }
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
