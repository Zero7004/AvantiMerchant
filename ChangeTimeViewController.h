//
//  ChangeTimeViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeTimeViewController : UIViewController

@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;

typedef void(^ChangeTime)(NSString *startTime, NSString *endTime);
@property (nonatomic, copy) ChangeTime block;

@end
