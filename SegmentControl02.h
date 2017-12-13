//  LearningTreasure
//
//  Created by 陈德锋 on 16/12/14.
//  Copyright © 2016年 陈德锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentControl02 : UIView

/**
 *  初始化静止标题栏（不可左右拖动）
 */
- (instancetype)initStaticTitlesWithFrame:(CGRect)frame;

/**
 *  标题数组
 */
@property (strong, nonatomic) NSArray * titles;

/**
 *  控制器数组
 */
@property (strong, nonatomic) NSArray * viewControllers;

/**
 *  标题正常字体颜色
 */
@property (strong, nonatomic) UIColor * titleNormalColor;

/**
 *  标题选中字体颜色
 */
@property (strong, nonatomic) UIColor * titleSelectColor;

/**
 *  标题是否支持缩放(默认不支持)
 */
@property (assign, nonatomic) BOOL isTitleScale;
/**
 *  设置底部栏颜色(和底部栏图片只能设置一个)
 */
- (void)setBottomViewColor:(UIColor *)color;

/**
 *  设置底部栏图片(和底部栏颜色只能设置一个)
 */
- (void)setBottomViewImage:(UIImage *)image;

/**
 *  取消底部栏
 */
- (void)cancelBottomView;

//收到推送进行跳转
-(void)setScrollViewContenOffsetWithIndext:(NSInteger)index;


@end
