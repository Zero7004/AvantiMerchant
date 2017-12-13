//
//  EnvironmentTipViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "EnvironmentTipViewController.h"

@interface EnvironmentTipViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
- (IBAction)confirmBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation EnvironmentTipViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _bgView.layer.cornerRadius = 5;//设置那个圆角的有多圆
    _confirmBtn.layer.cornerRadius = 5;//设置那个圆角的有多圆

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirmBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
