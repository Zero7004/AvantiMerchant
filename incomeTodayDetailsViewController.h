//
//  incomeTodayDetailsViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/19.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface incomeTodayDetailsViewController : UIViewController

@property (strong, nonatomic) NSDictionary *arrayList;
@property (strong, nonatomic) NSArray *goodsLists;

@property (strong, nonatomic) UITableView *tableView;


@end
