//
//  MerchantsMemberTableViewCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/11.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MerchantsMemberTableViewCell.h"

@implementation MerchantsMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (SCREEN_WIDTH == 320) {
        _userNameWidth.constant = 70;
    }
    else if (SCREEN_WIDTH == 375){
        _userNameWidth.constant = 110;
    }
    else{
        _userNameWidth.constant = 140;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
