//
//  LiveTipViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "LiveTipViewController.h"

@interface LiveTipViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtnClick;
- (IBAction)confirmBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *label03;

@end

@implementation LiveTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _bgView.layer.cornerRadius = 7;//设置那个圆角的有多圆
    _confirmBtnClick.layer.cornerRadius = 7;//设置那个圆角的有多圆

    
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
