//
//  EvaluateTopView.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "EvaluateTopView.h"

@implementation EvaluateTopView

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"EvaluateTopView" owner:self options:nil][0];
        self.frame = frame;
        _segment.tintColor = NAV_COLOR;
        [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];

    }
    return self;

}

@end
