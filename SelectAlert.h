//
//  SelectAlert.h
//  LearningTreasure
//
//  Created by 陈德锋 on 16/01/11.
//  Copyright © 2016年 陈德锋. All rights reserved.

#import <UIKit/UIKit.h>

typedef void (^SelectIndex)(NSInteger selectIndex);//编码
typedef void (^SelectValue)(NSString *selectValue);//数值




@interface SelectAlert : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *titles;//string数组

@property (nonatomic, strong) UILabel *titleLabel;//标题label

@property (nonatomic, copy) SelectIndex selectIndex;
@property (nonatomic, copy) SelectValue selectValue;


typedef void(^Close)(void);
@property (nonatomic, copy) Close block;

/*!
 * @abstract 创建弹窗下拉列表类方法
 *
 * @param title 下拉框标题
 * @param titles 下拉框显示的string数组
 * @param selectIndex 选择的index
 * @param selectValue 选择的string
 * @param showCloseButton 显示关闭按钮则关闭点击列表外remove弹窗的功能
 *
 */
+ (SelectAlert *)showWithTitle:(NSString *)title
                        titles:(NSArray *)titles
                   selectIndex:(SelectIndex)selectIndex
                   selectValue:(SelectValue)selectValue
               showCloseButton:(BOOL)showCloseButton;

@end
