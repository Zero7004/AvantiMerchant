//
//  ReminderViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderViewController : UITableViewController

@property (nonatomic, strong) NSArray *orderArray;    //新订单列表

@property BOOL isRefresh;

@property (nonatomic, getter=isLoading)BOOL loading;

@end
