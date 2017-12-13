//
//  TipViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/26.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    _bgView.layer.cornerRadius = 5;
    
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_confirmBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
}

-(void)cancelBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.block(NO);

}


-(void)confirmBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.block(YES);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
