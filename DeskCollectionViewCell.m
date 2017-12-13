//
//  DeskCollectionViewCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/11.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "DeskCollectionViewCell.h"

@implementation DeskCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (SCREEN_WIDTH == 320) {
        _delWidth.constant = 50;
        _delHeight.constant = 30;
        _editWidth.constant = 50;
        _editHeigth.constant = 30;
    }
    else if (SCREEN_WIDTH == 375){
        _delWidth.constant = 55;
        _delHeight.constant = 35;
        _editWidth.constant = 55;
        _editHeigth.constant = 35;
    }
    else{
        _delWidth.constant = 65;
        _delHeight.constant = 40;
        _editWidth.constant = 65;
        _editHeigth.constant = 40;
    }


    //阴影设置
    _bgView.layer.shadowColor =  [UIColor grayColor].CGColor;    // 阴影颜色//shadowColor阴影颜色
    _bgView.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _bgView.layer.shadowOpacity = 0.3f;//阴影透明度，默认0
    _bgView.layer.shadowRadius = 2.0f;//阴影半径，默认3
    
}

@end
