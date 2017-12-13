//
//  goodListCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/18.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "goodListCell.h"

@implementation goodListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _goodsAttrName = [[UILabel alloc] init];
    
    if (SCREEN_WIDTH <= 375) {
        _goodsName.font = [UIFont systemFontOfSize:11];
    }
    else{
        _goodsName.font = [UIFont systemFontOfSize:12];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
