//
//  EvaluationCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "EvaluationCell.h"

@implementation EvaluationCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _userImg.layer.cornerRadius = 20;
//    _userImg.layer.masksToBounds = YES;
//    
//    _dianzanBtn.layer.cornerRadius = 8;
//    _dianzanBtn.layer.borderWidth = 1;
//    _dianzanBtn.layer.borderColor = [Border_COLOR CGColor];
//    
//    _pinglunBtn.layer.cornerRadius = 8;
//    _pinglunBtn.layer.borderWidth = 1;
//    _pinglunBtn.layer.borderColor = [Border_COLOR CGColor];
//
//    _jubaoBtn.layer.cornerRadius = 8;
//    _jubaoBtn.layer.borderWidth = 1;
//    _jubaoBtn.layer.borderColor = [Border_COLOR CGColor];
    
    _replyBtn.layer.borderWidth = 1;
    _replyBtn.layer.borderColor = NAV_COLOR.CGColor;
    [_replyBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
