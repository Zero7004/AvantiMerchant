//  LearningTreasure
//
//  Created by 陈德锋 on 16/12/14.
//  Copyright © 2016年 陈德锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>
#import "UIViewExt.h"
#import "UIView+ViewController.h"

// 当前设备的物理尺寸
#define kScreen_width [UIScreen mainScreen].bounds.size.width

#define kScreen_height [UIScreen mainScreen].bounds.size.height

// 颜色定义
#define kColor(r,g,b,a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

#pragma mark - LBSegementView

// 设置标题选中字体(LBSegementView)
#define segementTitleSelectFont [UIFont systemFontOfSize:16 weight:1.5]

// 设置标题正常字体(LBSegementView)
#define segementTitleNormalFont [UIFont systemFontOfSize:12]

// 设置标题文本颜色(LBSegementView)
#define segementColor_title_color [UIColor whiteColor]

// 设置标题文本选中颜色(LBSegementView)
#define segementColor_title_select_color [UIColor whiteColor]



// 常量
// 分段控件标题之间的间距
UIKIT_EXTERN const CGFloat SegementViewTitlePadding;

// 分段控件底部视图的高度
UIKIT_EXTERN const CGFloat SegementViewBottomViewHeight;

// 分段控件标题缩放的最大比例(与正常状态对比)
UIKIT_EXTERN const CGFloat SegementViewTitleSelectMaxScale;




