//
//  MainTabBarController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "MainTabBar.h"
#import "PendingViewController.h"
#import "OrderManagementViewController.h"
#import "StoreManagementViewController.h"
#import "MineViewController.h"

@interface MainTabBarController ()<MainTabBarDelegate>

@property(nonatomic, weak)MainTabBar *mainTabBar;

@property(nonatomic, strong) PendingViewController *pending;
@property(nonatomic, strong) OrderManagementViewController *orderManagement;
@property(nonatomic, strong) StoreManagementViewController *storeManagement;
@property(nonatomic, strong) MineViewController *mine;


@end

@implementation MainTabBarController

//单例
+(instancetype)shareInstance{
    static MainTabBarController *instance = nil;
    
    instance = [[MainTabBarController alloc] init];

//    static dispatch_once_t tocken;
    
//    dispatch_once(&tocken, ^{
//        
//        instance = [[MainTabBarController alloc] init];
//        
//    });
    return instance;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self SetupMainTaBar];
    [self SetupAllControllers];
//    [self getMerchantInfor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTabBarController) name:@"changeTabBarController" object:nil];

    
}



-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeTabBarController" object:nil];

}


-(void)SetupMainTaBar{
    MainTabBar *mainTaBar = [[MainTabBar alloc] init];
    mainTaBar.frame = self.tabBar.bounds;
    mainTaBar.delegate = self;
    [self.tabBar addSubview:mainTaBar];
    _mainTabBar = mainTaBar;
}

- (void)SetupAllControllers{
    NSArray *titles = @[@"待处理", @"订单管理", @"门店运营", @"我的"];
    NSArray *images = @[@"待处理-黑", @"订单管理-黑", @"门店运营-黑", @"我的-黑"];
    NSArray *selectedImages =  @[@"待处理-蓝", @"订单管理-蓝", @"门店运营-蓝", @"我的-蓝"];
    
    UIStoryboard *pendingStoreboard = [UIStoryboard storyboardWithName:@"Pending" bundle:[NSBundle mainBundle]];
    _pending = [pendingStoreboard instantiateViewControllerWithIdentifier:@"mainPending"];
    [_pending getMerchantInfor];
    
    _orderManagement = [[OrderManagementViewController alloc] init];
    [_orderManagement getOrderInfor];
    
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    _storeManagement = [storeStoryboard instantiateViewControllerWithIdentifier:@"storeHome"];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _mine = [mainStoryboard instantiateViewControllerWithIdentifier:@"mine"];
    
    NSArray *viewControllers = @[_pending, _orderManagement, _storeManagement, _mine];
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController *chileVC = viewControllers[i];
//        [self SetupChildVc:chileVC title:titles[i] image:images[i] selectedImage:selectedImages[i]];
        [self SetupChildVc:chileVC title:titles[i] image:images[i] selectedImage:selectedImages[i] Index:i];
    }
    
    
}

//- (void)SetupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName{
//    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
//    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
//    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
//    childVc.tabBarItem.title = title;
//    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem];
//    [self addChildViewController:nav];
//}

- (void)SetupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName Index:(NSInteger)index{
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:childVc];
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.tag = index;
    [self.mainTabBar addTabBarButtonWithTabBarItem:childVc.tabBarItem];
    [self addChildViewController:nav];
}




#pragma mark --------------------mainTabBar delegate
- (void)tabBar:(MainTabBar *)tabBar didSelectedButtonFrom:(long)fromBtnTag to:(long)toBtnTag{
    self.selectedIndex = toBtnTag;
}



//收到推送时跳转到待处理的控制器
-(void)changeTabBarController{
    //切换视图控制器
    self.selectedIndex = 0;
    //切换底部按钮状态
    [_mainTabBar ChangeTablBatButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
