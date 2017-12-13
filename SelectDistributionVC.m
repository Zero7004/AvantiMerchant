//
//  SelectDistributionVC.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "SelectDistributionVC.h"

@interface SelectDistributionVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *shangjiaBtn;

@property (weak, nonatomic) IBOutlet UIButton *fengniaoBtn;

@property (weak, nonatomic) IBOutlet UILabel *shangjiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *fengniaoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shangjiaHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fengniaoHeight;

- (IBAction)shangjiaBtnClick:(id)sender;
- (IBAction)fengniaoBtnClick:(id)sender;
- (IBAction)confirmBtnClick:(id)sender;
- (IBAction)cancelBtnClick:(id)sender;


@end

@implementation SelectDistributionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _bgView.layer.cornerRadius = 3;
    
    //配送方式 --默认1商家配送，2蜂鸟配送
    if ([DEFAULT objectForKey:@"deStatusPeisong"] == nil) {
        [DEFAULT setObject:@"1" forKey:@"deStatusPeisong"];
    }
    
    if ([[DEFAULT objectForKey:@"deStatus"] isEqualToString:@"1,2"]) {
        [_shangjiaBtn setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
        [_fengniaoBtn setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
        [DEFAULT setObject:@"1" forKey:@"deStatusPeisong"];
    }
    else if([[DEFAULT objectForKey:@"deStatus"] isEqualToString:@"1"]){
        [_shangjiaBtn setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
        _fengniaoBtn.hidden = YES;
        _fengniaoLabel.hidden = YES;
        _shangjiaHeight.constant = 45;
    }
    else{
        [_fengniaoBtn setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
        _shangjiaBtn.hidden = YES;
        _shangjiaLabel.hidden = YES;
        _fengniaoHeight.constant = 15;
    }
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

- (IBAction)shangjiaBtnClick:(id)sender {
    if ([[DEFAULT objectForKey:@"deStatus"] isEqualToString:@"1,2"]) {
        [_shangjiaBtn setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
        [_fengniaoBtn setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
        [DEFAULT setObject:@"1" forKey:@"deStatusPeisong"];
    }
}

- (IBAction)fengniaoBtnClick:(id)sender {
    if ([[DEFAULT objectForKey:@"deStatus"] isEqualToString:@"1,2"]) {
        [_shangjiaBtn setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
        [_fengniaoBtn setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
        [DEFAULT setObject:@"2" forKey:@"deStatusPeisong"];
    }

}

- (IBAction)confirmBtnClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    self.block(YES);
}


- (IBAction)cancelBtnClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    self.block(NO);
}

@end
