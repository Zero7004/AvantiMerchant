//
//  MenuTableViewCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/25.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _goodsThums.layer.cornerRadius = 5;
    _editBtn.layer.cornerRadius = 3;
    _cancelBtn.layer.cornerRadius = 3;
    _editBtn.layer.borderColor = NAV_COLOR.CGColor;
    _editBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = NAV_COLOR.CGColor;
    _cancelBtn.layer.borderWidth = 1;
    [_editBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    
    _stopLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
