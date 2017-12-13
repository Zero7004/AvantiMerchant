//  LearningTreasure
//
//  Created by 陈德锋 on 16/12/14.
//  Copyright © 2016年 陈德锋. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController
{
    //获取当前对象的下一响应者
    id next = [self nextResponder];
    while (next != nil) {
        //判断next对象是否为控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            return next;
        }
        
        //获取next对象的下一响应这
        next = [next nextResponder];
    }
    
    return nil;
}
@end
