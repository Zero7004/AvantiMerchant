//
//  SelectTimeViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/12.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTimeViewController : UIViewController

@property (strong, nonatomic) NSString *time;

typedef void(^SelectTime)(NSString *time);
@property (nonatomic, copy) SelectTime block;


@end
