//
//  AddWaiterViewController.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/9.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddWaiterViewController : UIViewController

@property (nonatomic, strong) NSString *titlelable;

@property (nonatomic, strong) NSDictionary *waiterInfo;

typedef void(^WaiterArray)(NSArray *waiterArr);
@property (nonatomic, copy) WaiterArray block;

@end
