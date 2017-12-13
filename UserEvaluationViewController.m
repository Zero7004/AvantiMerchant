//
//  UserEvaluationViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/13.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*用户评价*//

#import "UserEvaluationViewController.h"
#import "EvaluateViewController.h"
#import "StatisticsViewController.h"

@interface UserEvaluationViewController ()

@property (strong, nonatomic) EvaluateViewController *EvaluateVC;
@property (strong, nonatomic) StatisticsViewController *StatisticsVC;


@property (strong, nonatomic) UIButton *userEvaluateBtn;
@property (strong, nonatomic) UIButton *userStatistics;
@property (strong, nonatomic) UILabel *label01;
@property (strong, nonatomic) UILabel *label02;

@end

@implementation UserEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self initSegmentControl];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    [self initTopView];
    [self initControl];
}

//创建顶部按钮
-(void)initTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    topView.backgroundColor = [UIColor clearColor];
    
    _userEvaluateBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 75, 42)];
    [_userEvaluateBtn setTitle:@"用户评价" forState:UIControlStateNormal];
    [_userEvaluateBtn setTitleColor:SELECTColor forState:UIControlStateNormal];
    _userEvaluateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_userEvaluateBtn addTarget:self action:@selector(userEvaluateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _label01 = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 80, 2)];
    _label01.backgroundColor = SELECTColor;
    
    _userStatistics = [[UIButton alloc] initWithFrame:CGRectMake(200 - 75, 0, 75, 42)];
    [_userStatistics setTitle:@"评价统计" forState:UIControlStateNormal];
    [_userStatistics setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _userStatistics.titleLabel.font = [UIFont systemFontOfSize:15];
    [_userStatistics addTarget:self action:@selector(userStatisticsClick) forControlEvents:UIControlEventTouchUpInside];
    _label02 = [[UILabel alloc] initWithFrame:CGRectMake(200 - 80, 42, 80, 2)];
    _label02.backgroundColor = NAV_COLOR;
    
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 3, 1, 35)];
    centerLabel.backgroundColor = [UIColor blackColor];
    
    [topView addSubview:_userEvaluateBtn];
    [topView addSubview:_label01];
    [topView addSubview:_userStatistics];
    [topView addSubview:_label02];
    [topView addSubview:centerLabel];
    self.navigationItem.titleView = topView;
}

//点击用户评价
-(void)userEvaluateBtnClick{
    [_userEvaluateBtn setTitleColor:SELECTColor forState:UIControlStateNormal];
    _label01.backgroundColor = SELECTColor;
    [_userStatistics setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _label02.backgroundColor = NAV_COLOR;

    [_StatisticsVC.view removeFromSuperview];
    [_EvaluateVC.view removeFromSuperview];
    [self.view addSubview:_EvaluateVC.view];
}

//点击评价统计
-(void)userStatisticsClick{
    [_userEvaluateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _label01.backgroundColor = NAV_COLOR;
    [_userStatistics setTitleColor:SELECTColor forState:UIControlStateNormal];
    _label02.backgroundColor = SELECTColor;

    [_StatisticsVC.view removeFromSuperview];
    [_EvaluateVC.view removeFromSuperview];
    [self.view addSubview:_StatisticsVC.view];
}


-(void)initControl{
    _EvaluateVC = [[EvaluateViewController alloc] init];
    
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    _StatisticsVC = [storeStoryboard instantiateViewControllerWithIdentifier:@"Statistics"];
    
    [self addChildViewController:_EvaluateVC];
    
    [self.view addSubview:_EvaluateVC.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
