//
//  inProgreTableVCCell.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "inProgreTableVCCell.h"

@implementation inProgreTableVCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [Border_COLOR CGColor];
    
    //设置按钮边框
    [self.checkDetailsBtn.layer setBorderColor:NAV_COLOR.CGColor];
    [self.checkDetailsBtn.layer setBorderWidth:1.0];
    //设置按钮边框
    [self.cancelBtn.layer setBorderColor:[UIColor redColor].CGColor];
    [self.cancelBtn.layer setBorderWidth:1.0];
    
    if (SCREEN_WIDTH == 320) {
        _width01.constant = 5;
        _width02.constant = -5;
    }
    else if (SCREEN_WIDTH == 375){
        _width01.constant = 15;
        _width02.constant = -15;
    }
    else{
        _width01.constant = 30;
        _width02.constant = -30;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
