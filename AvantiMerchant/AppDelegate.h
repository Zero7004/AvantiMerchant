//
//  AppDelegate.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)APP;

-(void)rootLoginView;

-(void)rootMainView;

-(void)selectShopView;

@end

