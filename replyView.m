//
//  replyView.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/25.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "replyView.h"

@implementation replyView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"replyView" owner:self options:nil][0];
        self.frame = frame;
    }
    return self;
}


@end
