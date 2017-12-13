//
//  THDatePickerView3.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/29.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THDatePickerViewDelegate <NSObject>

/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer;

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate;

@end

@interface THDatePickerView3 : UIView

@property (copy, nonatomic) NSString *title;
@property (weak, nonatomic) id <THDatePickerViewDelegate> delegate;

/// 显示
- (void)show;

@end
