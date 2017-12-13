//
//  OperatingStateViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperatingStateViewController : UITableViewController

typedef void(^Stare)(NSString *stare);
@property (nonatomic, copy) Stare block;

@property (nonatomic, strong) NSString *shopImgUrl;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;

@property (strong, nonatomic) NSString *shopAtive;

@end
