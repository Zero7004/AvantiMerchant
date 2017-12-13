//
//  LoginSegmentViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "LoginSegmentViewController.h"
#import "SegmentControl.h"
#import "RegisterViewController.h"
#import "PhoneRegisterViewController.h"

@interface LoginSegmentViewController ()

@property (strong, nonatomic) SegmentControl *segmentControl;
@property (strong, nonatomic) RegisterViewController *registerVC;
@property (strong, nonatomic) PhoneRegisterViewController *phoneVC;

@end

@implementation LoginSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topView.backgroundColor = NAV_COLOR;
    UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 53)];
    topTitle.text = @"登 录";
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.font = [UIFont systemFontOfSize:18];
    topTitle.textColor = [UIColor whiteColor];
    [topView addSubview:topTitle];

    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    _phoneVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"PhoneRegister"];
    _phoneVC.loginType = _loginType;
    
    _registerVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"register"];
    _registerVC.loginType = _loginType;
    
    _segmentControl  = [[SegmentControl alloc] initStaticTitlesWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
    _segmentControl.titles = @[@"账号密码登录", @"手机验证登录"];
    _segmentControl.backgroundColor = [UIColor whiteColor];
    _segmentControl.viewControllers = @[_registerVC, _phoneVC];
    _segmentControl.titleNormalColor = [UIColor blackColor];
    _segmentControl.titleSelectColor = NAV_COLOR;
    [_segmentControl setBottomViewColor:NAV_COLOR];
    _segmentControl.isTitleScale = YES;
    
    [self.view addSubview:topView];
    [self.view addSubview:_segmentControl];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
