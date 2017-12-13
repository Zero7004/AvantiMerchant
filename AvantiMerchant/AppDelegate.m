//
//  AppDelegate.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "LoginViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "SelectShopViewController.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self rootLoginView];
    
    //注册通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"request authorization successed!");
        }
    }];
    //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",settings);
    }];
    //向APNS请求deviceToken
    [[UIApplication sharedApplication] registerForRemoteNotifications];

    
    return YES;
}

+(AppDelegate*)APP{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenStr=[NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenStr =  [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceTokenStr =  [deviceTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenStr =  [deviceTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    [DEFAULT setObject:deviceTokenStr forKey:@"deviceToken"];
    NSLog(@"deviceToken--%@",deviceTokenStr);
    //注册成功，将deviceToken保存到应用服务器
}

//通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    //点击通知进入应用
    UNNotificationContent *content =  response.notification.request.content;
    NSDictionary *userInfo = content.userInfo;
    [self handleRemoteNotificationContent:userInfo];
    NSLog(@"后台接收到推送%@",userInfo);
    
    
}

//收到通知
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //收到推送的消息内容
    UNNotificationContent *content =  notification.request.content;
    NSDictionary *userInfo = content.userInfo;
    NSLog(@"前台接收到推送%@",userInfo);
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
    [self handleRemoteNotificationContent:userInfo];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"远程通知注册失败%@",error);
}


//推送处理
-(void)handleRemoteNotificationContent:(NSDictionary *)notification{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@" notifi = %@", notification);
//    NSString *code = [NSString stringWithFormat:@"%@",notification[@"param"][@"code"]];
    
    //跳转到待处理控制器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTabBarController" object:nil];

    
    NSString *type = [NSString stringWithFormat:@"%@", notification[@"type"]];
    switch ([type integerValue]) {
        case 1:{
            //新订单
            //发送通知给新订单页面处理
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewOrder" object:notification[@"jsonStr"][@"newOrder"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetNewOrder" object:nil];

        }
            break;
        case 2:{
            //退款
            //除了新订单外，其他的直接调用刷新
            //刷新新订单页
            //刷新退款订单页
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushGetNewOrder" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushGetNewRefund" object:nil];

            
        }
            break;
        case 3:{
            //催单
            //刷新催订单页
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushGetNewReminder" object:nil];

        }
            break;
            
            


            
        default:
            break;
    }
    
    
    
    
    


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

-(void)rootLoginView{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    
    LoginViewController *vc = [loginStoryboard instantiateViewControllerWithIdentifier:@"login"];
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    transtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transtion.type = kCATransitionFade;
    self.window.rootViewController = vc;
    [self.window.layer addAnimation:transtion forKey:@"animation"];

    
//    [self rootMainView];
}


-(void)rootMainView{
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    transtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transtion.type = kCATransitionFade;
    self.window.rootViewController = [MainTabBarController shareInstance];
    [self.window.layer addAnimation:transtion forKey:@"animation"];
    
}


//选择商店列表视图
-(void)selectShopView{
    SelectShopViewController *vc = [[SelectShopViewController alloc] init];
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    transtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transtion.type = kCATransitionFade;
    self.window.rootViewController = vc;
    [self.window.layer addAnimation:transtion forKey:@"animation"];

}



@end




