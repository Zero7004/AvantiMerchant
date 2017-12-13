//
//  EndActiveCell.m
//  AvantiMerchant
//
//  Created by long on 2017/12/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "EndActiveCell.h"

@implementation EndActiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [Border_COLOR CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
