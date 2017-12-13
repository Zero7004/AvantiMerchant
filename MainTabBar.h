//
//  MainTabBar.h
//  Mars
//
//  Created by 陈德锋 on 17/3/7.
//  Copyright © 2017年 陈德锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabBar;

@protocol MainTabBarDelegate <NSObject>

@optional
- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag;
@end

@interface MainTabBar : UIView
- (void)addTabBarButtonWithTabBarItem:(UITabBarItem *)tabBarItem;
@property(nonatomic, weak)id <MainTabBarDelegate>delegate;

-(void)ChangeTablBatButton;


@end
