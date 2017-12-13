//
//  StewardTableViewCell.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "StewardTableViewCell.h"

@implementation StewardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.EditBtn.layer setCornerRadius:5];
//    self.EditBtn.layer.masksToBounds = YES;
    [self.DeleteBtn.layer setCornerRadius:5];
//    self.DeleteBtn.layer.masksToBounds = YES;

    //边框设置
    _bgView.layer.cornerRadius = 7;//设置那个圆角的有多圆
//    _bgView.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
//    _bgView.layer.borderColor = [[UIColor blackColor] CGColor];//设置边框的颜色
//    _bgView.layer.masksToBounds = YES;//设为NO去试试

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
