//
//  ShopTableViewCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ShopTableViewCell.h"

@implementation ShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    //边框设置
    _bgView.layer.cornerRadius = 7;//设置那个圆角的有多圆
    //阴影设置
    _bgView.layer.shadowColor =  [UIColor grayColor].CGColor;    // 阴影颜色//shadowColor阴影颜色
    _bgView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _bgView.layer.shadowOpacity = 1.0f;//阴影透明度，默认0
    _bgView.layer.shadowRadius = 4.0f;//阴影半径，默认3
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
