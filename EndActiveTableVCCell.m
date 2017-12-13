//
//  EndActiveTableVCCell.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "EndActiveTableVCCell.h"

@implementation EndActiveTableVCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [Border_COLOR CGColor];
    
    if (SCREEN_WIDTH == 320) {
        _width01.constant = 5;
        _width02.constant = -5;
    }
    else if (SCREEN_WIDTH == 375){
        _width01.constant = 15;
        _width02.constant = -15;
    }
    else{
        _width01.constant = 30;
        _width02.constant = -30;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
