//
//  AgreementViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/22.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*商家自营销协议*//

#import "AgreementViewController.h"

@interface AgreementViewController ()
@property (weak, nonatomic) IBOutlet UIButton *disagreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

- (IBAction)disagreeBtnClick:(id)sender;
- (IBAction)agreeBtnClick:(id)sender;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商家自营销协议";
    
    _disagreeBtn.layer.borderWidth = 1;
    _disagreeBtn.layer.borderColor = NAV_COLOR.CGColor;
    [_disagreeBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_agreeBtn setBackgroundColor:NAV_COLOR];
    [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)disagreeBtnClick:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
    self.block(NO);
}

- (IBAction)agreeBtnClick:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
    self.block(YES);

}
@end
