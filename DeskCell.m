//
//  DeskCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/10.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "DeskCell.h"

@implementation DeskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //阴影设置
    _bgView.layer.shadowColor =  [UIColor grayColor].CGColor;    // 阴影颜色//shadowColor阴影颜色
    _bgView.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _bgView.layer.shadowOpacity = 0.3f;//阴影透明度，默认0
    _bgView.layer.shadowRadius = 2.0f;//阴影半径，默认3
    
    _returnBtn.layer.cornerRadius = 5;
    _takeBtn.layer.cornerRadius = 5;
    _cancelDeskBtn.layer.cornerRadius = 5;
}

@end
