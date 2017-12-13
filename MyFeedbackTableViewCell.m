//
//  MyFeedbackTableViewCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MyFeedbackTableViewCell.h"

@implementation MyFeedbackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];


    _bgView.layer.borderWidth = 1;
    _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
