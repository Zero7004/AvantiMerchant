//
//  NoticeViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface NoticeViewController : UIViewController

@property (strong, nonatomic) NSString *notice;

typedef void(^Noti)(NSString *noti);
@property (nonatomic, copy) Noti block;


@end
