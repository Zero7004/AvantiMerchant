//
//  OpenShopSelectViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/22.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OpenShopSelectViewController.h"
#import "registrationShopViewController.h"
#import "myApplicationViewController.h"

@interface OpenShopSelectViewController ()

@end

@implementation OpenShopSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    self.view.backgroundColor = [UIColor whiteColor];

    [self initBtnView];
}


-(void)initBtnView{
    UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 20, 50)];
    checkBtn.backgroundColor = NAV_COLOR;
    [checkBtn setTitle:@"查看我的申请" forState:UIControlStateNormal];
    [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkBtn.layer.cornerRadius = 8;
    [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *registrBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 90, SCREEN_WIDTH - 20, 50)];
    registrBtn.backgroundColor = NAV_COLOR;
    [registrBtn setTitle:@"申请分店账号" forState:UIControlStateNormal];
    [registrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registrBtn.layer.cornerRadius = 8;
    [registrBtn addTarget:self action:@selector(registrBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:checkBtn];
    [self.view addSubview:registrBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)checkBtnClick{
    myApplicationViewController *vc = [[myApplicationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)registrBtnClick{
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    registrationShopViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"registrationShop"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
