//
//  ClassificationCell01.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/30.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ClassificationCell01.h"

@implementation ClassificationCell01

- (void)awakeFromNib {
    [super awakeFromNib];

    _editBtn.layer.borderWidth = 1;
    _editBtn.layer.borderColor = Nav_color.CGColor;
    _addNewBtn.layer.borderWidth = 1;
    _addNewBtn.layer.borderColor = Nav_color.CGColor;
    [_editBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_addNewBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
