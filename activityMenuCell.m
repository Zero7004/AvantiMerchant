//
//  activityMenuCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "activityMenuCell.h"

@implementation activityMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _goodsThums.layer.cornerRadius = 5;
    
    _stopLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

    _selectBtn.layer.cornerRadius = 5;
    _selectBtn.backgroundColor = NAV_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
