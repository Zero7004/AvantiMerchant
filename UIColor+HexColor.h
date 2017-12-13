//
//  UIColor+HexColor.h
//  Mars
//
//  Created by 陈德锋 on 17/3/7.
//  Copyright © 2017年 陈德锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

// 十六进制颜色
+ (UIColor*)colorWithHexString:(NSString*)hex;

+ (UIColor*)colorWithHexString:(NSString*)hex withAlpha:(CGFloat)alpha;

@end
